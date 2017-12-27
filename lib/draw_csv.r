
library(lattice)
library(RColorBrewer)
library(latticeExtra)

args <- commandArgs(trailingOnly=TRUE)
datafile=args[1]
datafile2=args[2]
y=args[3]
y2=args[4]
regex=args[5]
title=args[6]
xname=args[7]
yname=args[8]
y2name=args[9]
yleg1=args[10]
yleg2=args[11]
scater=args[12]
grid=args[13]
legend=args[14]
zero=args[15]
monochrome=args[16]
xtype=args[17]
sep=args[18]
output=args[19]

title = gsub("\\\\n","\n",title)

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

if(zero=='true'){
    lim = c(0,NA)
} else {
    lim = c(NA,NA)
}

if(legend=="false"){
    l = FALSE
} else if(scater=="true") {
    l = list(space='bottom', lines=F, points=T, columns=3)
} else {
    l = list(space='bottom', lines=T, points=F, columns=3)
}

dataset <- read.csv(datafile, header=TRUE, sep=sep)

if(xtype=="timestamp"){
    dataset$timestamp = as.POSIXct(dataset$time, origin="1970-01-01")
}

n = names(dataset[,-1,drop=FALSE])
if(y==""){
    f <- paste(paste(n, collapse="+"),
         names(dataset[,1,drop=FALSE]),
         sep=" ~ ")
} else if(grepl("1", regex)) {
    g = grep(y,n, value=TRUE, perl=TRUE)
    f <- paste(paste(g, collapse="+"),
         names(dataset[,1,drop=FALSE]),
         sep=" ~ ")
}else{
    f <- paste(y,names(dataset[,1,drop=FALSE]),sep=" ~ ")
}

if(datafile2 != ""){

    dataset2 <- read.csv(datafile2, header=TRUE, sep=sep)

    if(xtype=="timestamp"){
        dataset2$timestamp = as.POSIXct(dataset2$time, origin="1970-01-01")
    }

    n2 = names(dataset2[,-1,drop=FALSE])
    if(y2==""){
        f2 <- paste(paste(n2, collapse="+"),
             names(dataset2[,1,drop=FALSE]),
             sep=" ~ ")
    } else if(grepl("2", regex)) {
        g2 = grep(y2,n2, value=TRUE, perl=TRUE)
        f2 <- paste(paste(g2, collapse="+"),
             names(dataset2[,1,drop=FALSE]),
             sep=" ~ ")
    }else{
        f2 <- paste(y2,names(dataset2[,1,drop=FALSE]),sep=" ~ ")
    }
}

if (datafile2 == ""){
    xyplot(as.formula(f), data=dataset, pch=20, auto.key=l,type=type, main=list(title, cex=1.8), xlab=list(xname, cex=1.8), ylab=list(yname, cex=1.8), scales=list(tck=c(1,0), x=list(cex=1.5), y=list(cex=1.5, rot=90)), cex=0.5, ylim=lim)
} else  {
    attach(mtcars)
    p1 <- xyplot(as.formula(f), data=dataset, pch=20, auto.key=l,type=type, main=list(title, cex=1.8), xlab=NULL, ylab=list(yname, cex=1.8), scales=list(tck=c(1,0), x=list(cex=0), y=list(cex=1.5, rot=90)), cex=0.5, ylim=lim)
    p2 <- xyplot(as.formula(f2), data=dataset2, pch=20, type=type, main=list(title, cex=1.8), xlab=list(xname, cex=1.8), ylab=list(y2name, cex=1.8), scales=list(tck=c(1,0), x=list(cex=1.5), y=list(cex=1.5, rot=90)), cex=0.5, ylim=lim)
    print(p1, split=c(1,1,1,2), more=T)
    print(p2, split=c(1,2,1,2))
}
