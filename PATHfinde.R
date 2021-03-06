# ============================================================================
#   PATHfinde.R
# ----------------------------------------------------------------------------
#   - Asks where to Look
#   - Digs into all subdirs of wherever directed (and builds a MANIFEST of .pdf files
#   OUTPUT:
#   - writes to a timestamped 'PATHs...csv' 
#   + EZ COPY into MS ACCESS
#   **1 ADD A Field called LINK (type=hyperlink)
#   **2 Rename the Table to "Table1"
#   **3 Run "EK UPDATE LINKS" to auto-link
#
#   NOTE: 'escapes' # symbols for Access
# ============================================================================

rm(list=ls())

library(tictoc)
library(readxl)
library(stringr)

 timestp <- format(Sys.time(), "%Y-%m-%d.%H") # Time Stamp as Usual

dsktp <- 'c:/users/ekonagaya/desktop'
projdir <- 'p:'
dubsev <- 'q:'
prmtsdir <- 'u:'
# ------------------------------------------======
wkdir <- file.path(dsktp, 'PATH2LINK')
bindir <- file.path(wkdir, 'bin')
Manif <- paste0("Manifest_", timestp)
outfile <- paste0('PATHs_', timestp)
# ------------------------------------------======
if (!dir.exists(wkdir)) { dir.create(wkdir) }
if (!dir.exists(bindir)) { dir.create(bindir) }
# ------------------------------------------======

# RegEx-es (EDIT if you DARE)
# ============================================================================
 apresSLSH <- "([^/]+)$"
 avantSLSH <- "(^.*([/]+))"
# ============================================================================

selDir <- gsub("\\\\", "/", choose.dir("u:\\Construction Permits Issued\\"))
# setwd(dubsev)
# setwd(prmtsdir)

setwd(selDir)

# ============================================================================
#	CREATE The MANIFEST  (w/ R.base::list.files() - this is SLOW!)
# ============================================================================
# tic('Getting List')	# START time w/ tictoc
# FullPath <- sub(".", sub("([/]+)$", "", getwd()),
					# list.files(pattern="\\.pdf$", 
						 # recursive=T, 
						 # full.names=T,
						 # all.files=T,
						 # include.dirs=T,
						 # no.. = T)
				# )
# ============================================================================
#  CREATE The MANIFEST (Win10)
# ============================================================================
system("cmd", intern=T, 
		ignore.stdout=F, 
		ignore.stderr=F, 
		input="dir /B /S > asdfasdfasdf.txt")

file.copy('asdfasdfasdf.txt', file.path(wkdir, 'asdfasdfasdf.txt'))
file.remove('asdfasdfasdf.txt')

setwd(wkdir)
FullPath <- readLines('asdfasdfasdf.txt')
FullPath <- gsub("\\\\", "/", FullPath)
# ============================================================================

# Replace "#" signs (for Access)
FullPath <- gsub("#", "%23", FullPath)

Path <- str_extract(pattern=avantSLSH,string=FullPath)
Filenom <- str_extract(pattern=apresSLSH,string=FullPath)

# MS_Excel-friendly SLASHES
#xlPath <- gsub("/", "\\\\", Path)
#xlFnom <- gsub("/", "\\\\", Filenom)


# FOR NOW... Just gather info for MS ACCESS
dat1 <- data.frame(# FULLPATH=FullPath, 
				   PATH=Path, FILENAME=Filenom)
# toc()					# END time w/ tictoc

write.csv( dat1, file.path(dsktp,paste0(outfile, ".csv")), row.names=F )
shell.exec( file.path(dsktp,paste0(outfile, ".csv")) )
