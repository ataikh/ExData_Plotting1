#Packages
#########
library(RCurl)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
library(lubridate)
library(scales)
library(ggplot2)
library(gridExtra)


#Downloading and unzipping the data
###################################

#Creating the directory if it does not exist
if(!file.exists("C:\\Users\\Owner\\Desktop\\Exploratory Data Analyses")){ 
    dir.create("C:\\Users\\Owner\\Desktop\\Exploratory Data Analyses")   
}
#Downloading the file
file.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file.url, destfile = "C:\\Users\\Owner\\Desktop\\Exploratory Data Analyses\\Data.zip", method = "libcurl") 
#unzipping the file
unzip(zipfile="C:\\Users\\Owner\\Desktop\\Exploratory Data Analyses\\Data.zip",
      exdir="C:\\Users\\Owner\\Desktop\\Exploratory Data Analyses")

#Reading the File
#################

HPC_Original <- read.csv("C:/Users/Owner/Desktop/Exploratory Data Analyses/household_power_consumption.txt", sep=";")
str(HPC_Original)

#Extracting Desired Date Range
##############################

#Recoding date and time columns into character format
HPC_Original$Date <- as.character(HPC_Original$Date)
HPC_Original$Time <- as.character(HPC_Original$Time)
#Joining the two columns into one
HPC_Original$Index = paste(HPC_Original$Date, HPC_Original$Time, sep=" ")
#Converting Index column into date/time formats
HPC_Original$Index <- dmy_hms(HPC_Original$Index, tz = "EST") #Set tz to the time zone you are currently in


#Selecting range of dates
HPC <- subset(HPC_Original, Index >= "2007-02-01 00:00:00"  & Index <= "2007-02-02 23:59:00")
#Writing to text file
write.table(HPC, "C:/Users/Owner/Desktop/Exploratory Data Analyses/HPC_Selected.txt", sep="\t")

#Formatting Date and Time
#########################
#Converting Index column into date/time formats if the file is loaded from text 
HPC$Index <- dmy_hms(HPC$Index, tz = "EST") #Set tz to the time zone you are currently in

str(HPC)

#============================================================================================================


######
#PLOT3
######

#Checking and formatting the Sub_metering variables
str(HPC)
HPC$Sub_metering_1 <- as.numeric(as.character(HPC$Sub_metering_1))
HPC$Sub_metering_2 <- as.numeric(as.character(HPC$Sub_metering_2))
HPC$Sub_metering_3 <- as.numeric(as.character(HPC$Sub_metering_3))

#Constructing and saving plot as .png file
png("plot3.png", width=480, height=480)
ggplot() +
    geom_line(data = HPC, aes(x = Index, y = Sub_metering_1, color = "Sub_metering_1")) +
    geom_line(data = HPC, aes(x = Index, y = Sub_metering_2, color = "Sub_metering_2")) +
    geom_line(data = HPC, aes(x = Index, y = Sub_metering_3, color = "Sub_metering_3")) +
    scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%a")) +
    labs (y = "Energy sub metering", x = "") +
    theme(legend.title=element_blank(), legend.position = c(.75,.75))
dev.off()






