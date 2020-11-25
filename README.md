# word-prediction-application
This is a shiny web application that predicts a next word that is best suited while you are typing a sentence

## Task
As a part of the data science specialization by John Hopkins university a capstone projected based on NLP was required to complete the certification.. The follwing are the task required to complete the project
- Step-1 - load the given data set and perform the cleaning actions 
- Step-2- Perform some exploratory analysis 
- Step-3- Tokenize te data(i.e split the sentences into n-grams as per requirement)
- Step-4- Create a model for prediction(in our case we used Katz backoff model)
- Step-5- Create a shiny app that demonstrates the word prediction by our model
- step 6- create a presentation that demonstrates a short presentation on whatever is done in the project

## Initial steps 
1. The corpus for the given project can be here
[here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)
2. The loading of the data and the exploratory analysis done can be found [here](https://rpubs.com/SiD92/690013)

## About the Prediction model
1. The app used Katz - backoff algorithm for predict the next words based on the previous words... More about Katz backoff algorithm can be found on [wikipedia page](https://en.wikipedia.org/wiki/Katz%27s_back-off_model)
2. The Rweka, tm, Wordcloud and ggplot2 were the most helpful packages while creating this project...
3. The basic logic used while creating the model was that the probabilty of occurance of the next word basically depends on the probability of occurance of the last word of the input and not the probablity of occurance of the whole sentence..

## About the application

1. The shiny app that predicts the next word can be found [here](https://sid92.shinyapps.io/word_prediction_app/)
2. The shiny app is a simple application that predicts the next word as you type the sentence... it only predicts one word and has no complicated interface

