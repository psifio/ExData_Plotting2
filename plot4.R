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

#locate line indexes containing coal combustion SCC codes
coalLines<-grep("[Cc]oal",SCC$Short.Name)
#make a new data frame containing these lines
SCCcoal<-SCC[coalLines,c("SCC", "Short.Name")]

#merge with NEI to get a new data frame containing only the wanted observations
NEIcoal <- merge(NEI, SCCcoal, by="SCC")

#aggregate Emissions by year
aggregatedNEIcoal<-aggregate(Emissions ~ year, data=NEIcoal, FUN=sum)

#construct and save the plot file
require(ggplot2)
png(file="plot4.png")

qplot(year,Emissions,data=aggregatedNEIcoal,
      main="Coal Combustion Emissions US")+geom_line()

dev.off()

