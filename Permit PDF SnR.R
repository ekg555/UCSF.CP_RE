rm(list=ls())

library(readxl)
library(stringr)
library(beepr)
dsktp <- 'c:/users/ekonagaya/desktop'
# ----------------------------------------------------------------------------
wkdir <- dsktp
srcdir <- 'p:'
# ============================================================================
T1.name <- 'Permit'
T1.regx <- '([\\\\])I[0-9]{3,}[[:space:]]'

T2.name <- '100CD'
T1.regx <- '100[\\s]{0,}%?[\\s]{0,}CD'

# ============================================================================
#  CREATE The MANIFEST (Win10)
# ============================================================================
setwd(wkdir)
if (!file.exists("PDF_Manifest.txt")) {
setwd(srcdir)

system("cmd", 
		intern=T, 
		ignore.stdout=F, 
		ignore.stderr=F, 
		wait=T, 
		input='dir /B /S | findstr("pdf$") > PDF_Manifest.txt')
				
file.copy('PDF_Manifest.txt', file.path(wkdir, 'PDF_Manifest.txt'))
beep(2)
Sys.sleep(3)
file.remove('PDF_Manifest.txt')
}

setwd(wkdir)

# ============================================================================		
	
PATHs <- readLines('PDF_Manifest.txt')
PNums <- trimws(gsub("\\", "", unlist(str_extract_all(string=PATHs, pattern="([\\\\])I[0-9]{3,}[[:space:]]",simplify=T)), fixed=T))

dat1 <- data.frame(PATHs, PNums, stringsAsFactors=F)
PDATES <- read_excel('COMPILED PERMIT DATES 05-20.xlsx')

In_PERMITS <- setdiff(PDATES$"PERMIT .", PNums)	
MIA <- setdiff(PNums, PDATES$"PERMIT .")			# MIA: Permit# in 001, but Not in 004

paste0(MIA, collapse="|")
 grep(paste0("[",paste0(MIA, collapse="|"),"]"), PATHs, val=T)
 
MIA <- setdiff(PNums, PDATES$"PERMIT .") 	# The MIA PERMITS (MAY or MAY NOT Be SIGNED)
nrow(dat1[which(dat1$PNums %in% MIA),]) # n= 60 files w/ MIA-Permit#s
write.csv(dat1[which(dat1$PNums %in% MIA),], 'MIA-PERMITS_')
