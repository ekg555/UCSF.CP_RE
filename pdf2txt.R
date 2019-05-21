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

# PATHS
# ===================================================
# PDFdir <- "C:/Users/ekonagaya/Desktop/CO_Signed"
  dsktp <- 'c:/users/ekonagaya/desktop'
  wkdir <- file.path(dsktp, 'PDF2TXT')
  PDFdir <- gsub('\\\\','/',choose.dir(default="C:\\Users\\ekonagaya\\Desktop"))
#-----------------------------------------------

setwd(PDFdir)
bin <- file.path(wkdir,"bin")
log <- file.path(bin,"log")
imgdir <- file.path(bin,"images")
txtdir <- file.path(bin,"txt_conversion")
timestamp <- format(Sys.time(), "%Y-%m-%d.%H")
ReRd <- FALSE # Set this to TRUE to Re-read previously read PDFs.


if (!dir.exists(wkdir)) { dir.create(wkdir) }
if (!dir.exists(bin)) { dir.create(bin) }
if (!dir.exists(log)) { dir.create(log) }
if (!dir.exists(imgdir)) { dir.create(imgdir) }
if (!dir.exists(txtdir)) { dir.create(txtdir) }

flist <- dir(pattern="\\.pdf$")
imglist <- c()
tic("[PDF>>txt] OVERALL")

# Try to Read PDF-meta-data/OCR (for each PDF-file)
#==============================================================
# pb <- winProgressBar(label="Reading PDFs", title = "Converting PDFs to txt: progress bar", 
                     # min = 0, max = length(flist), width = 300)
total <- length(flist)

for (i in 1:length(flist)) {
  
  tic(paste0("[PDF>>txt] ", flist[i])) # timing PDF>>txt
  #---------------------------------------------------
  
  fname <- sub("\\.pdf","",flist[i]); fname
  
  # IF Already a .txt file w/ identical name as PDF in txtdir
  if (!ReRd && (fname %in% gsub(".txt","",dir(txtdir))) ) {	
			cat(paste0('SKIPPING, previously read ','(',i,' of ',total,'): ', fname))
  } else {
  # Subset "Images" based off size of .txt conversion
  # check if Image-PDF: If the "Producer" of PDF-meta-data contains ("Xerox" or "WorkCentre") >> Add to 'imglist'
  # =======================================================
  if ( !(agrepl("Xerox", pdf_info(flist[i])$keys$Producer) | agrepl("WorkCentre", pdf_info(flist[i])$keys$Producer)) ) {
    text <- pdf_text(flist[i])		# read: vector-PDF
    closeAllConnections()			# close-connection
  } else {
    imglist <- c(imglist, flist[i])	# Add to list of Imagepdfs
    text <- ocr(flist[i])			# read: image-PDF
    
    imgs <- agrep(fname,dir(pattern=".*.png"),value=T)
    
    for (j in 1:length(imgs)) {
      file.copy(imgs[j],file.path(imgdir,imgs[j]))
      file.remove(imgs[j])
    }
    closeAllConnections()			# close-connection
  }
  write(text,file.path(txtdir,paste0(fname, '.txt')))		
  toc(log=TRUE)	# [PDF>>txt] [filename]
  # setWinProgressBar(pb, i, title=paste0( "( ",i," of ",total," ) ", "done"))
  #------------------------------------------------------
  }
}

toc(log=TRUE) # PDF>>txt OVERALL	

#==============================================================

write(imglist,paste0(file.path(bin,"img_pdf_list.txt") ) )
write(unlist(tic.log(format=T)), file.path(log, paste0("log_PDF2txt_",timestamp,".txt")) )
# close(pb)
tic.clearlog()
closeAllConnections()




