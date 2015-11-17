library(caret)
library(ggplot2)
library(pls)

loja1 <- read.csv("c:/ar/project/databases/train-loja1.csv", header = TRUE, sep = ";", quote = "\"")
plot(loja1$Date,loja1$Sales)

plot(loja1$Sales, type = 'l')

#data(economics)
#acf(resid(Beer.ima))
# Start the clock!
ptm <- proc.time()

base <- loja1
khorizon <- 1

timeSlices <- createTimeSlices(1:nrow(base), 
                   initialWindow =nrow(base)*2/3, horizon = khorizon , fixedWindow = FALSE)
str(timeSlices,max.level = 1)
trainSlices <- timeSlices[[1]]
testSlices <- timeSlices[[2]]
predT  <- c(1,2)
predT  <- predT[0]
trueT  <- c(1,2)
trueT  <- trueT[0]
#Store DayOfWeek   Date Sales Customers Open Promo  StateHoliday SchoolHoliday

for(i in 1:length(trainSlices)){
  nLag <- length(trainSlices[[i]])
  plsFitTime <- train(Sales ~ DayOfWeek + Customers + Open+Promo + StateHoliday + SchoolHoliday,
                      data = base[trainSlices[[i]][1:nLag],],
                      method = "pls",
                      preProc = c("center", "scale"))
  pred <- predict(plsFitTime,base[testSlices[[i]],])


  true <- base$Sales[testSlices[[i]]]
  predT <- c(predT,pred)
  trueT <- c(trueT,true)

#  plot(true, col = "red", ylab = "true (red) , pred (blue)", 
#            main = i, ylim = range(c(pred,true)))
#  points(pred, col = "blue") 
}
mse <- mean( (predT- trueT)^2, na.rm = TRUE)
mape <- mean(abs((trueT - predT)/trueT))
mape
mse
# Stop the clock
proc.time() - ptm
plsFitTime
testeLoja_pred <- predT
testeLoja_true <- trueT

plot(testeLoja_pred,type="l",col="red")
lines(testeLoja_true,col="green")

