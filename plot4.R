# author: T.E.
# run with: R x86_64 3.1.0

# Custom class to read-in the particular date format in the file
setClass('myDate')
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y"))

# read data & create DateTime column
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
png("plot4.png", width=480, height=480)

par(mfrow=c(2, 2))

plot(data$Global_active_power, ylab="Global Active Power", xlab="", type="l", xaxt="n")
axis(1, at=x_vals, lab=x_labels)

plot(data$Voltage, ylab="Voltage", xlab="datetime", type="l", xaxt="n")
axis(1, at=x_vals, lab=x_labels)

plot(data$Sub_metering_1, ylab="Energy sub metering", xlab="", type="l", xaxt="n")
points(data$Sub_metering_2, col="red", type="l")
points(data$Sub_metering_3, col="blue", type="l")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1, bty="n")
axis(1, at=x_vals, lab=x_labels)

plot(data$Global_reactive_power, ylab="Global_reactive_power", xlab="datetime", type="l", xaxt="n")
axis(1, at=x_vals, lab=x_labels)


dev.off()

