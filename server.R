#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
suppressWarnings(library(tm))



# Load Quadgram,Trigram, Bigram  and Unigram Data frame files
train_ngram_1<-readRDS("train_ngram_1.rds")
train_ngram_2<-readRDS("train_ngram_2.rds")
#train_ngram_3<-readRDS("train_ngram_3.rds")
#train_ngram_4<-readRDS("train_ngram_4.rds")

# Get the string from the user
Predict <- function(x) {
    string1 <- removeNumbers(removePunctuation(tolower(x)))
    string1 <- strsplit(string1, " ")[[1]]
    predictor<-data.frame("pred")
    predictor$pred<-NA
    predictor$mesg<-"No Match found"
    
    
    if(length(string1)>3){
    string1<-tail(string1,2)
    
    #predictor$pred<-train_ngram_4$word4[train_ngram_4$word1==string1[1] & train_ngram_4$word2==string1[2] & train_ngram_4$word3==string1[3] ][1]
    #if(!is.na(predictor$pred)){predictor$mesg<-"Matching ngram4"}
    
    }
    
    if(length(string1)==2 | is.na(predictor$pred)){
        string1<-tail(string1,1)
        
        #predictor$pred<-train_ngram_3$word3[train_ngram_3$word1==string1[1] & train_ngram_3$word2==string1[2]][1]
        #if(!is.na(predictor$pred)){predictor$mesg<-"Matching ngram3"}
        
    }
    
    if(length(string1)==1| is.na(predictor$pred)){
        string1<-tail(string1,1)
        
        predictor$pred<-train_ngram_2$word2[train_ngram_2$word1==string1[1]][1]
        if(!is.na(predictor$pred)){predictor$mesg<-"Matching ngram2"}
        
    }
    
    if(is.na(predictor$pred)){
        predictor$pred<-sample(x = train_ngram_1$feature, prob = train_ngram_1$pct,size=1)
        predictor$mesg<-"Most frequent word"
        
    }
    return(predictor)
    
}


# Shiny Server

shinyServer(function(input, output) {
    output$prediction <- renderPrint({
        result <- Predict(input$inputString)
        len<-length(result$pred)
        output$O_text2 <- renderText({result$mesg[len]})
        result$pred[len]
    });
    
    output$O_text1 <- renderText({
        input$inputString});
    #session$allowReconnect(TRUE)
}
)