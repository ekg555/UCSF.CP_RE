# Now that '0din PRIME' selects all w/ 
# [Building Name] = "[Const Tp] = [Num Lvl] = [Occ Class]"...
#
#
# Assessment Tool for the 
#  more complex problem of rows w/ "[Const Tp] <> [Num Lvl] <> [Occ Class]"
#  that 0din omits.
#

#  Upon re-inspec, found that the "[CT],[NL],[OC]" fields 
#                   VARY a little more than expected
# --------------------------------------------------------------------
# ALL 3...
# - LookUp: Limit (-); ... Allow Value Edits (+) ... yikes
# ====================================================================

dsktp <- 'c:/users/ekonagaya/Desktop'

# copy the relevant column in MS Access
# x <- readClipboard()

 # write.csv(sort(table(x[grep("[^0-9]",x)]), decr=T), 'asdf.csv')

#  QUICK head-ct.
# --------------------------------------------------------------------
# length(x[grep("[^0-9]",x))			# n w/ non-numbers
# length(unique(x[grep("[^0-9]",x)))	# n UNIQUE w/ non-numbers

# writeClipboard(unique(x[grep("[^0-9]",x)]))

# ====================================================================
