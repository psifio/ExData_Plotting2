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
NEIbaltimore<-NEI[NEI$fips=="24510",]

#locate line indexes containing motor vehicles SCC codes
vehicleLines<-grep("[Vv]ehicle",SCC$EI.Sector)
#make a new data frame containing these lines
SCCvehicle<-SCC[vehicleLines,c("SCC", "EI.Sector")]

#merge with NEIbaltimore to get a new data frame containing only the wanted observations
NEIbaltimoreVehicles <- merge(NEIbaltimore, SCCvehicle, by="SCC")

#aggregate Emissions by year
aggregatedNEIbaltimoreVehicles<-aggregate(Emissions ~ year, data=NEIbaltimoreVehicles, FUN=sum)

#construct and save the plot file
require(ggplot2)

png(file="plot5.png")
qplot(year,Emissions,data=aggregatedNEIbaltimoreVehicles,
      main="Emissions from motor vehicles in Baltimore")+geom_line()
dev.off()

