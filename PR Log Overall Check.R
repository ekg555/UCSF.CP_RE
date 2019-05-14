# https://cran.r-project.org/web/packages/DataExplorer/vignettes/dataexplorer-intro.html

rm(list=ls())

dsktp <- 'c:/Users/ekonagaya/Desktop'
wkdir <- 'c:/Users/ekonagaya/Desktop/PRLog_check'
outfile_prefix <- 'PRLOG_check '
a <- 1
if(!dir.exists(wkdir)) { dir.create(wkdir) }

library(readxl)
library(DataExplorer)

 timestp <- format(Sys.time(), "%Y-%m-%d.%H")

setwd(wkdir)

dat1 <- read_excel('PRLog 4-30.xlsx') # Just a copy-paste from access to excel

pdf( paste(outfile_prefix, a, 'STRUCTURE.pdf') )
plot_str(dat1)
dev.off()
a <- a + 1


View(t(introduce(dat1)))

pdf( paste(outfile_prefix, a, 'INTRO.pdf') )
plot_intro(dat1, title= paste0('PRLog Check (INTRO): ', timestp) )
dev.off()
a <- a + 1

dev.new(width=30, height=35)
pdf( paste(outfile_prefix, a, 'MISSING_DATA.pdf') )
plot_missing(dat1, title= paste0('PRLog Check (MISSING DATA): ', timestp) )
dev.off()
a <- a + 1

pdf( paste(outfile_prefix, a, 'BAR_PLOT.pdf') )
plot_bar(dat1, title= paste0('PRLog Check (BAR PLOT): ', timestp) ))
plot_histogram(dat1)
dev.off()
a <- a + 1

printer = file('missingness.csv','w')
	write(paste('FIELD','n.NA','%.NA', sep=','), printer, append=T)
	# POPULATE MISSINGNESS.csv
	for (i in 1:length(dat1)) { write( paste0(names(dat1[i]), ",",
												sum(is.na(dat1[i])), ",",
												round( (sum(is.na(dat1[i]))/nrow(dat1)) ,3) ), printer, append=T ) }
close(printer)
shell.exec('missingness.csv')
