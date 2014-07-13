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
data_full$DateTime <- strptime(paste(data_full$Date, data_full$Time), format="%Y-%m-%d %H:%M:%S")

# filter data
dt1 <- strptime("2007-02-01 00:00:00", format="%Y-%m-%d %H:%M:%S")
dt2 <- strptime("2007-02-03 00:00:00", format="%Y-%m-%d %H:%M:%S")

data <- data_full[data_full$DateTime >= dt1 & data_full$DateTime <= dt2 & !is.na(data_full$DateTime), ]

# calculate x-labels
x_vals <- seq(1, nrow(data), 1440)
x_labels <- sapply(dt[x_vals,]$Date, format, "%a")

# plot chart
png("plot2.png", width=480, height=480)
plot(data$Global_active_power, ylab="Global Active Power (kilowatts)", xlab="", type="l", xaxt="n")
axis(1, at=x_vals, lab=x_labels)
dev.off()
