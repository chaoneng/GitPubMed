library(pubmed.mineR)

abstracts <- readabs('C:/Users/cnwang/Desktop/pubmed_result.txt')
#abstractsxml<-xmlreadabs("~/desktop/pubmed_result.xml")
#abstractsxml
#abstracts@PMID
pmids<- abstracts@PMID
pmids


#install.packages("RISmed")
require(RISmed)
search_topic <- pmid

######
#Get pubmed informatino
######

result <- data.frame()

for (i in 1:length(pmid)) {
  
  search_query <- EUtilsSummary(search_topic[i])
  records<- EUtilsGet(search_query)
  
  pubmedPMID= PMID(records)
  pubmedYearPubmed=YearPubmed(records)
  pubmedAbstractText=AbstractText(records)
  pubmedArticle=MedlineTA(records)
  
  result[i, 1] <- pubmedPMID
  result[i, 2] <- pubmedYearPubmed
  result[i, 3] <- pubmedAbstractText
  result[i, 4] <- pubmedArticle
}
colnames(result) <- c("pubmedPMID","pubmedYearPubmed","pubmedAbstractText","pubmedArticle")

######
#Journal conunt
######
journal<-result$pubmedArticle

cancer_journal_count <- as.data.frame(table(journal))
cancer_journal_count_top25 <- cancer_journal_count[order(-cancer_journal_count[,2]),][1:5,]

journal_names <- paste(cancer_journal_count_top25$journal,"[jo]",sep="")

total_journal <- NULL
for (i in journal_names){
  perjournal <- EUtilsSummary(i, type='esearch', db='pubmed',mindate=1980, maxdate=2013)
  total_journal[i] <- QueryCount(perjournal)
}

journal_cancer_total <- cbind(cancer_journal_count_top25,total_journal)
names(journal_cancer_total) <- c("journal","cancer_publications","Total_publications")
journal_cancer_total$cancer_publications_normalized <- journal_cancer_total$cancer_publications / journal_cancer_total$Total_publications

write.table(journal_cancer_total,"C:/Users/cnwang/Desktop/cancer_publications_per_journal.txt",quote=F,sep="\t",row.names=F)

pubs_per_journal <- read.table("C:/Users/cnwang/Desktop/cancer_publications_per_journal.txt",header = T,sep="\t")


#plot
library(ggplot2)
ggplot(pubs_per_journal,aes(journal, cancer_publications,fill=journal)) + geom_bar(stat="identity")+
  coord_flip()+
  theme(legend.position="none")

ggplot(pubs_per_journal ,aes(journal, cancer_publications_normalized,fill=journal)) + geom_bar(stat="identity")+
  coord_flip()+
  theme(legend.position="none")

####

