

library(caret)
library(ggplot2)
library(pls)

library(data.table)
library(rpart)


library(MASS)

nLag <- 12
khorizon <- 1

www <- "./databases/stemp.dat"
#TEMP2 <- read.csv("c:/ar/project/databases/shtemp2.csv", header = TRUE, sep = ";", quote = "\"")

TEMP <- read.table(www, header = T)
TEMP2 <- read.table(www, header = T)
Temp.ts <- ts(TEMP[, 1], start = 1958, freq = 12)
temp <- TEMP[, 1]
plot(cbind(Temp.ts))


TEMP2 <- setDT(TEMP2)[, paste0('temperature', 1:nLag) := shift(temperature, 1:nLag)][]
TEMP2 <- TEMP2[(nLag+1):nrow(TEMP2),]

# Start the clock!
ptm <- proc.time()

base <- TEMP2
timeSlices <- createTimeSlices(1:nrow(base), 
                   initialWindow =nrow(base)*2/3, horizon = khorizon , fixedWindow = FALSE)
str(timeSlices,max.level = 1)
trainSlices <- timeSlices[[1]]
testSlices <- timeSlices[[2]]
predT  <- c(1,2)
predT  <- predT[0]
trueT  <- c(1,2)
trueT  <- trueT[0]
#choc	beer	elec

for(i in 1:length(trainSlices)){
  nLag <- length(trainSlices[[i]])

  plsFitTime <- train(temperature ~  .,
                      data = base[trainSlices[[i]],], 
                      method = "pls",
                      preProc = c("center", "scale"))
  pred <- predict(plsFitTime,base[testSlices[[i]],])


  true <- base$temperature[testSlices[[i]]]
  if(i==1){

    predT <- c(predT,pred)
    trueT <- c(trueT,true)
  }else{
    predT <- c(predT,pred[khorizon])
    trueT <- c(trueT,true[khorizon])
  }

}
mse <- mean( (predT- trueT)^2, na.rm = TRUE)
mape <- mean(abs((trueT - predT)/trueT), na.rm = TRUE)
mape
mse
# Stop the clock
proc.time() - ptm

plsFitTime

testTem_pred <- predT
testTem_true <- trueT

plot(testTem_pred,type="l",col="red")
lines(testTem_true,col="green")

acf(base$temperature)

