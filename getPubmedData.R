install.packages("RISmed")
library(RISmed)
search_topic <- 'cancer'
search_query <- EUtilsSummary(search_topic, retmax=100, mindate=2007,maxdate=2017)
summary(search_query)

# see the ids of our returned query
QueryId(search_query)

# get actual data from PubMed
records<- EUtilsGet(search_query)
class(records)

# store it
pubmed_data <- data.frame('PMID'= PMID(records),'Title'=ArticleTitle(records),'Abstract'=AbstractText(records))
head(pubmed_data,1)

pubmed_data$Abstract <- as.character(pubmed_data$Abstract)
pubmed_data$Abstract <- gsub(",", " ", pubmed_data$Abstract, fixed = TRUE)

# see what we have
str(pubmed_data)
write.table(pubmed_data,file = "~/Desktop/demopubmed.txt")
