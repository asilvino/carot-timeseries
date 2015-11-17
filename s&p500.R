



library(caret)
library(ggplot2)
library(pls)

library(data.table)
library(rpart)


library(MASS)

nLag <- 12
khorizon <- 1
#data(SP500)
sp500 <- read.csv("./databases/SP500.csv", header = TRUE, sep = ";", quote = "\"")
sp5002 <- read.csv("./databases/SP500.csv", header = TRUE, sep = ";", quote = "\"")

plot(sp500$SP500, type = 'l')
#acf(SP500)
sp5002 <- setDT(sp5002)[, paste0('SP500', 1:nLag) := shift(SP500, 1:nLag)][]
sp5002 <- sp5002[(nLag+1):nrow(sp5002),]
# Start the clock!
ptm <- proc.time()

base <- sp5002
khorizon <- 1

timeSlices <- createTimeSlices(1:nrow(base),initialWindow =nrow(base)*2/3, horizon = khorizon , fixedWindow = FALSE)
str(timeSlices,max.level = 1)
trainSlices <- timeSlices[[1]]
testSlices <- timeSlices[[2]]
predT  <- c(1,2)
predT  <- predT[0]
trueT  <- c(1,2)
trueT  <- trueT[0]
#choc	beer	elec

for(i in 1:length(trainSlices)){

  plsFitTime <- train(SP500 ~ ., 
                      data = base[trainSlices[[i]],], 
                       method = "pls",  preProc = c("center", "scale"))
  pred <- predict(plsFitTime,base[testSlices[[i]],])


  true <- base$SP500[testSlices[[i]]]
  if(i==1){

    predT <- c(predT,pred)
    trueT <- c(trueT,true)
  }else{
    predT <- c(predT,pred[khorizon])
    trueT <- c(trueT,true[khorizon])
  }
}
Testmse <- mean( (predT- trueT)^2, na.rm = TRUE)
Testmape <- mean(abs((trueT - predT)/trueT), na.rm = TRUE)
Testmape
Testmse
# Stop the clock
proc.time() - ptm
plsFitTime

SPTESTE_pred <- predT
SPTESTE_true <- trueT

plot(SPTESTE_pred,type="l",col="red")
lines(SPTESTE_true,col="green")

acf(base$SP500)


