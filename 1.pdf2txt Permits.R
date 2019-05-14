library(readxl)
library(pdftools)
library(tictoc)
library(tesseract)
library(stringr)

#  Query re: permits in MS Access.
# ====================================================================================================================================================================================
#  SELECT [Major Project #] & " " & [ProjectName] & " -- " & [Type of Dwgs] AS Review, [Plan Review Log].ProjectName, [Plan Review Log].[Permit Copy], [Plan Review Log].[Permit Date]
#  FROM [Plan Review Log]
#  ORDER BY [Major Project #] & " " & [ProjectName] & " -- " & [Type of Dwgs];
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#   The output of this query was copied and pasted over to 'Permit Cols 4-22.xlsx'
# ====================================================================================================================================================================================


# PATHS
# ===================================================
PDFdir <- 'c:/Users/ekonagaya/Desktop/Construction Permits Issued'
work_dir <- 'c:/Users/ekonagaya/Desktop/Permits_Review'
bin <- file.path(work_dir, 'bin')
# ===================================================
log <- file.path(bin,"log")
imgdir <- file.path(bin,"images")
txtdir <- file.path(bin,"txt_conversion")

setwd('c:/Users/ekonagaya/Desktop')

dat1 <- read_excel('Permit Cols 4-22.xlsx')


if (!exists(work_dir)) { dir.create(work_dir) }
if (!dir.exists(bin)) { dir.create(bin) }
if (!dir.exists(log)) { dir.create(log) }
if (!dir.exists(imgdir)) { dir.create(imgdir) }
if (!dir.exists(txtdir)) { dir.create(txtdir) }


x <- list.files()

set.seed(5555)
flist <- sample(x, 15)

setwd(PDFdir)

timestp <- format(Sys.time(), "%Y-%m-%d.%H")
ReRd <- FALSE # Set this to TRUE to Re-read previously read PDFs.

flist <- dir(pattern=".pdf$")
# set.seed(5555)
# flist <- sample(list.files(), 15)


imglist <- c()
vecPDFlist <- c()
tic("[PDF>>txt] OVERALL")

# Try to Read PDF-meta-data/OCR (for each PDF-file)
#==============================================================
pb <- winProgressBar(label="Reading PDFs", title = "Converting PDFs to txt: progress bar", 
                     min = 0, max = length(flist), width = 300)
total <- length(flist)

for (i in 1:length(flist)) {
  
  tic(paste0("[PDF>>txt] ", flist[i])) # timing PDF>>txt
  #---------------------------------------------------
  
  fname <- sub(".pdf","",flist[i]);  fname
  if (!ReRd && (fname %in% gsub(".txt","",dir(txtdir))) ) {
	# Already a .txt file w/ identical name as PDF in txtdir
	cat(paste0('SKIPPING, previously read ','(',i,' of ',total,'): ', fname))
   } else {
  
	# Subset "Images" based off size of .txt conversion
	# check if Image-PDF: If the "Producer" of PDF-meta-data contains ("Xerox" or "WorkCentre") >> Add to 'imglist'
	# =======================================================
	if ( !(agrepl("Xerox", pdf_info(flist[i])$keys$Producer) | agrepl("WorkCentre", pdf_info(flist[i])$keys$Producer)) ) {
		vecPDFlist <- c(vecPDFlist, flist[i])
		text <- pdf_text(flist[i])		# read: vector-PDF
		# closeAllConnections()			# close-connection
	} else {
		imglist <- c(imglist, flist[i])	# Add to list of Imagepdfs
		text <- ocr(flist[i])			# read: image-PDF
    
		imgs <- agrep(fname,dir(pattern=".*.png"),value=T)
    
		for (j in 1:length(imgs)) {
			file.copy(imgs[j],file.path(imgdir,imgs[j]))
			file.remove(imgs[j])
		}
    # closeAllConnections()			# close-connection
	}
	write(text,file.path(txtdir,paste0(fname, '.txt')))		# SAVE TEXT to txtdir	
  }
  toc(log=TRUE)	# [PDF>>txt] [filename]
  setWinProgressBar(pb, i, title=paste0( "( ",i," of ",total," ) ", "done"))
  closeAllConnections()
  #------------------------------------------------------
}

toc(log=TRUE) # PDF>>txt OVERALL	

#==============================================================

write(imglist,paste0(file.path(bin,"img_pdf_list.txt") ) )
write(vector_pdf_list,paste0(file.path(bin,"vector_pdf_list.txt") ) )
write(unlist(tic.log(format=T)), file.path(log, paste0("log_PDF2txt_",timestp,".txt")) )
close(pb)
tic.clearlog()
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

shell.exec( file.path(log, paste0("log_PDF2txt_",timestp,".txt")) )
