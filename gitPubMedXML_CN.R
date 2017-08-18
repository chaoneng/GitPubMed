ptm <- proc.time()
library(XML)
library(easyPubMed)
result <- xmlParse(file = "~/desktop/pubmed_result_cancer_2017.xml")
result

# PMID
my_PMID <- unlist(xpathApply(result, "//PMID", saveXML))
my_PMID [1]
#my_PMID <- gsub("(^.{5,10}Title>)|(<\\/.*$)", "", my_PMID)
my_PMID <- gsub("(^.PMID Version=\"1\">)|(<\\/.*$)", "", my_PMID)
my_PMID
#print(my_PMID)
#my_PMID[1]

# Year
my_Year <- unlist(xpathApply(result, "//DateCreated/Year", saveXML))
my_Year[nchar(my_Year)>7] <- paste(substr(my_Year[nchar(my_Year)>7], 7, 10), sep = "")
my_Year

# Month
my_Month<- unlist(xpathApply(result, "//DateCreated/Month", saveXML))
my_Month[nchar(my_Month)>8] <- paste(substr(my_Month[nchar(my_Month)>8], 8, 9), sep = "")
my_Month

# Day
my_Day <- unlist(xpathApply(result, "//DateCreated/Day", saveXML))
my_Day <- gsub("(^.Day>)|(<\\/.*$)", "", my_Day)
my_Day

#Journal
my_ISOAbbreviatio <- unlist(xpathApply(result, "//ISOAbbreviation", saveXML))
#my_titles <- gsub("(^.{5,10}Title>)|(<\\/.*$)", "", my_titles)
# use gsub to remove the tag, also trim long ISOAbbreviation
my_ISOAbbreviatio <- gsub("(^.ISOAbbreviation>)|(<\\/.*$)", "", my_ISOAbbreviatio)
my_ISOAbbreviatio


#ELocationID
my_ELocationID <- unlist(xpathApply(result, "//ELocationID [@EIdType='doi']", saveXML))
# use gsub to remove the tag, also trim long ELocationID
my_ELocationID <- gsub("(^.ELocationID EIdType=\"doi\" ValidYN=\"Y\">)|(<\\/.*$)", "", my_ELocationID)
my_ELocationID

#Author
my_AuthorList <- unlist(xpathApply(result, "//AuthorList [@CompleteYN='Y']", saveXML))
my_AuthorList
#my_AuthorList <- gsub("(^.{5,10}Title>)|(<\\/.*$)", "", my_AuthorList)
#my_AuthorList[1]

#ArticleTitle
my_ArticleTitle <- unlist(xpathApply(result, "//ArticleTitle", saveXML))
# use gsub to remove the tag, also trim long ArticleTitle
my_ArticleTitle <- gsub("(^.ArticleTitle>)|(<\\/.*$)", "", my_ArticleTitle)
my_ArticleTitle


######
#pubmed_data <- data.frame('PMID'=my_PMID,'Year'=my_Year,'Month'=my_Month,'Day'=my_Day, 
#'Journal'=my_ISOAbbreviatio,'Title'=my_ArticleTitle,'ELocationID'=my_ELocationID,'Author'=my_AuthorList,
#'ArticleTitle'=my_ArticleTitle)
#head(pubmed_data,1)

#import SQL
library(RMySQL)
library(dbConnect)
connect <- dbConnect(MySQL(), dbname = "pubmed", username="root", password="root") 
#Q:Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
#AFor MAMP ln -s /Applications/MAMP/tmp/mysql/mysql.sock /tmp/mysql.sock

dbListTables(connect)

pubmed_data <- data.frame('PMID'=my_PMID,'Year'=my_Year,'Month'=my_Month,'Day'=my_Day, 
                          'Journal'=my_ISOAbbreviatio,'Title'=my_ArticleTitle,'ELocationID'=my_ELocationID,'Author'=my_AuthorList,
                          'ArticleTitle'=my_ArticleTitle)

dbWriteTable(connect,"pubmed_info",pubmed_data, overwrite=T) 
dbListTables(connect)

###################
ptm <- proc.time()
library(pubmed.mineR)
abstractsxml<-xmlreadabs("~/desktop/pubmed_result_cancer_2017.xml")
abstractsxml
abstractsxml@Journal
abstractsxml@PMID

pubmed_data <- data.frame('Journal'= abstractsxml@Journal,'PMID'=abstractsxml@PMID,'Abstract'=abstractsxml@Abstract)
head(pubmed_data,1)
#str(pubmed_data)
#write.table(pubmed_data,file = "~/Desktop/cancer_pubmed_xml.txt")

#import SQL

library(RMySQL)
library(dbConnect)
connect <- dbConnect(MySQL(), dbname = "pubmed", username="root", password="root") 
#Q:Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
#AFor MAMP ln -s /Applications/MAMP/tmp/mysql/mysql.sock /tmp/mysql.sock

dbListTables(connect)
pubmed_data <- data.frame('Journal'= abstractsxml@Journal,'PMID'=abstractsxml@PMID,'Abstract'=abstractsxml@Abstract)


dbWriteTable(connect,"pubmed_abstracts",pubmed_data, overwrite=T) 
dbListTables(connect)
proc.time() - ptm
