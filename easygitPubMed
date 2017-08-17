library(easyPubMed)
new_PM_query <- "(cancer) AND (2017)"
out.B <- batch_pubmed_download(pubmed_query_string = new_PM_query, dest_file_prefix = "apex1_sample")
out.B 

# Retrieve the full name of the XML file downloaded in the previous step
#new_PM_file <- out.B[1]
new_PM_file <-"pubmed_result.xml"
my_PM_list <- articles_to_list(new_PM_file)
class(my_PM_list[[2]])
#cat(substr(my_PM_list[[2]], 1, 984))

curr_PM_record <- my_PM_list[[2]]
#custom_grep(curr_PM_record, tag = "LastName", format = "char")
my.df <- article_to_df(curr_PM_record)
colnames(my.df)
my.df$abstract
my.df$pmid
################
#new_PM_file
#new_PM_df <- table_articles_byAuth(pubmed_data = new_PM_file, included_authors = "first", max_chars = 0)

# Alternatively, the output of a fetch_pubmed_data() could have been used
#colnames(new_PM_df)
#new_PM_df$journal 
# Printing a sample of the resulting data frame
#new_PM_df$address <- substr(new_PM_df$address,1,54)
#new_PM_df$jabbrv <- substr(new_PM_df$jabbrv)
#print(new_PM_df[c("pmid", "year", "jabbrv", "lastname", "address","abstract")])  

#pubmed_data <- data.frame('PMID'= new_PM_df$pmid,'YearPubmed'=new_PM_df$year,'Title'=new_PM_df$title,'Abstract'=new_PM_df$abstract)
#head(pubmed_data,1)

#import SQL
library(RMySQL)
library(dbConnect)
connect <- dbConnect(MySQL(), dbname = "pubmed", username="root", password="root") 
#Q:Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
#AFor MAMP ln -s /Applications/MAMP/tmp/mysql/mysql.sock /tmp/mysql.sock

dbListTables(connect)


pubmed_data <- data.frame('PMID'= my.df$pmid,'YearPubmed'=my.df$year,'Title'=my.df$title,'Abstract'=my.df$abstract)
head(pubmed_data,1)

dbWriteTable(connect,"easydemo",pubmed_data, overwrite=T) 
dbListTables(connect)


