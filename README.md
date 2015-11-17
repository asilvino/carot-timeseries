# TreeRegressionExamples
Tree regression time series examples <br/>
These examples are using "caret","data.table" and "pls" libraries.

#install.packages("caret")
#install.packages("data.table")
#install.packages("pls")

All the databases were retrived from the following places:
<br/>
S&P500 Index1 (from January 2, 1990 to December 31, 1999),
SP500 -> <br/>
> library(MASS)
> data(SP500)
> plot(SP500, type = 'l')

http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/#Data

The monthly supply of electricity (millions of kWh), beer (Ml),
and chocolate-based production (tonnes) in Australia over the period January
1958 to December 1990 are available from the Australian Bureau of Statistics
(ABS).
 <br/>
elec -> <br/>
http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/cbe.dat

Temperature data (1850–2007; see Brohan et al. 2006) for the southern
hemisphere were extracted from the database maintained by the University
of East Anglia Climatic Research Unit
<br/>
shtemp -> <br/>
http://staff.elena.aut.ac.nz/Paul-Cowpertwait/ts/stemp.dat

The other databases are from :
https://www.kaggle.com/c/rossmann-store-sales/data
store1 -> <br/>
store2 -> <br/>



