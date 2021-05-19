library(NLP)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(ngram)
library(tidytext)
library(tidyr)
library(dplyr)
library(textcat)
library(ngram)
library(quanteda)
library(qdap)
library(data.table)
library(quanteda.textstats)

# Set the working directories
setwd("C:/Users/balaj/OneDrive/My Learnings/Data Science/Course 10/Final Project")

# Download profanities file
badwordurl <- "https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en"
# The URL consists of profanity, that would be removed from the samples. 

if(!file.exists("badwords.txt")){
  download.file(url=badwordurl, destfile="badwords.txt")
}
profanity <- readLines("badwords.txt",encoding="UTF-8", skipNul = TRUE)

twitterfile<-'en_US.twitter.txt'
blogfile<-'en_US.blogs.txt'
newsfile<-'en_US.news.txt'

linestoread<-150000 # we will read three files to make the mark of 350000 words and 150 documents
blog.line<-readLines(blogfile,encoding="UTF-8", skipNul = TRUE, n=linestoread)
twitter.line<-readLines(twitterfile,encoding="UTF-8", skipNul = TRUE,n=linestoread)
news.line<-readLines(newsfile,encoding="UTF-8", skipNul = TRUE,n=linestoread)

# Set the dataset
s_all<-c(blog.line,twitter.line,news.line)
s_all <- gsub("[^a-zA-Z0-9 ]","",s_all)

# remove unwanted files from the global environment to free space
rm(blog.line)
rm(blogfile)
rm(news.line)
rm(newsfile)
rm(twitter.line)
rm(twitterfile)

# Create a function called token maker. We will use the tokenizer from the quanteda package
token_maker <-function(r_file){
  temp <- Corpus(VectorSource((r_file)))
  temp <- tm_map(temp, content_transformer(function(x) iconv(enc2utf8(x), sub = "byte")))
  temp <- tm_map(temp, removeNumbers)
  temp <- tm_map(temp, content_transformer(tolower))
  temp <- tm_map(temp, removePunctuation)
  temp <- tm_map(temp,removeWords,stopwords("english"))
  temp <- tm_map(temp, removeWords, profanity)

  s_token<-tokens(corpus(temp),
                  what = "word",
                  remove_punct = TRUE,
                  remove_symbols = TRUE,
                  remove_numbers = TRUE,
                  remove_url = TRUE,
                  remove_separators = TRUE,
                  stopwords(source = "smart"),
                  split_hyphens = TRUE,
                  include_docvars = TRUE,
                  padding = FALSE,
                  verbose = quanteda_options("verbose"))
  
  s_token<-tokens_remove(s_token,min_nchar = 2,case_insensitive = TRUE )
  return(s_token)
}

# Use token to create dataframe. The quanteda gives the dataframe arranged by the frequency. This function uses gram as a input

corpus_maker<-function(s_token,grams){
  s_matrix <- dfm(tokens_ngrams((s_token),n=grams, skip = 0L, concatenator = " "))
  s_freq<-textstat_frequency(s_matrix )
  return(s_freq)
}

# Use the readfile and tokenize
s_token       <- token_maker(s_all)
train_ngram_1 <- corpus_maker(s_token,1)
train_ngram_2 <- corpus_maker(s_token,2)
train_ngram_3 <- corpus_maker(s_token,3)
train_ngram_4 <- corpus_maker(s_token,4)
rm(s_all)

# Change the dataframe in a useful structure for comparison with the input text

train_ngram_1$pct<-train_ngram_1$frequency/sum(train_ngram_1$frequency)
train_ngram_1$cumsum<-cumsum(train_ngram_1$pct)
train_ngram_1$word3<-train_ngram_1$feature
train_ngram_1$word2<-NA
train_ngram_1$word1<-NA
train_ngram_2[c("word1","word2")]<-stringr:: str_split_fixed(train_ngram_2$feature, " ", 2)
train_ngram_2$word3<-NA
train_ngram_3[c("word1","word2","word3")]<-stringr:: str_split_fixed(train_ngram_3$feature, " ", 3)
train_ngram_4[c("word1","word2","word3","word4")]<-stringr:: str_split_fixed(train_ngram_4$feature, " ", 4)

saveRDS(train_ngram_1,file = "C:/Users/balaj/OneDrive/My Learnings/Data Science/Course 10/Final Project/train_ngram_1.rds")
saveRDS(train_ngram_2,file = "C:/Users/balaj/OneDrive/My Learnings/Data Science/Course 10/Final Project/train_ngram_2.rds")
saveRDS(train_ngram_3,file = "C:/Users/balaj/OneDrive/My Learnings/Data Science/Course 10/Final Project/train_ngram_3.rds")
saveRDS(train_ngram_4,file = "C:/Users/balaj/OneDrive/My Learnings/Data Science/Course 10/Final Project/train_ngram_4.rds")

