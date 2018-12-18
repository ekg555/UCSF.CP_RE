library(tictoc)

setwd("C:/Users/ekonagaya/Desktop/CO_Signed")

tic('checking pages>1')
for (i in 1:length(flist)) {
	if ( as.numeric(pdf_info(flist[i])$pages>1) ) { print(flist[i]) }
	}
toc()

# checking pages>1: 3.67 sec elapsed