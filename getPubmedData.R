#install.packages("RISmed")
library(RISmed)
search_topic <- 'cancer'
ptm <- proc.time()
search_query <- EUtilsSummary(search_topic, retmax=250017, mindate=2016,maxdate=2017)
proc.time() - ptm

summary(search_query)

# see the ids of our returned query
QueryId(search_query)

# get actual data from PubMed
ptm <- proc.time()
records<- EUtilsGet(search_query)
class(records)
proc.time() - ptm

# store it
#pubmed_data <- data.frame(YearPubmed(records))
pubmed_data <- data.frame('PMID'= PMID(records),'YearPubmed'=YearPubmed(records),'Title'=ArticleTitle(records),'Abstract'=AbstractText(records))
head(pubmed_data,1)

# Year, Month, Day, Author, ISSN, Language, PublicationStatus, ArticleId, CopyrightInformation, Country, GrantID. 
pubmed_data$Abstract <- as.character(pubmed_data$Abstract)
pubmed_data$Abstract <- gsub(",", " ", pubmed_data$Abstract, fixed = TRUE)

# see what we have
str(pubmed_data)
#write.table(pubmed_data,file = "~/Desktop/cancer_pubmed_07_17.txt")

#import SQL
library(RMySQL)
library(dbConnect)
connect <- dbConnect(MySQL(), dbname = "pubmed", username="root", password="root") 
#Q:Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
#AFor MAMP ln -s /Applications/MAMP/tmp/mysql/mysql.sock /tmp/mysql.sock

dbListTables(connect)

pubmed_data <- data.frame('PMID'= PMID(records),'YearPubmed'=YearPubmed(records),'Title'=ArticleTitle(records),'Abstract'=AbstractText(records))
head(pubmed_data,1)

dbWriteTable(connect,"demo",pubmed_data, overwrite=T) 
dbListTables(connect)
