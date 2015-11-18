# TreeRegressionExamples
Tree regression time series examples <br/>
These examples are using "caret","data.table" and "pls" libraries.

#install.packages("caret")
#install.packages("data.table")
#install.packages("pls")

All the databases were retrived from the following places:
<br/>
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
elec -> <br/>
http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/cbe.dat

The monthly temperature data (1850–2007; see Brohan et al. 2006) for the southern
hemisphere were extracted from the database maintained by the University
of East Anglia Climatic Research Unit
<br/>
stemp -> <br/>
http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/stemp.dat

The other databases are from :
https://www.kaggle.com/c/rossmann-store-sales/data<br/>
You are provided with historical sales data for 1,115 Rossmann stores. The task is to forecast the "Sales" column for the test set. Note that some stores in the dataset were temporarily closed for refurbishment.<br/>
The date is in one column<br/>
store1 -> store1.csv <br/>
store2 -> store2.csv<br/>



