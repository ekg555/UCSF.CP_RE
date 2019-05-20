rm(list=ls())

library(readxl)
library(stringr)
dsktp <- 'c:/users/ekonagaya/desktop'

 timestp <- format(Sys.time(), "%Y-%m-%d.%H") # Time Stamp as Ousual
 
setwd(dsktp)
PATHs <- readLines('The_Lost_Permits.txt')
PNums <- trimws(gsub("\\", "", unlist(str_extract_all(string=PATHs, pattern="([\\\\])I[0-9]{3,}[[:space:]]",simplify=T)), fixed=T))

dat1 <- data.frame(PATHs, PNums, stringsAsFactors=F)
PDATES <- read_excel('COMPILED PERMIT DATES 05-20.xlsx')

In_PERMITS <- setdiff(PDATES$"PERMIT .", PNums)	
MIA <- setdiff(PNums, PDATES$"PERMIT .")			# MIA: Permit# in 001, but Not in 004


paste0(MIA, collapse="|")
 grep(paste0("[",paste0(MIA, collapse="|"),"]"), PATHs, val=T)
 
MIA <- setdiff(PNums, PDATES$"PERMIT .") 	# The MIA PERMITS (MAY or MAY NOT Be SIGNED)
nrow(dat1[which(dat1$PNums %in% MIA),]) # n= 60 files w/ MIA-Permit#s
write.csv(dat1[which(dat1$PNums %in% MIA),], paste0('MIA-PERMITS_',timestp,'.csv'))
