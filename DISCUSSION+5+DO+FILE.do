clear all

* Read in the data
import delimited waugh.txt, delimiter(space, collapse) 

sum

***Replicate Waugh's regression (are the results identical???)
reg  price green nostalks disperse

***Get the correlation matrix
correlate price green nostalks disperse
 
***Get the variance/covariance matrix
correlate price green nostalks disperse, covariance 

***SAMPLE LOOPS
* The simplest loop
* Many different kinds of "for" loops.  Two commonly used types.
* forvalues
* foreach

***"FORVALUES" ALLOWS YOU TO RUN LOOPS ON DIFFERENT NUMBER VALUES
forvalues i = 1(1)10 {
	display `i'
}
 
forvalues i = 1(1)10 {
	gen price_`i' = price^`i'
}

drop price_1-price_10

 * A simple loop
local vars green disperse nostalks

***"FOREACH" ALLOWS YOU TO RUN LOOPES ON DIFFERENT VARIABLES
foreach i of local vars {
	gen ln`i' = ln(`i')
}

foreach i of local vars {
	gen p_times_`i' = `i'*price
}

* Creating scalars
scalar d = 20
gen price_20 = price*d

* Sometimes you will want to keep track of intermediate values of computations
clear all

* Load a Data Frame
import excel chow.xlsx, sheet("chow.xls") firstrow

gen lnrent=log(RENT)
gen lnmult=log(MULT)
gen lnaccess=log(ACCESS)
gen lnadd=log(ADD)

gen mem=WORDS*BINARY*DIGITS
gen lnmem=log(mem)

* Using loops to create variables
* You could use a loop to create a dummy by hand.

forvalues i = 54(1)65 {
	gen D`i' = (YEAR == `i')
}
sum D54-D65

* What does Stata store after a regression? Check the "e" matrix by using
* the "ereturn" list
reg lnrent lnmem lnmult lnaccess
ereturn list


forvalues i = 60(1)62 {
reg lnrent lnmem lnmult lnaccess if YEAR == `i'
	scalar rss_`i' = e(rss)
}

scalar list

reg lnrent lnmem lnmult lnaccess if inrange(YEAR,60,62)
display rss_60+rss_61+rss_62

reg lnrent i.YEAR i.YEAR#c.lnmem if inrange(YEAR,60,62)
reg lnrent i.YEAR##c.lnmem if inrange(YEAR,60,62)
reg lnrent i.YEAR##c.(lnmem lnmult lnaccess) if inrange(YEAR,60,62)


**  How do you access coefficients: Use "_b" from the "e" matrix
display _b[lnmem]
display _b[_cons]

***Example: Create a scalar based on the coefficient on "lnmult"
scalar predicted_value_10 = 10*_b[lnmult]
display predicted_value_10

***Running loops with the _b command
scalar b_cumul = 1
forvalues i = 60(1)62 {
reg lnrent lnmem lnmult lnaccess if YEAR == `i'
	scalar b_lnmem_`i' = _b[lnmem]
	scalar b_cumul = b_cumul *_b[lnmem]
}

**********
*2e

scalar x1 = 24317.19
scalar x2 = 61.33
scalar x3 = 83.07
scalar x1x2 = -17.01
scalar x1x3 = -154.54
scalar x2x3 = 25.51
scalar x1y = 3430.89
scalar x2y = -100.92
scalar x3y = -82.35

matrix deno = (x1, x1x2, x1x3 \ x1x2, x2, x2x3 \ x1x3, x2x3, x3)
matrix b1_nume = (x1y, x2y, x3y \ x1x2, x2, x2x3 \ x1x3, x2x3, x3)
matrix b2_nume = (x1, x1x2, x1x3 \ x1y, x2y, x3y \ x1x3, x2x3, x3)
matrix b3_nume = (x1, x1x2, x1x3 \ x1x2, x2, x2x3 \ x1y, x2y, x3y)

di "coef on green = " det(b1_nume)/det(deno)
di "coef on nostalks = " det(b2_nume)/det(deno)
di "coef on disperse = " det(b3_nume)/det(deno)
