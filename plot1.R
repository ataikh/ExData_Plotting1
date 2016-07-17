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
#PLOT1
######

#Checking and formatting Global_active_power variable
str(HPC)
HPC$Global_active_power <- as.numeric(as.character(HPC$Global_active_power))

#Constructing and saving plot as .png file
png("plot1.png", width=480, height=480)
ggplot(HPC, aes(x = Global_active_power)) +
    geom_histogram(binwidth = .5, colour = "black", fill = "red") +
    scale_x_continuous(breaks =seq(0,6,2)) +
    scale_y_continuous(breaks=seq(0, 1200, 500)) +
    labs (x = "Global Active Power (kilowatts)", y = "Frequency", title = "Global Active Power")
dev.off()








