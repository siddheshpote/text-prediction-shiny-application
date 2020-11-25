library("ggplot2")
library("tm")
library("wordcloud")
library("quanteda")

filestats <- function(text_file, lines){
  filesize <- file.info(text_file)[1]/1024^2
  nchars <- lapply(lines, nchar)
  maxchars <- which.max(nchars)
  wordcount <- sum(sapply(strsplit(lines, "//s+"), length))
  return(c(text_file, format(round(as.double(filesize),2), nsmall= 2), length(lines), maxchars, wordcount))
}
blogstat <- filestats("en_US.blogs.txt", blogs)
newstat <- filestats("en_US.news.txt", news)
twitterstat <- filestats("en_US.twitter.txt", twitter)
testsumm <- c(blogstat, newstat, twitterstat)
df <- data.frame(matrix(unlist(testsumm), nrow = 3, byrow = T))
colnames(df) <- c("text_file", "size(Mb)", "line_count", "max line length", "words count")
print(df)

make_corpus <- function(test_file){
  gen_corp <- paste(test_file, collapse = " ")
  gen_corp<- VectorSource(gen_corp)
  gen_corp <- Corpus(gen_corp)
}

clean_corp <- function(corp_data){
  corp_data <- tm_map(corp_data, removeNumbers)
  corp_data <- tm_map(corp_data, content_transformer(tolower))
  corp_data<- tm_map(corp_data, removeWords, stopwords("english"))
  corp_data<- tm_map(corp_data, removePunctuation)
  corp_data<- tm_map(corp_data, stripWhitespace)
  return (corp_data)
}
high_freq_words <-  function(corp_data){
  term_sparse <- DocumentTermMatrix(corp_data)
  #convert our term-document-matrix into normal matrix
  term_matrix <- as.matrix(term_sparse)
  freq_words <- colSums(term_matrix)
  freq_words <- as.data.frame(sort(freq_words, decreasing = TRUE))
  freq_words$words <- rownames(freq_words)
  colnames(freq_words) <- c("frequency", "word")
  return(freq_words)
}

## Bar Chart of High Frequency words
news_text <- sample(news, round(0.1*length(news)), replace = F)
news_corp <- make_corpus(news_text)
news_corp <- clean_corp(news_corp)
news_high_freq_words <- high_freq_words(news_corp)
news_high_freq_words1 <- news_high_freq_words[1:15, ]

blogs_text <- sample(blogs, round(0.1*length(blogs)), replace = F)
blogs_corp <- make_corpus(blogs_text)
blogs_corp<- clean_corp(blogs_corp)
blogs_high_freq_words <- high_freq_words(blogs_corp)
blogs_high_freq_words1 <- blogs_high_freq_words[1:15, ]

twitter_text <- sample(twitter, round(0.1*length(twitter)), replace = F)
twitter_corp <- make_corpus(twitter_text)
twitter_corp<- clean_corp(twitter_corp)
twitter_high_freq_words <- high_freq_words(twitter_corp)
twitter_high_freq_words1 <- twitter_high_freq_words[1:15, ]




news_text1 <- sample(news_text, round(0.1*length(news_text)), replace = F)
news_tokens <- tokens(news_text1, what = "word", remove_numbers = TRUE, remove_punct = TRUE, remove_separators = TRUE, remove_symbols = TRUE)
news_tokens <- tokens_tolower(news_tokens)
news_tokens <- tokens_select(news_tokens, stopwords(), selection = "remove")

news_unigram <- tokens_ngrams(news_tokens, n = 1) ## unigram
news_unigram.dfm <- dfm(news_unigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

news_bigram <- tokens_ngrams(news_tokens, n = 2) ## bigram
news_bigram.dfm <- dfm(news_bigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

news_trigram <- tokens_ngrams(news_tokens, n = 3) ## trigram
news_trigram.dfm <- dfm(news_trigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

topfeatures(news_unigram.dfm, 20) ## 20 top unigram words of news

topfeatures(news_bigram.dfm, n= 20) ## 20 top bigram words of news

topfeatures(news_trigram.dfm, n= 20) ## 20 top trigram words of news

blogs_text1 <- sample(blogs_text, round(0.1*length(blogs_text)), replace = F)
blogs_tokens <- tokens(blogs_text1, what = "word", remove_numbers = TRUE, remove_punct = TRUE, remove_separators = TRUE, remove_symbols = TRUE)
blogs_tokens <- tokens_tolower(blogs_tokens)
blogs_tokens <- tokens_select(blogs_tokens, stopwords(), selection = "remove")

blogs_unigram <- tokens_ngrams(blogs_tokens, n = 1) ## unigram
blogs_unigram.dfm <- dfm(blogs_unigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

blogs_bigram <- tokens_ngrams(blogs_tokens, n = 2) ## bigram
blogs_bigram.dfm <- dfm(blogs_bigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

blogs_trigram <- tokens_ngrams(blogs_tokens, n = 3) ## trigram
blogs_trigram.dfm <- dfm(blogs_trigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

topfeatures(blogs_unigram.dfm, 20) ## 20 top unigram words of blogs

topfeatures(blogs_bigram.dfm, n= 20) ## 20 top bigram words of blogs

topfeatures(blogs_trigram.dfm, n= 20) ## 20 top trigram words of blogs

twitter_text1 <- sample(twitter_text, round(0.1*length(twitter_text)), replace = F)
twitter_tokens <- tokens(twitter_text1, what = "word", remove_numbers = TRUE, remove_punct = TRUE, remove_separators = TRUE, remove_symbols = TRUE)
twitter_tokens <- tokens_tolower(twitter_tokens)
twitter_tokens <- tokens_select(twitter_tokens, stopwords(), selection = "remove")

twitter_unigram <- tokens_ngrams(twitter_tokens, n = 1) ## unigram
twitter_unigram.dfm <- dfm(twitter_unigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

twitter_bigram <- tokens_ngrams(twitter_tokens, n = 2) ## bigram
twitter_bigram.dfm <- dfm(twitter_bigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

twitter_trigram <- tokens_ngrams(twitter_tokens, n = 3) ## trigram
twitter_trigram.dfm <- dfm(twitter_trigram, tolower = TRUE, remove = stopwords("english"), remove_punct = TRUE)

topfeatures(twitter_unigram.dfm, 20) ## 20 top unigram words of twitter

topfeatures(twitter_bigram.dfm, n= 20) ## 20 top bigram words of twitter

topfeatures(twitter_trigram.dfm, n= 20) ## 20 top trigram words of twitter