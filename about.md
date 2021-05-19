
## Application Development

This application is developed as part of the requirement for the Coursera Data Science Capstone Course. The goal of the project is to build a predictive text model combined with a shiny app UI that will predict the next word as the user types a sentence similar to the way most smart phone keyboards are implemented today using the technology of Swiftkey.

## How does the application work

First the application takes the words as a string, breaks them into grams. Now, these grams are compared against a reference grams that has been constructed using the file smapled from twitter and blogs. The science behind this is that is the reference words are around 300,000 words, they become representative of the language. 

A backward step process is followed. 

Step1: The 3 grams input is referenced with 4 grams reference and 4th word is the prediction

Step 2: If Step 1 fails, then a 2 gram input is referenced against 3 grams reference and 3rd word is prediction

Step 3: If Step 2 fails, then a 1 gram input is referenced against 2 grams reference and 3rd word is prediction

Step 4: If Step 3 fails, then a most frequently used word based on a probability distribution is suggested. 


