# get.years <- function(y) {
#   dt <- read.csv(paste0("http://www.landregistry.gov.uk/market-trend-data/public-data/price-paid-data/price-paid-data-", y), header = FALSE)
#   assign(paste(y), dt, envir = .GlobalEnv)
# }
# years are in separate links
#-----------------------------------------

# Install dependencies
install.packages("plyr")
install.packages("lubridate")
install.packages("ggplot2")

# Load libraries
library(plyr)
library(lubridate)
library(ggplot2)

#------------------------------
# Get and combine the data
#------------------------------


mon.url  <- c(
"http://www.landregistry.gov.uk/__data/assets/file/0003/34806/PPMS_Jan_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0003/37551/PPMS_Feb_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0016/40354/PPMS_Mar_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0007/42739/PPMS_Apr_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0019/46090/PPMS_May_2013_ew_with-columns.csv",
"http://www.landregistry.gov.uk/__data/assets/file/0005/49505/PPMS_Jun_2013_ew_with-columns.csv")

var.names <- c("id", "price", "date", "postcode", "type", "new", "hold", "no", "no2", "street", "locality", "town", "authority", "county", "status")

# Function that reads the data
get.prices <- function(m, u) {
   dt <- read.csv(u, header = FALSE, stringsAsFactors = FALSE)
   assign(paste0(m), dt, envir = .GlobalEnv)
 }

#------------------------------
# Basic cleansing of the data
#------------------------------

#Fetch the data, available months
mapply(get.prices, month.abb[1:6], mon.url)

# Assign column headers
mon.df <- mget(month.abb[1:6])
sapply(mon.df, function(x) colnames(x) <- var.names)

prices <-  rbind.fill(mon.df)
# prices <-  rbind.fill(Jan, Feb, Mar, Apr, May, Jun)

# prices$date  <- strptime(prices$date, "%d/%m/%Y %H:%M")

prices$date  <- dmy_hm(prices$date)

#------------------------------
# Using the data to do some fun stuff
#------------------------------


# Search for your street
prices[grep("^EC2A .", prices$postcode), ]
prices[grep("CLIFTON STREET", prices$street), ]

summary(prices$date)

# Most expensive houses
prices[prices$price > 10000000, ]

# install.packages("ggplot2")
library(ggplot2)
ggplot(aes(prices), data = prices) + geom_histogram() + coord_trans(x = "log10")

