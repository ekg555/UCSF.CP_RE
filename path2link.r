# CONVERT PATH 2 LINK (COMPONENTS)
# =========================================
#  - After getting the .csv, open and import into ms access.
#  - 

library(readxl)

dsktp <- 'c:/Users/ekonagaya/Desktop'
wkdir <- file.path(dsktp, 'PATH2LINK')
bindir <- file.path(wkdir, 'bin')

  timestp <- format(Sys.time(), "%Y-%m-%d.%H") # Time Stamp as Ousual

outfile <- paste0('PATH Split', timestp)

		# SAVING THIS FOR LATER...
		#  - IDEA: Select Dir, run .bat (to sic the machine on the files) to feed flist.
		# PDFdir <- gsub('\\\\','/',choose.dir(default="C:\\Users\\ekonagay\\Desktop\\"))	

# flist.file <- gsub('\\\\','/',choose.files(caption='SELECT DIR OUTPUT of ALL FILES')
setwd(dsktp)
flist.file <- 'listOPDFs.txt'
flist <- readLines(flist.file)

if (!dir.exists(wkdir)) { dir.create(wkdir) }
setwd(wkdir)

# GRAB ALL FILENAMEs & PATHs ( -> Filenom & Pth)
Filenom <- sub(".*\\\\", "", flist); head(Filenom); # FILENAME
Pth <- sub("[^\\]+$","", flist); head(Pth,50); # PATH

dat1 <- data.frame(Path=Pth, Filename=Filenom, stringsAsFactors=F)
write.csv(dat1, paste0(outfile,'.csv'))



# OPEN A RANDOM FILE (TEST)
# set.seed(555)

rng <- round(runif(1, min=1, max=nrow(dat1)),0)

print(paste("OPENING FILE: ", dat1[rng,]$Filename)); 	# PROOF OF CONCEPT:
print(rng); shell.exec(paste0(dat1[rng,]$Path,dat1[rng,]$Filename)) #   OPEN A RANDOM FILE on the 'FLIST'


