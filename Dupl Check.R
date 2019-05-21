#  Checks for 
# =======================================
library(digest)
library(readxl)
library(dplyr)

dsktp <- 'C:/Users/ekonagaya/Desktop'
main_dir <- 'C:/Users/ekonagaya/Desktop/Dupl Check'
bin_dir <- file.path(main_dir, 'bin')

setwd(dsktp)

timestp <- format(Sys.time(), "%Y-%m-%d.%H")

if (!dir.exists(main_dir)) {	dir.create(main_dir) }
setwd(main_dir)
if (!dir.exists(bin_dir)) {	dir.create(bin_dir) }

# dat1 <- file.choose()
dat1 <- read_excel('4-16 PR Log.xlsx') 	# read in .xlsx

# =================================================================================
#  dat1_digest # A subset of the 'juciest' (most informative) part of the table
# =================================================================================
dat1_digest <-	select(dat1, 
				starts_with('seq id'),
				contains('project #'), 
				contains('projectname'), 
				contains('type of dwg'), 
				starts_with('status'),
				contains('review completion'))

# =====================================================================================
#   Generate SHA-1 hashes from ALL EXCEPT Seq ID (all 61 - as of 4/17/2019 - variables)
# =====================================================================================
dat1.hash <- apply(dat1[-1],1,function(x) { sha1(unlist(x)) })

# dat1_digest[duplicated(dat1.hash),] just 1 set of duplicated
dupes <- dat1_digest[duplicated(dat1.hash) | duplicated(dat1.hash, fromLast=T),] 		# all duplicates
dupes <- dupes[order(dupes$'Major Project #', dupes$'Type of Dwgs', dupes$'Seq ID'),]	# Sort 
View(dupes)

write.csv(dupes, paste0('PR_Log_duplicate_rows_', timestp, '.csv')) 	# SAVE to timestamped .csv


# SHA-1 hashes for just the digest-columns 
#  A LESS specific, but MORE sensitive check.
#  n = 50 total, in 4/17/2019.
# ==============================================================================
# dat1.dig_hash <- apply(dat1_digest[-1],1,function(x) { sha1(unlist(x)) })

# dupes.dig <- dat1_digest[duplicated(dat1.dig_hash) | duplicated(dat1.dig_hash, fromLast=T),]
# dupes.dig <- dupes.dig[order(dupes.dig$'Major Project #', dupes.dig$'Type of Dwgs', dupes.dig$'Seq ID'),]	# Sort 