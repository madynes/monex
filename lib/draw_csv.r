
library(lattice)

args <- commandArgs(trailingOnly=TRUE)
datafile=args[1]
y=args[2]
regex=args[3]
title=args[4]
xname=args[5]
yname=args[6]
scater=args[7]
grid=args[8]
legend=args[9]
monochrome=args[10]
xtype=args[11]
output=args[12]

if(output==""){
    pdf(file = "monex.pdf")
}else{
    pdf(file = output)
}

if(monochrome=="true"){
    lattice.options(default.theme = standard.theme(color = FALSE))
}


if(grid=="true"){
    g = "g"
} else {
    g = ""
}

if(scater=="true"){
    type = c("p",g)
} else {
    type = c("l",g)
}

if(legend=="false"){
    l = FALSE
} else {
    l = list(space='right')
}

dataset <- read.csv(datafile, header=TRUE, sep=";")

if(xtype=="timestamp"){
    dataset$timestamp = as.POSIXct(dataset$time, origin="1970-01-01")
}

n = names(dataset[,-1,drop=FALSE])
if(y==""){
    f <- paste(paste(n, collapse="+"),
         names(dataset[,1,drop=FALSE]),
         sep=" ~ ")
} else if(regex=="true") {
    g = grep(y,n, value=TRUE, perl=TRUE)
    f <- paste(paste(g, collapse="+"),
         names(dataset[,1,drop=FALSE]),
         sep=" ~ ")
}else{
    f <- paste(y,names(dataset[,1,drop=FALSE]),sep=" ~ ")
}

xyplot(as.formula(f), data=dataset, pch=20, auto.key=l,type=type, main=title, xlab=xname, ylab=yname, cex=0.5, cex.main=1.8, cex.lab=1.8, cex.axis=1.8)

