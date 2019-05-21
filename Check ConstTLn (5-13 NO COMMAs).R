#
#  CHECK Construction TimeLine.R
#   Reads through Building Permit Applications in "\\som.uscf.edu...\\004 Permits"
#   Grabs Construction Start Date & Finish Dates
#	ISSUES: 
#   - some permits have 
#
# =====================================================================================================================

rm(list=ls())

library(readxl)
library(stringr)
library(dplyr)
library(lettercase)
desktp <- 'c:/Users/ekonagaya/Desktop'
txtdir <- "C:/Users/ekonagaya/Desktop/Permits CompileR/work involved/Permits_Review/bin/txt_conversion"
pmtsdir <- choose.dir("u:\\Construction Permits Issued")

setwd(desktp)
# x <- readLines('I1084 W46074 PHTS MSB S1076 Freezer.txt')


mos <- paste0('[',paste0(month.abb, collapse="|"),']')

setwd(txtdir)
# flist  <- list.files()
flist <- 
	list.files() %>% .[grep(".txt$",.)]

# CnstDt <- data.frame(start=as.Date(character()), finish=as.Date(character()))
DateLst <- c()
InvalidDts <- data.frame(filename=character(), InvalDate=as.Date(character(0)))

numDt <- '[0-9]{1,}[/-][0-9]{1,}[/-][0-9]{2,}'

# This will allow as.Date() to just classify bad-dates e.g. 11/31 as NA & move on.
ValidDt <- function(b) {tryCatch( { sapply(unlist(str_extract_all(b,longDt)), as.Date, optional=T, tryFormats= c("%b %d %Y", "%b%Y") ) },
		warning= function(w) { },
		error= function(e) {
			'Invalid Date'}
			)}

longDt <- "[ADFJMNOSadfjmnos]([a-z]){2,8}[:space:]{1,}[0-9]{1,}([:space:]){0,}[12][0-9]{3}" # NO COMMAS/PERIODS allowed
# longDt <- "[ADFJMNOSadfjmnos]([a-z]){2,8}[:space:]{1,}[0-9]{1,}[\\,]([:space:]){0,}[12][0-9]{3}" # w/ Comma

# MODIFYING/"IRONING-OUT" b ("the line w/ dates") to prevent 'Jamming' 
# ================================================================================
CleanMos <- function(strng) {
		# LOCATE Find one-off non-3-letter abbrev. Nor spelled-out examples (e.g. "Sept", ["July", "June" - any takers?])
		if ( length(unlist(str_locate_all(strng, "Sept"))) > 0 ) { 
			strng <- gsub(str_extract(strng,"Sept"), "Sep", strng)
		}
		# 'SEPEMBER', (agrep didn't pick this up) ad-hoc fixing for now...
		if ( length(unlist(str_locate_all(strng, "Sepember"))) > 0 ) { 
			strng <- gsub(str_extract(strng,"Sepember"), "Sep", strng)
		}
		if ( length(unlist(str_extract_all(strng, "[0-9]{1,}-[0-9]{1,}-[12][0-9]{1,}"))) > 0 ) {
			for (Dt in unlist(str_extract_all(strng, "[0-9]{1,}-[0-9]{1,}-[12][0-9]{1,}")) ) {
				strng <- sub(Dt, format(as.Date(Dt, "%m-%d-%Y"),"%m/%d/%Y" ), strng)
				}
		}
		strng <- str_squish(gsub("[,.]"," ", strng))
		strng <- paste(str_cap_words(str_lowercase(unlist(str_split(strng, " ")))), collapse=" ")
		# ================================================================================
		# REINTERPRET DATES (Jan 01, 2049 | January 01, 2049 >> 01/01/2049
		return(strng)
}

# TEST CASES
b0 <- '1/1/2019 		12/31/2019'
b1 <- 'Sepember 31, 2018 		October 30, 2019'
b2 <- '1/20/2019 				June 20, 2019'
b3 <- 'Jan 20, 2049				6/30/2050'

b4 <- 'Feb. 20, 2049   Feb. 20 2050'
b5 <- 'May 20, 1945    Sept 1 1945'
b6 <- 'MARCH 24, 2090 MARCH 30, 2100'

for (fl in flist) { 

txt <- str_squish(readLines(fl))
a <- agrep('Construct. Start Date',txt)
b <- str_squish(txt[a+1])

b <- CleanMos(b)

	## IF have TWO NUMERIC DATES... SKIP to end
	if (length(grep(numDt, unlist(str_split(b, " ")))) == 2) {
		c0 <- unlist(strsplit(b ,split=' '))
		x <- grep(numDt, c0, value=T)
		DateLst <- c(DateLst, list(x)) 
	
	## Otherwise, if there are NO VALID DATES...'NA NA'
	} else if (length(ValidDt(b)) == 0) { 
		DateLst <- c(DateLst, list(c("NA", "NA")))
	} else {
	# ===============================================
	# - grab any numDts (11/11/11), 
	# - 
		c0 <- c(unlist(na.omit(str_extract(b, numDt))))
		c0 <- c(c0, unname(format(as.Date(ValidDt(b), origin='1970-01-01'), "%m/%d/%Y")))
		DateLst <- c(DateLst, list(c0))
	}
	rm(list=c('a','b','c0'))
}

constDts <- data.frame(file=character(), start=character(), finish=character(),
						stringsAsFactors=F)


# COMPILE WHAT was gathered in DateLst (a 'list') to constDts (a 'dataframe' - stricter rules)
for (i in 1:length(flist)) {
	if (length(DateLst[[i]]) == 2) {
		constDts <- rbind(constDts, c(file=flist[i], start=DateLst[[i]][1], finish=DateLst[[i]][2]), stringsAsFactors=F)
	} else if (length(DateLst[[i]]) == 1) {
		constDts <- rbind(constDts, c(file=flist[i], start='NA', 			finish=DateLst[[i]][1]), stringsAsFactors=F)
	} else {
		constDts <- rbind(constDts, c(file=flist[i], start='NA', 			finish='NA'), stringsAsFactors=F ) 
	}
}

setwd(desktp)
write.csv(constDts, 'ConstructDates.csv')
Sys.sleep(1)	# pause a sec...(literally)
shell.exec('ConstructDates.csv')




# OKAY... the PUNCTUATION OR NOT IS GETTING RIDDICK...
# - for now, doing away w/ them altogether unless this causes NON-'SPECIFICITY' issues.
# - DELETING, CAUSED MAJOR ISSUES w/ extracting the most common format.
# - replacing w/ " " worked.

# c <- unlist(strsplit(b ,split=' '))





