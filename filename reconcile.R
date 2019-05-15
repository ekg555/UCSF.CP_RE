# WAS USED TO RECONCILE 'constructed .pdf filenames (from .txt)' vs. the 'actual .pdf filenames'
#  - yes, some didn't match
#  - later found: 'Xpdf.pdf' turns into '.pdf.pdf' where X is any character.
#


# MAY NEED SOME DECIPHERING, but this thing works (THROWS Warnings though)

constDts$PDFs <- paste0(substr(constDts[,1], 1, nchar(constDts[,1])-4),".pdf")
noMatch <- !file.exists(constDts$PDFs) # Bool-vec

for (i in 1:length(noMatch)) {
# print( constDts$PDFs[noMatch][i] )  							# TXT filename
# print( agrep(constDts$PDFs[noMatch][i], PDFlist, value=T) ) 	# PDF FILENAME
constDts$PDFs[noMatch][i] <- agrep(constDts$PDFs[noMatch][i], PDFlist, value=T)
}			

list1 <- c('asdf.txt', 'asdf asdfpdf.txt', 'qwert pdf.txt')
paste0(substr(list1, 1, nchar(list1)-4),".pdf")