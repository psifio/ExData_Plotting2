setwd("C:/makisXPS/Rwork/ExData_Plotting2")

coalLines<-grep("[Cc]oal",SCC$Short.Name)
SCCcoal<-SCC[coalLines,c("SCC", "Short.Name")]
NEIcoal <- merge(NEI, SCCcoal, by="SCC")

aggregatedNEIcoal<-aggregate(Emissions ~ year, data=NEIcoal, FUN=sum)

qplot(year,Emissions,data=aggregatedNEIcoal,
      main="Coal Combustion Emissions US")+geom_line()


