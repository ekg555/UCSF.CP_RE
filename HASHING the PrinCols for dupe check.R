setwd("c:/Users/ekonagaya/Desktop")

library(readxl)
library(readxl)
library(digest)
library(tictoc)
library(magrittr)
library(dplyr)

tic()
timestp <- format(Sys.time(), "%Y-%m-%d.%H")
reportfile <- paste0('Dupes_(',timestp,').csv')
dat1 <- read_excel('ALL EK ID Doc 3.26.xlsx')

dat1.hash <- apply(dat1[-1],1,function(x) sha1(unlist(x)) )
hash.tab <- cbind(dat1[,1:4], dat1.hash); View(head(hash.tab))

#anyDuplicated(hash.tab$dat1.hash) 
Dupes <- hash.tab[duplicated(hash.tab$dat1.hash),] 
Dupes %>% arrange(`Major Project #`, `Type of Drawing`) %>% select(`Seq ID`, `dat1.hash`, `Major Project #`, `ProjectName`, `Type of Drawing`) -> a
dupe.tab <- hash.tab[hash.tab$dat1.hash %in% a$dat1.hash,]
dupe.tab %<>% arrange(`Major Project #`, `ProjectName`, `Type of Drawing`,`Seq ID`)

unique(dupe.tab)
View(dupe.tab)
write.csv(dupe.tab,reportfile)
shell.exec(reportfile)

toc()

# think about parallelizing.


