
library(caret)
library(ggplot2)
library(pls)
library(data.table)
library(rpart)
library(bst)
library(plyr)
library(MASS)
nLag <- 12
khorizon <- 1

loja2 <- read.csv("./databases/store2.csv", header = TRUE, sep = ";", quote = "\"")
plot(loja2$Date,loja2$Sales)
acf(loja2$Sales)

plot(loja2$Sales, type = 'l')

base <- loja2
base$Sales = (base$Sales-min(base$Sales))/(max(base$Sales)-min(base$Sales))
  
base <- setDT(base)[, paste0('Sales', 1:nLag) := shift(Sales, 1:nLag)][]
base <- base[(nLag+1):nrow(base),]



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

  plsFitTime <- train(Sales ~  .,
                      data = base[trainSlices[[i]],], 
                      method = "treebag"
                      )
  
  

  pred <- predict(plsFitTime,base[testSlices[[i]],])


  true <- base$Sales[testSlices[[i]]]

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
#   true <- baseTrain$Sales[i]
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
