# PARSE TXT FILES & EXTRACT DATA
#=================================================================
# https://stackoverflow.com/questions/21114598/importing-a-text-file-into-r

Sys.setenv(PATH = paste("C:\\Rtools\\bin", Sys.getenv("PATH"), sep=";"))
Sys.setenv(BINPREF = "C:\\Rtools\\mingw_$(WIN)\\bin\\")
Sys.setenv(R_ZIPCMD= 'C:/Users/ekonagaya/Desktop/Rtools/bin/zip')

library(tictoc)
# tic('initialize Parse CofO Txt.R')

library(plyr)
library(tesseract)
library(pdftools)
library(stringr)

# PATHS
# ===================================================
# PDFdir <- gsub('\\\\','/',choose.dir(default="C:/Users/ekonagaya/Desktop/CO_Signed"))
# PDFdir <- "C:/Users/ekonagaya/Desktop/CO_Signed"
# PDFdir <- "C:/Users/Eugene/Desktop/CO_Signed"
PDF_dir <- 'u:/Construction Permits Issued'
bin <- file.path('c:/Users/ekonagaya/Desktop/Permits_Review', 'bin')
#-----------------------------------------------

log <- file.path(bin,"log")
txtdir <- file.path(bin,"txt_conversion")
if (!dir.exists(bin)) { dir.create(bin) }
if (!dir.exists(log)) { dir.create(log) }

# =================================================

# by list: Issues
# ------------------------------------
# setwd('c:/Users/ekonagaya/Desktop/')
# fnom <- readLines(dir(pattern='.csv'))
# flist <- fnom[-1]
#==================================================

setwd(txtdir)
dat1 <- c()
flist <- dir()[grep("*.txt",dir())]

#  SAVING TO FOLDER ( e.g. "CofO_PDF_Summary_2018-12-14.13"
# ----------------------------------------------------------------
outname <- paste0("Permits_PDF_OCR_",format(Sys.time(), "%Y-%m-%d.%H"))
outtime <- sub(".*Summary_","",outname)
outpath <-  file.path(bin,outname)
timestp <- format(Sys.time(), "%Y-%m-%d.%H")

if ( !dir.exists(outpath) ) {dir.create(outpath)}

toc(log=TRUE) #init "Parse CofO Txt.R"
# -----------------------------------------------------------
set.seed(555)
runif(50, 1,755)


tic("[txt>>table] OVERALL")


# Tip from StackOverflow: https://stackoverflow.com/questions/41753835/regex-get-text-between-two-words-in-r
# words <- c("these are some different abstract words that might be between keywords or they might just be bounded by abstract ideas")
# gsub(".* abstract (.*) keywords.*", "\\1", words)

for (i in 1:length(flist)) {
  tic(paste0("[txt>>table] ",flist[i]))
  Filenom <- flist[i]
  PermitNum <- str_split(flist[i],' ')[[1]][1]
  txt <- gsub("\\s+", " ", str_trim(readLines(flist[i])) )
  # if DocuSign Envelope ID on TOP, Trim the top 
  # if ( agrepl("DocuSign Envelope ID:", txt[1])) { txt <- txt[-1] }
  # CHECK if CofO in 1st Line
  if (any(agrepl("DATE ISSUED:", txt)))  {
    PermitDate <- paste(unique(trimws(gsub('.*:', '', agrep("DATE ISSUED:",txt, value=T )), which='both'), sep=';'))
  } else if (any(agrepl("_ Date:", txt))) {   
    PermitDate <- paste(unique(trimws(gsub('.*Designated State Fire Marshal Permit Signature"', '', agrep("_ Date:",txt, value=T )), which='both'), sep=';'))
  } else {
	PermitDate <- NA
  }
    
  
    #------------------------------------------------------------

  dat1 <- data.frame(rbind(dat1, 
								cbind( PermitNum=PermitNum, PermitDate=PermitDate, Filenom=Filenom)  ))
  toc(log=TRUE)	# [txt>>table] [filename]:
}

toc(log=TRUE) # PDF>>txt OVERALL	

#==============================================================
#   SAVE TABLE TO 'bin/CofO_PDF_Summary...'	
# ============================================
setwd(outpath)

table_name <- paste0(outname,".txt")
write.table(dat1, table_name, 
            sep="\t", 
			row.names=FALSE,
			quote=FALSE)

write(unlist(tic.log(format=T)), file.path(log, paste0("log_txt2tab_",timestp,".txt")) ) 

closeAllConnections()

setwd(bin)
files2zip <- c(outname,'img_pdf_list.txt', 'log', 'txt_conversion')
zip(zipfile = paste0(gsub("\\..*","",outname),".zip"), files = files2zip)
if (!dir.exists("Archive")) { dir.create("Archive") }
file.copy( paste0(gsub("\\..*","",outname),".zip"), file.path(bin,"Archive") )
file.remove( paste0(gsub("\\..*","",outname),".zip") )
unlink(outname, recursive = T)

setwd("Archive")
shell.exec(dir(pattern=paste0(gsub("\\..*","",outname),".zip")))

tic.clearlog()
# dir(outtime)
# zip(zipfile = 'testZip', files = 'testDir/test.csv')
# file.info(c('testZip.zip', 'testDir/test.csv'))['size']
# files2zip <- dir('testDir', full.names = TRUE)
# unzip('testZip.zip', list = TRUE)
