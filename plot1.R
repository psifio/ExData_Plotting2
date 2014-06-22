#source data file
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

#data file will be downloaded with this name in local working directory
localfilename<-"FNEI_data.zip"

#download file
#mode="wb" needed to make sure file is downloaded as binary
zippedFile<-download.file(fileUrl,destfile=localfilename,mode="wb") 

#unzip files
SCCfile<-unzip(localfilename,files="Source_Classification_Code.rds", overwrite=TRUE)
NEIFile<-unzip(localfilename,files="summarySCC_PM25.rds", overwrite=TRUE)

SCC <- readRDS(SCCfile)
NEI <- readRDS(NEIFile)

#aggregate Emissions values by year
aggregatedNEI<-aggregate(Emissions~year,data=NEI,FUN=sum)

#construct and save the plot file
png(file="plot1.png")
plot(aggregatedNEI$year,aggregatedNEI$Emissions,type="o",xlab="year",ylab="Total Emissions")
dev.off()

