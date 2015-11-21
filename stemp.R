 
library(caret)
library(ggplot2)
library(pls)
library(data.table)
library(rpart)
library(bst)
library(plyr)

nLag <- 12
khorizon <- 1

www <- "./databases/stemp.dat"
TEMP <- read.table(www, header = T)
base <- TEMP
variable <- 'temperature'
base$temperature = (base$temperature-min(base$temperature))/(max(base$temperature)-min(base$temperature))
  
base <- setDT(base)[, paste0('temperature', 1:nLag) := shift(temperature, 1:nLag)][]
base <- base[(nLag+1):nrow(base),]

Temp.ts <- ts(TEMP[, 1], start = 1958, freq = 12)
acf(TEMP$temperature)

plot(cbind(Temp.ts))


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

  plsFitTime <- train(temperature ~  .,
                      data = base[trainSlices[[i]],], 
                      method = "treebag"
                      )
  
  

  pred <- predict(plsFitTime,base[testSlices[[i]],])


  true <- base$temperature[testSlices[[i]]]

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


# Stop the clock
proc.time() - ptm

# #start train
# ptm <- proc.time()
# predTrain  <- c(1,2)
# predTrain  <- predTrain[0]
# trueTrain  <- c(1,2)
# trueTrain  <- trueTrain[0]

# baseTrain <- base[1:nrow(base)*2/3,]

# for(i in 1:nrow(baseTrain)){
#   pred <- predict(plsFitTime,baseTrain[i,])
#   true <- baseTrain$temperature[i]
#   predTrain <- c(predTrain,pred)
#   trueTrain <- c(trueTrain,true)
# }

# mseTrain <- mean( (predTrain- trueTrain)^2, na.rm = TRUE)
# div <- abs((trueTrain - predTrain)/trueTrain)
# mapeTrain <- mean(div[is.finite(div)], na.rm = TRUE)
# mapeTrain
# mseTrain

# proc.time() - ptm

# plot(predTrain,type="l",col="red")
# lines(trueTrain,col="green")
