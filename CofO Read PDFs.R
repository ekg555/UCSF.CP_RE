# https://medium.com/@CharlesBordet/how-to-extract-and-clean-data-from-pdf-files-in-r-da11964e252e

library(tesseract)
library(pdftools)
library(stringr)

# PATHS
# ===================================================
PDFdir <- "C:/Users/ekonagaya/Desktop/CO_Signed"
txtdir <- "C:/Users/ekonagaya/Desktop/CO_Signed/txt_conversion"
#-----------------------------------------------

setwd(PDFdir)
bin <- file.path(PDFdir,"bin")
log <- file.path(bin,"log")

if (!dir.exists(bin)) { dir.create(bin) }
if (!dir.exists(log)) { dir.create(log) }
if (!dir.exists('txt_conversion')) { dir.create('txt_conversion') }

flist <- dir(pattern=".pdf$")
imglist <- c()

# Try to Read PDF-meta-data/OCR (for each PDF-file)
#==============================================================

for (i in 1:length(flist)) {

	tic(paste0("[PDF>>txt] ", flist[i])) # timing PDF>>txt
	#---------------------------------------------------
	
	fname <- sub(".pdf","",flist[i])
	# Subset "Images" based off size of .txt conversion
	# check if Image-PDF: If the "Producer" of PDF-meta-data contains ("Xerox" or "WorkCentre") >> Add to 'imglist'
	# =======================================================
	if ( !(agrepl("Xerox", pdf_info(flist[i])$keys$Producer) | agrepl("WorkCentre", pdf_info(flist[i])$keys$Producer)) ) {
		text <- pdf_text(flist[i])		# read: vector-PDF
		closeAllConnections()			# close-connection
	} else {
		imglist <- c(imglist, flist[i])	# Add to list of Imagepdfs
		text <- ocr(flist[i])			# read: image-PDF
		closeAllConnections()			# close-connection
	}
	write(text,file.path(txtdir,paste0(fname, '.txt'))		
	toc(log=TRUE)	# PDF>>txt: [filename]
	#------------------------------------------------------
}
	

#==============================================================

write(imglist,paste0(file.path(bin,"img_pdf_list_by_pdfInfo.txt") ) )
write(writeLines(unlist(tic.log(format=T))), paste0(file.path(log,"log
closeAllConnections()





