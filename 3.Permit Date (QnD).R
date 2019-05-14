#   Permit Date.R
#   (QUICK'n'DIRTY ed.)
# ----------------------------------------------------------------------
#  - INTERACTS w/ NETWORK (If it's DOWN, this WON'T WORK)
#  - LOOKS at metadata & collects:
#   	> size
#       > ModifyDate,
#       > Producer, 
#       > Pages,
# 	
# ======================================================================
library(pdftools)
library(stringr)

dsktp <- 'c:/users/ekonagaya/desktop'
pdrive <- 'u:/Construction Permits Issued/'

timestp <- format(Sys.time(), "%Y-%m-%d.%H")

setwd(pdrive)

flist <- grep('.*.pdf$', list.files(), value=T)
flist <- grep('I1050', flist, inv=T, value=T)	# removing I1050.  access restricted

#   BUILD Manifest >> Permit_mnf
# ========================================================================
if (!exists('Permit_mnf')) { Permit_mnf  <- file.info(flist) }	# Create Manifest of all files
Permit_mnf <- Permit_mnf[,grep('size|time',names(Permit_mnf))] # ONLY GRABBING 'size', & '...times' (a.k.a. the dates)

#   FILTER OUT ORIGINAL TIMES >> OVERWRITE Permit_mnf
# ========================================================================
Permit_mnf$ModifyDate <- as.Date(Permit_mnf[,grep('mtime',names(Permit_mnf))])
Permit_mnf$CreateDate <- as.Date(Permit_mnf[,grep('ctime',names(Permit_mnf))])
Permit_mnf$AccessDate <- as.Date(Permit_mnf[,grep('atime',names(Permit_mnf))])

#   GRAB Producers & Pages >> Prods & Pgs
# ========================================================================
Permit_mnf_intermed <- Permit_mnf[,-grep('time',names(Permit_mnf))]

if (!exists('Prods')) { Prods <- sapply( row.names(Permit_mnf), function(x) { pdf_info(x)$keys$Producer }  ) }
if (!exists('Pgs')) { Pgs <- sapply( row.names(Permit_mnf), function(x) { pdf_info(x)$pages }  ) }

#   COMPILE INTO >> Permit_mnf_FINAL
# ========================================================================
Permit_mnf_FINAL <- cbind(Permit_mnf_intermed, Producer = unlist(Prods), NumPages = unlist(Pgs) )
						  
#   SAVE TO FILE ("PermitINVENTORY..2019-05-...csv")
# ========================================================================
setwd(dsktp)
write.csv(Permit_mnf_FINAL, paste0('PermitINVENTORY ', timestp,'.csv'))
shell.exec(paste0('PermitINVENTORY ', timestp,'.csv'))
