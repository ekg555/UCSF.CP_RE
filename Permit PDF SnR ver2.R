rm(list=ls())

library(readxl)
library(stringr)
library(beepr)
dsktp <- 'c:/users/ekonagaya/desktop'
timestp <- format(Sys.time(), "%Y-%m-%d.%H") 	# Time Stamp as Usual
# ----------------------------------------------------------------------------
wkdir <- dsktp
srcdir <- 'p:'
pmtsdir <- 'u:/Construction Permits Issued'
cofodir <- 'r:/CO_Signed'
# ----------------------------------------------------------------------------
outfile <- paste0('MIA-PERMITS_', timestp)


# ============================================================================
#	SET The RegEx-es to detect files - IF YOU DARE!
# ----------------------------------------------------------------------------
#	- The "PROPER ALT"s were too specific
#   - These may be too sensitive [i.e., NEED to check for FALSE(+)s]
# ============================================================================
regex.permit <- '/I[0-9]{3,}'				# THE "PROPER ALT": '/I[0-9]{3,}:[[space]]:' 
regex.HundCD <- '100.*CD'					# THE "PROPER ALT": '100[[:space:]]{0,}%?[[:space:]]{0,}CD'
regex.CofO   <- "/CofO|/CO[[:space:]]+-"	# Using the Proper regex. Seems OK & a "Floating CO" catches "Change Orders"

	# regex.HundCD: caught a "100percent_CD" / likely to be too non-specific.


			# ----------------------------------------------------=====
			#	USE THIS to TEST REGEXes
			# ----------------------------------------------------=====
			# see <- function(rx) str_view_all(CofO.Manifest, rx)
			# see("/CofO|/CO[[:space:]]+-")


# ============================================================================
#  CREATE The MANIFEST (Win10)
# ============================================================================
setwd(wkdir)
if (!file.exists("FULL_Manifest.txt")) {
setwd(srcdir)

system("cmd", 
		intern=T, 
		ignore.stdout=F, 
		ignore.stderr=F, 
		wait=T, 
		input='dir /B /S > FULL_Manifest.txt')
				
file.copy('FULL_Manifest.txt', file.path(wkdir, 'FULL_Manifest.txt'))
beep(4); Sys.sleep(1)
beep(2); Sys.sleep(1)
beep(2); Sys.sleep(1)
beep(1); file.remove('FULL_Manifest.txt')
}

setwd(wkdir)
shell.exec('FULL_Manifest.txt')

# RegEx-es (EDIT if you DARE)
# ============================================================================
 apresSLSH <- "([^/]+)$"
 avantSLSH <- "(^.*([/]+))"
# ============================================================================


# ============================================================================		
# FILTER OUT based on TYPE.
# ----------------------------------------------------------------------------
#	- The "PROPER ALT"s were too specific
#   - These may be too sensitive [i.e., NEED to check for FALSE(+)s]
# ============================================================================		
FULL.Manifest <- readLines('FULL_Manifest.txt')
PDF.Manifest <- gsub("\\\\", "/", grep("\\.pdf$", FULL.Manifest, val=T))
# ----------------------------------------------------------------------------	
PERMIT.Manifest <- grep(regex.permit, PDF.Manifest, val=T)
# HundCD.Manifest <- grep("100[\\s]{0,}%?[\\s]{0,}CD", PDF.Manifest, val=T)  # THIS RegEx was TOO SPECIFIC
HundCD.Manifest <- grep(regex.HundCD, PDF.Manifest, val=T)  
CofO.Manifest <- grep(regex.CofO, PDF.Manifest, val=T)


# =====---====---============================================---=====---======		
# 		   ||		For PERMITS: PATHS   vs.   004 Permits		  ||
# =====---====---============================================---=====---======				
PATHs <- PERMIT.Manifest
PNums <- trimws(gsub("/", "", unlist(str_extract_all(string=PATHs, pattern="I[0-9]{3,}(?=([[:space:]]|))",simplify=T)), fixed=T))[,1]
# ----------------------------------------------------------------------------		
dat1 <- data.frame(PATHs, PNums, stringsAsFactors=F); dim(dat1)	# 615 x 2 mtx.

# PDATES <- read_excel('COMPILED PERMIT DATES 05-20.xlsx')
setwd(pmtsdir)
Pmts <- list.files(pattern="\\.pdf$")
PNs <- str_extract(Pmts, "I[0-9]{3,}(?=([[:space:]]|))")
# ----------------------------------------------------------------------------		
vier <- data.frame(Pmts, PNs, stringsAsFactors=F); dim(vier)	# 761 x 2 mtx.


In_PERMITS <- setdiff(vier$PNs, dat1$PNums); length(In_PERMITS)		# n = 258
MIA <- setdiff(dat1$PNums, vier$PNs); length(MIA)					# MIA: Permit# in 001, but Not in 004 (n = 39)

setwd(wkdir)
write.csv(dat1[which(dat1$PNums %in% MIA),], paste0(outfile,".csv") )
shell.exec(paste0(outfile,".csv"))

# nrow(dat1[which(dat1$PNums %in% MIA),]) # n= 50 files w/ MIA-Permit#s

