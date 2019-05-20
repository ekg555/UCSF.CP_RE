rm(list=ls())

library(readxl)
library(stringr)
dsktp <- 'c:/users/ekonagaya/desktop'


setwd(dsktp)
PATHs <- readLines('The_Lost_Permits.txt')
PNums <- trimws(gsub("\\", "", unlist(str_extract_all(string=PATHs, pattern="([\\\\])I[0-9]{3,}[[:space:]]")), fixed=T))

PDATES <- read_excel('COMPILED PERMIT DATES 05-20.xlsx')

In_PERMITS <- setdiff(PDATES$"PERMIT .", PNums)
MIA <- setdiff(PNums, PDATES$"PERMIT .")

paste0(MIA, collapse="|")
 grep(paste0("[",paste0(MIA, collapse="|"),"]"), PATHs, val=T)
 
MIA <- setdiff(PNums, PDATES$"PERMIT .") 	# The MIA PERMITS (MAY or MAY NOT Be SIGNED)
