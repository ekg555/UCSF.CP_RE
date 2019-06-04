numeROWs <- which(!is.na(PRLog$'Building Name'))
numeros <- unname(unlist(PRLog[numeROWs, "Number Levels"]))

PRLog$NL <- PRLog$'Number Levels'
PRLog$NL[numeROWs] <- unlist(BLDGlist[match(numeros, BLDGlist$'Sequence ID'), "Number Levels"])



# 		Die Zwolf: the 12 BLDGs 
#			w/ UNKNOWN Num LvLs.
# --------------------------------------------------------------------
#		- SKIP (i.e., keep NL in PRLog in-tact)
#		- save a record of the 'votes' of NL, for each mystery-bldg, by PRLog.
# --------------------------------------------------------------------
# length(PRLog[which(as.numeric(PRLog$'Number Levels') > 43),"Number Levels"])	# n=4748

NL.NA <- BLDGlist[is.na(BLDGlist$'Number Levels'),]		# The BLDGs in-question
NL.NA.seqid <- sort(NL.NA$'Sequence ID', decr=T)		# The seqIDs for the BLDGs in-question

NL.NA.Bname <- unname(unlist(BLDGlist[which(is.na( as.numeric(BLDGlist$'Number Levels') )), "Building Name"])) 	# 'Die Zwolf'
						# write.csv(PRLog[which(PRLog$'Building Name' %in% NL.NA.Bname),], "asdf.csv")
						# shell.exec("asdf.csv")

		#		(Die Zwolf) In PRLog...
		# --------------------------------------------------------------------
		
		# REMEMBER TO SKIP THESE (keep them in-tact)!!
		PR.NL.NA.seqid <- unname(unlist(PRLog[which(PRLog$'Building Name' %in% NL.NA.Bname),"Seq ID"]))		# (seqid) Die Zwolf in PRLog: n=379
				
				# SAVE WHAT THE PRLOG Declares re: "Die Zwolf".
				write.csv(PRLog[PR.NL.NA.seqid,], "BLDGs w No NumLvL.csv")
				shell.exec("BLDGs w No NumLvL.csv")


		# ALL POSSIBLE NLs (according to [UCSF Building List] on 6/4/2019)
		# --------------------------------------------------------------------
		possibleNLs <- sort(unique(BLDGlist$'Number Levels'), decr=T)	# All possible NLs: 43 28 24 22 18 17 16 14 11 10  9  8  7  6  5  4  3  2  1  0

				# PRLog$'Number Levels'
				as.numeric(PRLog$'Number Levels') #NOTE: 2x "TBD" -> NA (coerced)
				as.numeric(PRLog$'Number Levels') %in% possibleNLs

				# The ones that may require closer inspec.
				PRLog[as.numeric(PRLog$'Number Levels') %in% possibleNLs,]		# n=1379


unname(unlist(PRLog[as.numeric(PRLog$'Seq ID') %in% PR.NL.NA.seqid, "Seq ID"]))	# PRLog SeqIDs to skip (Die Zwolf)
# unname(unlist(PRLog[which(as.numeric(PRLog$'Seq ID') %in% PR.NL.NA.seqid), "Seq ID"]))	# Alternate

impossibNL <- which(!as.numeric(PRLog$'Number Levels') %in% possibleNLs)	# row#s, Not in Any of the Possible-NLs (n = 6681)
BLDGKnown <- which(!PRLog$'Seq ID' %in% PR.NL.NA.seqid)	# row#s, Not one of 'Die Zwolf' (n = 7681).

numeROWs <- intersect(impossibNL, BLDGKnown)

# 		IF NL > 43, JUST DECODE.
# --------------------------------------------------------------------
# length(PRLog[which(as.numeric(PRLog$'Number Levels') > 43),"Number Levels"])	# n=4748

PRLog[which(as.numeric(PRLog$'Number Levels') > 43),"Number Levels"]

numeROWs <- which(as.numeric(PRLog$'Number Levels') > 43)
PRLog$CT[numeROWs] <- unlist(BLDGlist[match(numeros, BLDGlist$'Sequence ID'), "Number Levels"])



