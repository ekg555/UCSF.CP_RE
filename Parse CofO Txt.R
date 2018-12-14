# PARSE TXT FILES & EXTRACT DATA
#=================================================================
# https://stackoverflow.com/questions/21114598/importing-a-text-file-into-r

library(tictoc)
tic('initialize Parse CofO Txt.R')

library(xlsx)
library(plyr)
library(tesseract)
library(pdftools)
library(stringr)

# PATHS
# ===================================================
PDFdir <- "C:/Users/ekonagaya/Desktop/CO_Signed/"
txtdir <- "C:/Users/ekonagaya/Desktop/CO_Signed/txt_conversion"
#-----------------------------------------------

setwd(PDFdir)

bin <- file.path(PDFdir,"bin")
if (!dir.exists(bin)) { dir.create(bin) }

setwd(txtdir)
flist <- dir()
dat1 <- c()

# a sample Raster-PDF
# flist <- dir()[grep("M5439F", dir())]
# a <- readLines(flist)

# a sample Vector-PDF
# flist <- dir()[grep("M1671", dir())]
# a <- readLines(flist)
# a <- gsub("\\s+", " ", str_trim(a))

# for iterative ver.
# c <- readLines(flist[1])
# Filenom <- flist[i]

# Load Sample "Difficult Cases"
E1 <- "CofO M2629 HSE 8 Renovation 12-20-16.txt"	# Docusign Envelope ID: @ line-1
E2 <- "CO - 07-428 Plaza Level Storage Room.txt"	# FuzzyScan


#  SAVING TO FOLDER ( e.g. "CofO_PDF_Summary_12-14-2018.09_AM"
#                                            or 'CofO_PDF_.../images/' )
# ----------------------------------------------------------------
outname <- paste0("CofO_PDF_Summary_",format(Sys.time(), "%Y-%m-%d.%HH_%p"))
outtime <- sub(".*Summary_","",outname)
outpath <-  file.path(bin,outname)

if ( !dir.exists(outpath) ) {dir.create(outpath)}
if ( !dir.exists(file.path(outpath,'images')) ) { dir.create(file.path(outpath, 'images')) }

toc() #init "Parse CofO Txt.R"
# -----------------------------------------------------------

for (i in 1:length(flist)) {
	tic(paste0("Txt Parse: ",flist[i]))
	Filenom <- flist[i]
	txt <- gsub("\\s+", " ", str_trim(readLines(flist[i])) )
	# if DocuSign Envelope ID on TOP, Trim the top 
	if ( agrepl("DocuSign Envelope ID:", txt[1])) { txt <- txt[-1] }
	# CHECK if CofO in 1st Line
	if ( !agrepl("Certificate of Occupancy", txt[1]) )  {
	ProjName <- "CORRUPT FILE?"
	ProjNum <- "CORRUPT FILE?"
	dat1 <- rbind.fill(dat1, data.frame(ProjName, ProjNum, Filenom) )
	} else {
	
	ProjName <- str_trim(gsub(".*Name?:|Project Number.*", "", ignore.case = TRUE, 
								agrep("Project Name:", ignore.case=TRUE, txt, value=TRUE)[1] ))
	ProjNum  <- str_trim(gsub(".*Project Number?:", "", ignore.case = TRUE, 
								agrep("Project Number:", ignore.case=TRUE, txt, value=TRUE)[1] ))
	
	BldgName <- str_trim(gsub(".*Building Name?:|Building Owner.?:*", "", ignore.case = TRUE, 
								agrep("Building Name:", ignore.case=TRUE, txt, value=TRUE)[1] ))
	BldgOwner <- str_trim(gsub(".*Building Owner", "", ignore.case = TRUE, 
								agrep("Building Owner:", ignore.case=TRUE, txt, value=TRUE)[1] ))
	
	Campus <- str_trim(gsub(".*Campus/Facility:|Street Address?:.*", "", ignore.case = TRUE, 
								agrep("Campus:", ignore.case=TRUE, txt, value=TRUE)[1] ))
								
	StAddress <- str_trim(gsub(".*Street Address?:", "", ignore.case = TRUE, 
								agrep("Street Address:", ignore.case=TRUE, txt, value=TRUE)[1]  ))
	
	OccGrp <- str_trim(gsub(".*Occupancy Group?:|Type of Constr.*", "", ignore.case = TRUE, 
								agrep("Occupancy Group:", ignore.case=TRUE, txt, value=TRUE)[1]  ))
	ToC <- str_trim(gsub(".*Type of Construction?:", "", ignore.case = TRUE, 
								agrep("Type of Construction:", ignore.case=TRUE, txt, value=TRUE)[1]  ))
	
	lnN <- agrep("The certificate is issued on:",txt)[1]
	DateIssued <- str_trim(gsub(".*This certificate is issued on:", "", ignore.case = TRUE, txt[lnN]))
	
	if (any(agrepl("is issued pursuant to", txt))) {
	lnM <- agrep("is issued pursuant to", txt)[1]
	} else {
	lnM <- lnN
	}
	
	DoOccS <- str_trim(gsub(".*Occupied Space?:","", paste(txt[9:lnM-1], collapse = " ")) )
	
	dat1 <- data.frame(rbind(dat1, 
							cbind( ProjName=ProjName,	ProjNum=ProjNum, 
								  BldgName=BldgName,	BldgOwner=BldgOwner,
								  Campus=Campus,		StAddress=StAddress,
								  OccGrp=OccGrp,		ToC=ToC,
								  DoOccS=DoOccS, 		DateIssued=DateIssued, 
								  Filenom=Filenom 
								)  ))
								
	toc()	# Txt Parse: [filename]
	#------------------------------------------------------------
}

# img move to bin/images
# ==============================================================
img_file <- paste0(gsub(".txt", "", Filenom),"_1.png")
file.copy(file.path("..",img_file), file.path(outpath,'images',img_file))
file.remove(img_file)

closeAllConnections()
}

#   SAVE TABLE TO 'bin/CofO_PDF_Summary...'	
# ============================================
setwd(outpath)

table_name <- paste0(outname,".txt")
write.table(dat1, table_name, 
					sep="\t", row.names=FALSE)

closeAllConnections()

setwd("..")
zip(zipfile = paste0(gsub("\\..*","",outname),".zip"), files = outpath)


# dir(outtime)
# zip(zipfile = 'testZip', files = 'testDir/test.csv')
# file.info(c('testZip.zip', 'testDir/test.csv'))['size']
# files2zip <- dir('testDir', full.names = TRUE)
# unzip('testZip.zip', list = TRUE)
