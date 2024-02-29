install.packages(c('ggplot2','arules','arulesViz'))

library(arules)

options(warn=-1)

lastfm <- read.csv('lastfm.csv')
head(lastfm)

lastfm$user <- factor(lastfm$user)

playlist <- split(x=lastfm[,"artist"],f=lastfm$user)

playlist <- lapply(playlist,unique)

playlist <- as(playlist,"transactions")

# Make a frequency plot of the transactions with a support of 0.08 or greater. We can find out the the most popular artists. The below plot shows that the 3 most popular artists are coldplay, radiohead and the beatles.  

itemFrequencyPlot(playlist, support = .08, cex.names = .6, col = rainbow(4))

musicrules <- apriori(playlist,parameter=list(support=.01,confidence=.45))
inpect6sort <- inspect(sort(subset(musicrules, subset=lift > 6), by="confidence"))
library(arulesViz)

plot(musicrules, method = "grouped", control = list(k= 20))
plot(musicrules, method = NULL, measure = "support", shading = "lift", interactive = F)


# Find top 15 rules for support, confidence, and lift
top_rules_support <- head(sort(musicrules, by = "support"), 15)
top_rules_confidence <- head(sort(musicrules, by = "confidence"), 15)
top_rules_lift <- head(sort(musicrules, by = "lift"), 15)

# Display top rules
cat("Top 15 rules for Support:\n")
inspect(top_rules_support)

cat("\nTop 15 rules for Confidence:\n")
inspect(top_rules_confidence)

cat("\nTop 15 rules for Lift:\n")
inspect(top_rules_lift)

# Visualization 1: Scatterplot
plot(top_rules_support, method = "scatterplot", jitter = 0)

# Visualization 2: Network plot
plot(top_rules_lift, method = "graph", control = list(type = "items"))
