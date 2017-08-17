library(XML)
library(easyPubMed)
result <- xmlParse(file = "~/desktop/pubmed_result.xml")
result
# PMID
my_PMID <- unlist(xpathApply(result, "//PMID [@Version='1']", saveXML))
# use gsub to remove the tag, also trim long titles
my_PMID <- gsub("(^.{5,10}Title>)|(<\\/.*$)", "", my_PMID)
my_PMID
my_PMID[nchar(my_PMID)>20] <- paste(substr(my_PMID[nchar(my_PMID)>20], 19, 27), sep = "")
print(my_PMID)
my_PMID[1]

# AbstractText
my_AbstractText <- unlist(xpathApply(result, "//AbstractText", saveXML))
# use gsub to remove the tag, also trim long titles
my_AbstractText <- gsub("(^.{5,10}Title>)|(<\\/.*$)", "", my_AbstractText)
my_AbstractText[1]

#ArticleTitle
my_ArticleTitle <- unlist(xpathApply(result, "//ArticleTitle", saveXML))
# use gsub to remove the tag, also trim long titles
my_ArticleTitle <- gsub("(^.{5,10}Title>)|(<\\/.*$)", "", my_ArticleTitle)
my_ArticleTitle[1]

######
pubmed_data <- data.frame('PMID'=my_PMID[1],'Title'=my_ArticleTitle[1],'Abstract'=my_AbstractText[1])
head(pubmed_data,1)

