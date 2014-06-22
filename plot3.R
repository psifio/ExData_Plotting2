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

#restrict dataset to Baltimore city
baltimoredata<-NEI[NEI$fips=="24510",]

#aggregate Emissions values by year and type
aggregatedBaltimore2<-aggregate(Emissions~year+type,data=baltimoredata,FUN=sum)

#construct and save the plot file
require(ggplot2)

png(file="plot3.png")
mytitle<-"PM2.5 Emissions Baltimore"
qplot(year,Emissions,data=aggregatedBaltimore2,
      facets=.~type,ylim=c(0,2500),main=mytitle)+geom_line()
dev.off()

