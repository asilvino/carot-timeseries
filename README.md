# TreeRegressionExamples
Tree regression time series examples <br/>
These examples are using "caret","data.table" and "pls" libraries.

` install.packages("caret")`<br/>
` install.packages("data.table")`<br/>
` install.packages("bst")`<br/>

##Databases:

- SP500.csv
- elec.dat	
- stemp.dat	
- store1.csv
- store2.csv

All the databases were retrived from the following places:
<br/><br/>
**S&P500** Close value of day (daily)(from January 2, 1990 to December 31, 1999).<br/>
SP500 -> <br/>
> library(MASS)<br/>
> data(SP500)<br/>
> plot(SP500, type = 'l')<br/>

**elec.dat** and **stemp.dat** are from the Paul Cowpertwait's databases, from **Introductory Time Series with R** <br/>
http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/#Data

The monthly supply of electricity (millions of kWh), beer (Ml),
and chocolate-based production (tonnes) in Australia over the period January
1958 to December 1990 are available from the Australian Bureau of Statistics
(ABS).
 <br/>
**elec** -> <br/>
http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/cbe.dat

The monthly temperature data (1850–2007; see Brohan et al. 2006) for the southern
hemisphere were extracted from the database maintained by the University
of East Anglia Climatic Research Unit
<br/>
**stemp** -> <br/>
http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/stemp.dat

The other databases **store1** ,**store2**  are from :
https://www.kaggle.com/c/rossmann-store-sales/data<br/>
You are provided with historical sales data for 1,115 Rossmann stores, from 01/01/2013 to 31/07/2015. The task is to forecast the "Sales" column for the test set. Note that some stores in the dataset were temporarily closed for refurbishment.<br/>
The date is in one column<br/>
**store1** -> store1.csv <br/>
**store2** -> store2.csv <br/>

#Basic approach
```
variabla<- 'the-predictable-variable'
nLag <- 12
khorizon <- 1
#adding the lag's as atributes in the base
base <- setDT(base)[, paste0(variable, 1:nLag) := shift(elec, 1:nLag)][]
base <- base[(nLag+1):nrow(base),]
#creating the times slices just like this image:
<img src='https://raw.githubusercontent.com/alvarojoao/TreeRegressionExamples/master/imagens/slices.png'>
timeSlices <- createTimeSlices(1:nrow(base), 
                   initialWindow =nrow(base)*2/3, horizon = khorizon , fixedWindow = FALSE)
str(timeSlices,max.level = 1)
trainSlices <- timeSlices[[1]]
testSlices <- timeSlices[[2]]
for(i in 1:length(trainSlices)){
  plsFitTime <- train(variable ~  .,
                      data = base[trainSlices[[i]],], 
                      method = "treebag"
                      )
  pred <- predict(plsFitTime,base[testSlices[[i]],])
  true <- base$elec[testSlices[[i]]]
}
```
`...`
`method = "treebag"#here we can change for any other from this list:`[here](http://topepo.github.io/caret/modelList.html)
`....`
##Have FUN!<br/>
references:<br/>
[caret lib](http://topepo.github.io/caret/splitting.html#time)<br/>
[r-blogger time series cross validation](http://www.r-bloggers.com/time-series-cross-validation-5/)<br/>
