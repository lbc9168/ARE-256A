***DISCUSSION 3
***MERGING DATA SETS IN STATA, DEALING WITH DATE VARIABLES,
***CREATING LOOPS, AND OTHER IMPORTANT STUFF

***When starting a new project, clear the data in Stata
clear all
set more off

* Move to the directory in which your data is locate / provide Stata with the 
* to your data directory.
cd "F:\256 A TA"

***Import data from an Excel File on the COKE company
import excel "COKE", firstrow
foreach i in open high low close volume adjclose{
	rename `i' coke_`i'
}
***Save the COKE data file as a Stata data file called "COKE" so you can merge it later
save COKE, replace

***Clear the Data
clear

***Import data from an Excle file on the S&P 500 Index
import excel "MARKET", firstrow

***RENAME THE VARIABLES IN THE S&P 500 DATA
foreach i in open high low close volume adjclose{
	rename `i' market_`i'
}	
***Save the S&P 500 data as a Stata data file called "MARKET" so you can merge it later
save MARKET, replace

***CLEAR THE DATA
clear

***Import data from the 13-Week Treasury Yield 
import excel "RISK_FREE", firstrow

***RENAME THE VARIABLES IN THE 13-WEEK TREASURY DATA
foreach i in open high low close volume adjclose{
	rename `i' risk_free_`i'
}	
***Merge the COKE data set with the 13-Week Treasury Yield Data 
merge 1:1 Date using COKE
drop _merge

***Merge the S&P 500 Data set with the data in Stata
merge 1:1 Date using MARKET
drop _merge


* Dates in can be tricky
help datetime
sort Date
gen newdate = Date
format %9.0g newdate
list Date newdate

* Notice the dates aren't quite right

display td(01jan1960)
display td(02jan1960)

* You can extract elements of a date format
gen year = year(Date)
gen month = month(Date)
gen day = day(Date)

***These commands make a variable called "ddate" which
***is a variable that shows the day , month, and year of the 

gen ddate = dofd(Date)
list Date ddate
format ddate %td
list Date ddate

***You can also make a variable that gives you the month and year
***if your data is monthly data
gen mmonth = mofd(Date)
list Date mmonth
format mmonth %tm
list Date mmonth

***You can rearrange the order of the variables in your data set
list Date ddate
order Date ddate
drop Date newdate

* Not always necessary but sometimes it is useful to let Stata know you have a 
* Time - Series (or eventually a panel).
tsset ddate

****
* Making a picture
****
tsline risk_free_close
tsline risk_free_close if inrange(ddate, td(01Jan2010),td(12Dec2010))

****
* Contructing new variables
****
gen coke_return = (coke_close-coke_close[_n-1])/(coke_close[_n-1])
gen coke_risk_premium = coke_return - risk_free_close
tsline coke_risk_premium, xtitle("Date") ytitle("COKE Risk Premium")

gen  market_return= (market_close - market_close[_n-1])/market_close[_n-1]
gen market_risk_premium = market_return - risk_free_close
tsline market_risk_premium
tsline market_risk_premium
tsline  risk_free_close


*******
* Brief aside: Constructing a loop
*******

*
* Simplest loop uses the by prefix.
* Data needs to be sorted ahead of issuing this command

bysort mmonth: sum coke_risk_premium

***RUNNING A LOOP TO MAKE VARIABLES
drop *_premium

local stocks "market coke"
foreach i of local stocks {
	gen `i'_risk_premium = `i'_return - risk_free_close
}

*******
* Let's plot the risk premiums
*******

tsline market_risk_premium coke_risk_premium if inrange(ddate, td(01Jan2005),td(31Mar2005)), xtitle("Date") ///
	legend(col(2) lab(1 "MARKET") lab(2 "COKE") stack) lpattern(longdash solid)

*****
* What do we think this will tell us about a company's Beta?
****

reg coke_risk_premium market_risk_premium

*****
* How would you plot the residuals?
*****
* First Generate them
predict e, resid

sum e
tsline e 
scatter  e market_risk_premium

* Can also predict outliers
*xb is the default, so you don't have to write it
predict coke_risk_premium_hat, xb
scatter coke_risk_premium_hat e


*****
* Now let's say we wanted to output this to a nicely formatted table
*****
* http://www.ats.ucla.edu/stat/stata/faq/estout.htm
* You have several options (estout, esttab, and outreg2)
findit estout
findit outreg2
findit esttab

estout
estout, cells(b(star fmt(3)) se(par fmt(2)))

* Lets try something a little fancier
***THESE COMMANDS RUN REGRESSIONS AND THEN SAVE THE ESTIMATES
***SO THAT WE CAN PUT THEM IN A NICE TABLE
***NOTE...THE ESTIMATES STORE COMMAND MUST BE USED RIGHT AFTER YOU
***RUN THE REGRESSION
reg coke_risk_premium market_risk_premium 
estimates store model1, title(COKE)

reg market_risk_premium coke_risk_premium
estimates store model2, title(MARKET)

***THE ESTTAB COMMAND MAKES A NICE TABLE
esttab model1 model2, se

**THE ESTAB COMMAND WITH THE "USING" MAKES A TABLE IN A WORD DOCUMENT
esttab model1 model2 using REGRESSION_TABLE.rtf, se replace

***THE ESTOUT COMMAND CAN ALSO BE USED TO MAKE NICE TABLES
***YOU CAN PLAY AROUND WITH THE OPTIONS (SEE BELOW)
estout model1 model2, cells(b(star fmt(3)) se(par fmt(2))) ///
	legend label varlabels(_cons Constant MARKET_P Beta)

estout model1 model2, cells(b(star fmt(3)) se(par fmt(2))) ///
	legend label varlabels(_cons Constant MARKET_P Beta)

estout model1 model2, cells(b(star fmt(3)) se(par fmt(2))) ///
	legend label varlabels(_cons Constant MARKET_P Beta) ///
	stats(r2, label(R2))












