# Check if the package is already installed
if (!require(rvest)) {
  # Install the package if it is not already installed
  install.packages("rvest")
}
if (!require(sentimentr)) {
  # Install the sentimentr package if it's not already installed
  install.packages("sentimentr")
}

if (!require(ggplot2)) {
  # Install the package if it is not already installed
  install.packages("ggplot2")
}

# Load packages
library(rvest)
library(sentimentr)
library(ggplot2)

# Define the URL of the website to be scraped
url <- "https://www.mtemkit.com"

# Read the HTML from the website
html <- read_html(url)

# Use CSS selectors to extract the text of interest
text <- html_text(html_nodes(html,"p"))

# Clean the text
text <- gsub("[^a-zA-Z ]","",text)
text <- tolower(text)

# Perform sentiment analysis and assign a label to each text
sentiment_score <- sentiment(text)$sentiment
sentiment_label <- ifelse(sentiment_score > 0, "positive", 
                 ifelse(sentiment_score == 0, "neutral", "negative"))

# Create a visualization
data <- data.frame(sentiment_score, sentiment_label)
data <- na.omit(data)
ggplot(data, aes(x = sentiment_score, fill = sentiment_label)) +
  geom_histogram(binwidth = 0.1) +
  xlim(-1,1) +
  xlab("Sentiment Score") +
  ylab("Density")+
  scale_fill_manual(name = "Sentiment",
                values = c("positive" = "green", "neutral" = "gray", "negative" = "red"))+
guides(fill=guide_legend(title="Sentiment"))+
stat_density(geom = "line", aes(y = ..density..), color = "black", linewidth = 1)