***EVENT STUDY
clear 
import excel "MARKET", firstrow

***RENAME THE VARIABLES IN THE S&P 500 DATA
foreach i in Open High Low Close Volume AdjClose{
	rename `i' market_`i'
}	
sort Date
save S&P, replace
clear


***LOAD VOLKSWAGON DATA INTO STATA
clear
import excel "VW", firstrow

***MAKE THE DATE VARAIBLE
sort Date
sort Date
gen newdate = Date
gen ddate = dofd(Date)
format ddate %td

twoway (line Close Date, xline(20349))

***MERGE S&P Data
merge Date using S&P

**SET DATE AS THE TIME VARIABLE
tsset Date

***GENERATE MARKET RETURNS
gen market_return = (market_Close - market_Close[_n-1])/market_Close[_n-1]
gen vw_return = (Close - Close[_n-1])/Close[_n-1]
gen event = 0
replace event = 1 if Date==20349

***RUN THE CONSTANT MEAN RETURN MODEL
reg vw_return if Date<20349
predict abnormal_returns1, residuals

***GENERATE THETA 1 FROM MACKINLAY PAPER
***NOTE: THIS MAKES AN EVENT WINDOW OF 6 BUSINESS DAYS
egen car_bar_sum1 = total(abnormal_returns1) if Date>=20349 & Date<=20356
gen car_bar1 = car_bar_sum1/6
egen sd_abnormal_returns1 = sd(abnormal_returns1) if Date>=20349 & Date<=20356
gen sd_car_bar1 = sd_abnormal_returns1/(6^.5)

gen theta_1 = car_bar1/sd_car_bar1
***LOOK AT YOUR RESULTS 
***(CAN YOU REJECT THE NULL HYPOTHESIS THAT THETA 1 = 0???)
sum theta_1
twoway (line abnormal_returns1 Date, xline(20349) xline(20356)) if inrange(Date, 20342, 20363)


***RUN THE MARKET MODEL
reg vw_return market_return if Date<20349
predict abnormal_returns_2, residuals
twoway (line abnormal_returns_2 Date, xline(20349) xline(20356)) if inrange(Date, 20342, 20363)
