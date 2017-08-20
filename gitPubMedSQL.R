###################
ptm <- proc.time()
library(pubmed.mineR)
abstractsxml<-xmlreadabs("~/desktop/pubmed_result_01_06_17.xml")
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
