library(caret)
library(ggplot2)
library(pls)
library(data.table)
library(rpart)
library(bst)
library(plyr)

nLag <- 12
khorizon <- 1

www <- "./databases/elec.dat"
CBE <- read.table(www, header = T)
base <- CBE
variable <- 'elec'
base$elec = (base$elec-min(base$elec))/(max(base$elec)-min(base$elec))
  
base <- setDT(base)[, paste0(variable, 1:nLag) := shift(elec, 1:nLag)][]
base <- base[(nLag+1):nrow(base),]

Elec.ts <- ts(CBE[, 1], start = 1958, freq = 12)
plot(cbind(Elec.ts))

# Start the clock!
ptm <- proc.time()


timeSlices <- createTimeSlices(1:nrow(base), 
                   initialWindow =nrow(base)*2/3, horizon = khorizon , fixedWindow = FALSE)
str(timeSlices,max.level = 1)
trainSlices <- timeSlices[[1]]
testSlices <- timeSlices[[2]]
predTest  <- c(1,2)
predTest  <- predTest[0]
trueTest  <- c(1,2)
trueTest  <- trueTest[0]

for(i in 1:length(trainSlices)){

  plsFitTime <- train(elec ~  .,
                      data = base[trainSlices[[i]],], 
                      method = "treebag"
                      )
  
  

  pred <- predict(plsFitTime,base[testSlices[[i]],])


  true <- base$elec[testSlices[[i]]]

  if(i==1){

    predTest <- c(predTest,pred)
    trueTest <- c(trueTest,true)
  }else{
    predTest <- c(predTest,pred[khorizon])
    trueTest <- c(trueTest,true[khorizon])
  }

}
mseTest <- mean( (predTest- trueTest)^2, na.rm = TRUE)
div <- abs((trueTest - predTest)/trueTest)
mapeTest <- mean(div[is.finite(div)], na.rm = TRUE)
mapeTest
mseTest
plsFitTime

plot(predTest,type="l",col="red")
lines(trueTest,col="green")

acf(CBE$elec)

# Stop the clock
proc.time() - ptm

#start train
ptm <- proc.time()
predTrain  <- c(1,2)
predTrain  <- predTrain[0]
trueTrain  <- c(1,2)
trueTrain  <- trueTrain[0]

baseTrain <- base[1:nrow(base)*2/3,]

for(i in 1:nrow(baseTrain)){
  pred <- predict(plsFitTime,baseTrain[i,])
  true <- baseTrain$elec[i]
  predTrain <- c(predTrain,pred)
  trueTrain <- c(trueTrain,true)
}

mseTrain <- mean( (predTrain- trueTrain)^2, na.rm = TRUE)
div <- abs((trueTrain - predTrain)/trueTrain)
mapeTrain <- mean(div[is.finite(div)], na.rm = TRUE)
mapeTrain
mseTrain
proc.time() - ptm

plot(predTrain,type="l",col="red")
lines(trueTrain,col="green")
