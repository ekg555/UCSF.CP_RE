# 
# (txt files from PDF | directory)
#  x/bin/txt_conversion/
#  x/bin/images/
#  x/bin/log_PDF2txt_2018-12-14.11AM
# https://medium.com/@CharlesBordet/how-to-extract-and-clean-data-from-pdf-files-in-r-da11964e252e

library(tictoc)
library(tesseract)
library(pdftools)
library(stringr)

library(doParallel)
library(foreach)

no_cores <- detectCores()
cl <- makeCluster(no_cores)
registerDoParallel(cl)

# PATHS
# ===================================================
PDFdir <- "C:/Users/ekonagaya/Desktop/CO_Signed"
#-----------------------------------------------
tic("[PDF>>txt] OVERALL")

setwd(PDFdir)
bin <- file.path(PDFdir,"bin")
log <- file.path(bin,"log")
imgdir <- file.path(bin,"images")
txtdir <- file.path(bin,"txt_conversion")
timestamp <- format(Sys.time(), "%Y-%m-%d.%H")

if (!dir.exists(bin)) { dir.create(bin) }
if (!dir.exists(log)) { dir.create(log) }
if (!dir.exists(imgdir)) { dir.create(imgdir) }
if (!dir.exists(txtdir)) { dir.create(txtdir) }

flist <- dir(pattern=".pdf$")
imglist <- c()


# Try to Read PDF-meta-data/OCR (for each PDF-file)
#==============================================================
# pb <- winProgressBar(label="Reading PDFs", title = "Converting PDFs to txt: progress bar", 
#                      min = 0, max = length(flist), width = 300)

ReadPDFs <- function(filepth) {
  
  # tic(paste0("[PDF>>txt] ", filepth)) # timing PDF>>txt
  #---------------------------------------------------
  setwd(PDFdir)
  fname <- sub(".pdf","",filepth)
  fname
  # Subset "Images" based off size of .txt conversion
  # check if Image-PDF: If the "Producer" of PDF-meta-data contains ("Xerox" or "WorkCentre") >> Add to 'imglist'
  # =======================================================
  if ( !(agrepl("Xerox", pdf_info(filepth)$keys$Producer) | agrepl("WorkCentre", pdf_info(filepth)$keys$Producer)) ) {
    text <- pdf_text(filepth)		# read: vector-PDF
    closeAllConnections()			# close-connection
  } else {
    img <- filepth	# Add to list of Imagepdfs
    text <- ocr(filepth)			# read: image-PDF
    
    imgs <- agrep(fname,dir(pattern=".*.png"),value=T)
    
    for (j in 1:length(imgs)) {
      file.copy(imgs[j],file.path(imgdir,imgs[j]))
      file.remove(imgs[j])
    }
    closeAllConnections()			# close-connection
  }
  
  return( list(text, img) )
  #write(text,file.path(txtdir,paste0(fname, '.txt')))		
  # toc(log=TRUE)	# [PDF>>txt] [filename]
  # setWinProgressBar(pb, i, title=paste0( "( ",i," of ",total," ) ", "done"))
  #------------------------------------------------------
}

total <- length(flist)

# foreach(i=1:length(flist),
#		.combine = 'rbind,
#		.packages = c('pdftools','tesseract', 'stringr')) %dopar% ReadPDFs(flist[i])

dat1 <- foreach(i=1:10,
		.combine = 'list',
		.packages = c('pdftools', 'tesseract', 'stringr')) %dopar% ReadPDFs(flist[i])

#==============================================================

write(imglist,paste0(file.path(bin,"img_pdf_list.txt") ) )
write(unlist(tic.log(format=T)), file.path(log, paste0("log_PDF2txt_",timestamp,".txt")) )
# close(pb)
toc(log=TRUE) # PDF>>txt OVERALL	
tic.clearlog()
closeAllConnections()




