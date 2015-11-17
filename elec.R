

library(caret)
library(ggplot2)
library(pls)
library(data.table)
library(rpart)

nLag <- 12
khorizon <- 1

www <- "c:/ar/project/databases/elec.dat"
CBE <- read.table(www, header = T)
#www2 <- "c:/ar/project/databases/elect2.dat"
www <- "c:/ar/project/databases/elec.dat"
# CBE2 <- read.csv("c:/ar/project/databases/elect2.csv", header = TRUE, sep = ";", quote = "\"")
CBE2 <- read.table(www, header = T)
CBE2 <- setDT(CBE2)[, paste0('elec', 1:nLag) := shift(elec, 1:nLag)][]
CBE2 <- CBE2[(nLag+1):nrow(CBE2),]
#CBE2 <- read.table(www2, header = T)
Elec.ts <- ts(CBE[, 1], start = 1958, freq = 12)
elec <- CBE[, 1]
plot(cbind(Elec.ts))

# Start the clock!
ptm <- proc.time()

base <- CBE2
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

  plsFitTime <- train(elec ~  .,
                      data = base[trainSlices[[i]],], 
                      method = "pls",
                      preProc = c("center", "scale"))
  
  

  pred <- predict(plsFitTime,base[testSlices[[i]],])


  true <- base$elec[testSlices[[i]]]

  if(i==1){

    predT <- c(predT,pred)
    trueT <- c(trueT,true)
  }else{
    predT <- c(predT,pred[khorizon])
    trueT <- c(trueT,true[khorizon])
  }

 # mean(plsFitTime[4]$results$RMSE)^2

}
mse <- mean( (predT- trueT)^2, na.rm = TRUE)
mape <- mean(abs((trueT - predT)/trueT))
mape
mse
plsFitTime

plot(predT,type="l",col="red")
lines(trueT,col="green")

acf(CBE$elec)
# Stop the clock
proc.time() - ptm

