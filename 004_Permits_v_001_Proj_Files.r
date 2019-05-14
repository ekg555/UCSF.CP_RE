# This was for Finding files that weren't in 004, 
# but was in the 001.
#
dsktp <- 'c:/Users/ekonagaya/Desktop'

setwd(dsktp)

x <- readLines('ListOPDFs_004 Permits_2019-4-30.txt')
y <- str_extract(x, "\\I\\d\\d*")

dat1 <- data.frame(x, y, stringsAsFactors=F); rm(list=c('x','y'))


x <- readLines('The_Lost_Permits.txt')
y <- str_extract(x, "\\I\\d\\d*")

dat2 <- data.frame(x, y, stringsAsFactors=F); rm(list=c('x','y'))


a <- unique(dat1$y)
b <- unique(dat2$y)

# use setdiff(x,y) = IN x BUT NOT in y, union() = OR , intersect() = AND
# inA.notB <- setdiff(a,b)	# NOT VERY USEFUL: In Permits, but not in Proj-Files.
inB.notA <- setdiff(b,a)	# Somewhere In 001-Proj Files, BUT Not In 004 Permits - 'unfiled permits'?
Missing_PERMITS <- dat2[which(dat2$y %in% inB.notA),]

write.csv(Missing_PERMITS, 'Missing_PERMITS.csv')
