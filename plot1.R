# author: T.E.
# run with: R x86_64 3.1.0

# Custom class to read-in the particular date format in the file
setClass('myDate')
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y"))

# read data
data_full <- read.table(
  "household_power_consumption.txt",
  header=TRUE,
  sep=";",
  na.strings="?",
  colClasses=c("myDate", "character", "numeric", "numeric",
               "numeric", "numeric", "numeric", "numeric", "numeric")
)

# filter data
d1 <- as.Date("2007-02-01", format="%Y-%m-%d")
d2 <- as.Date("2007-02-02", format="%Y-%m-%d")

data <- data_full[data_full$Date >= d1 & data_full$Date <= d2, ]

# plot chart
png("plot1.png", width=480, height=480)
hist(data$Global_active_power, col="Red", xlab="Global Active Power (kilowatts)", ylab="Frequency", main="Global Active Power")
dev.off()