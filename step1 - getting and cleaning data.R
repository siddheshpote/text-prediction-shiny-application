library(tm)
library(slam)
library(dplyr)
library(readr)
library(RWeka)
library(ggplot2)
library(R.utils)
library(wordcloud)

# Get directories of the data files that we want to read

us_blogs_dir <- "C:/Users/Siddhesha/Desktop/New folder/en_US/en_US.blogs.txt"
us_news_dir <- "C:/Users/Siddhesha/Desktop/New folder/en_US/en_US.news.txt"
us_twitter_dir <- "C:/Users/Siddhesha/Desktop/New folder/en_US/en_US.twitter.txt"

us_blogs <- readLines(us_blogs_dir, encoding= "UTF-8", warn=FALSE)
us_news <- readLines(us_news_dir, encoding="UTF-8", warn=FALSE)
us_twitter <- readLines(us_twitter_dir, encoding="UTF-8", warn=FALSE)

# Sampling

# These data sets are very large so we have to take samples from them to make the data managable.
# Set seed
set.seed(12345)

# Grab samples from raw data

blogs_sample <- sample(us_blogs, size=3000)
news_sample <- sample(us_news, size=3500)
twitter_sample <- sample(us_twitter, size=3000)

# Corpus

# Now we can combine the samples into a single text corpus

# Combine sample sets to create corpus for training..
# Took sample according the memory available... you can take out more sample for better accuracy
corpus_raw <- c(blogs_sample, news_sample, twitter_sample)

## Memory Usage

# The raw data from the previous steps takes up quite a bit of memory so let's remove them to free up some space.

# Remove raw-er data sets
rm(us_blogs, blogs_sample,
   us_news, news_sample,
   us_twitter, twitter_sample)

## Cleaning

# Now we can remove some unwanted words and punctutation characters. Let's make a function that will make things easier.

# changes special characters to a space character
change_to_space <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

# Begin cleaning!
# Remove non-ASCII characters
corpus <- iconv(corpus_raw, "UTF-8", "ASCII", sub="")
# Make corpus
corpus <- VCorpus(VectorSource(corpus))
## Begin cleaning
# Lowercase all characters
corpus <- tm_map(corpus, content_transformer(tolower))
# Strip whitespace
corpus <- tm_map(corpus, stripWhitespace)
# Remove numbers
corpus <- tm_map(corpus, removeNumbers)
# Remove punctuation characters
corpus <- tm_map(corpus, removePunctuation)
# Remove other characters
corpus <- tm_map(corpus, change_to_space, "/|@|\\|")
# Remove stop words
corpus <- tm_map(corpus, removeWords, stopwords("english"))

# Tokenization

# Now we can create our N-gram models. For our purposes we will only go up to trigrams.

delims <- " \\r\\n\\t.,;:\"()?!"
tokenize_uni <- function(x){NGramTokenizer(x, Weka_control(min=1, max=1, delimiters=delims))}
tokenize_bi  <- function(x){NGramTokenizer(x, Weka_control(min=2, max=2, delimiters=delims))}
tokenize_tri <- function(x){NGramTokenizer(x, Weka_control(min=3, max=3, delimiters=delims))}
unigram <- TermDocumentMatrix(corpus, control=list(tokenize=tokenize_uni))
bigram  <- TermDocumentMatrix(corpus, control=list(tokenize=tokenize_bi ))
trigram <- TermDocumentMatrix(corpus, control=list(tokenize=tokenize_tri))

# Transform N-grams structure to pull out token frequencies
unigram_r <- rollup(unigram, 2, na.rm = TRUE, FUN = sum)
bigram_r <- rollup( bigram, 2, na.rm = TRUE, FUN = sum)
trigram_r <- rollup(trigram, 2, na.rm = TRUE, FUN = sum)

#  Get token frequencies of each N-gram
unigram_tokens_counts <- data.frame(Token = unigram$dimnames$Terms, Frequency = unigram_r$v)
bigram_tokens_counts <- data.frame(Token =  bigram$dimnames$Terms, Frequency =  bigram_r$v)
trigram_tokens_counts <- data.frame(Token = trigram$dimnames$Terms, Frequency = trigram_r$v)

# Sort tokens by frequency
unigram_sorted <- arrange(unigram_tokens_counts, desc(Frequency))
bigram_sorted <- arrange( bigram_tokens_counts, desc(Frequency))
trigram_sorted <- arrange(trigram_tokens_counts, desc(Frequency))

# Save sorted data for word prediction for later purpose
save(unigram_sorted, file = "unigram.RData")
save( bigram_sorted, file = "bigram.RData" )
save(trigram_sorted, file = "trigram.RData")