#	Rescue.R
# ========================================================================
#   Sister Script of Permit PDF SnR.R
# ------------------------------------------------------------------------
# After doing any pre-processing to the PATH & Dates sheet...
# COPY ALL PATHS of FILES to RESCUE in CLIPBOARD...then
dsktp <- 'c:/users/ekonagaya/desktop'
wkdir <- file.path(dsktp, "MIA PERMITs")

if (!dir.exists(wkdir)) { dir.create(wkdir) }

x <- readClipboard()
x <- gsub("\\\\", "/", x)
x <- x[-1]	# HEADER

file.copy(x[1],wkdir)
