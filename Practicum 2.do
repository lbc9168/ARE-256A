***question 2
import excel waugh, firstrow

***question 2a
reg PRICE GREEN NOSTALKS DISPERSE

***question 2b
sum

***question 2c
correlate PRICE GREEN NOSTALKS DISPERSE
correlate PRICE GREEN NOSTALKS DISPERSE, covariance


***question 3
***question 3a
correlate PRICE GREEN NOSTALKS DISPERSE

***question 3b
reg PRICE GREEN
reg PRICE NOSTALKS
reg PRICE DISPERSE

reg GREEN PRICE
reg NOSTALKS PRICE
reg DISPERSE PRICE

***question 3c
reg PRICE GREEN NOSTALKS
reg PRICE NOSTALKS DISPERSE

***question 3e
correlate PRICE GREEN NOSTALKS DISPERSE, covariance
sum PRICE

display "d_price_green = " 0.1375982*(3448.18)/(29.4744^2)
display "d_price_nostalks = " -1.357256*(-93.3846)/(29.4744^2)
display "d_price_disperse = " -0.27554*(-87.4303)/(29.4744^2)

***question 3f
reg PRICE GREEN NOSTALKS DISPERSE
predict yhat
reg PRICE GREEN NOSTALKS DISPERSE yhat

***question4
***question 4a
import excel "CHOW", firstrow

gen MEM = WORDS*BINARY*DIGITS
gen lnrent = log(RENT)
gen lnmem = log(MEM)
gen lnmult = log(MULT)
gen lnaccess = log(ACCESS)

forvalues i = 54(1)65 {
	gen dum_`i' = 0
	replace dum_`i' = 1 if YEAR == `i'
	}

reg lnrent lnmem lnmult lnaccess if inrange(YEAR, 60, 65)
reg lnrent lnmem lnmult lnaccess i.YEAR#c.(lnmem lnmult lnaccess) /*
	*/if inrange(YEAR, 60, 65)

***question 4b
reg lnrent lnmem lnmult lnaccess if inrange(YEAR, 54, 59)
reg lnrent lnmem lnmult lnaccess i.YEAR#c.(lnmem lnmult lnaccess) /*
	*/if inrange(YEAR, 54, 59)

	
***question 4c
gen dum_gen1 = 1
replace dum_gen1 = 0 if inrange(YEAR, 54, 59)

reg lnrent lnmem lnmult lnaccess
reg lnrent lnmem lnmult lnaccess i.dum_gen1#c.(lnmem lnmult lnaccess) /*
	*/if inrange(YEAR, 54, 65)



***question 5a	
forvalues i = 54(1)64 {
	local j =`i' + 1
	reg lnrent lnmem lnmult lnaccess dum_`j' if inrange(YEAR, `i', `j')
	display "beta 19"`j' " = " _b[dum_`j']
	}
	
reg lnrent lnmem lnmult lnaccess i.YEAR
forvalues i = 55(1)65 {
	display "entire_beta 19"`i' " = " _b[`i'.YEAR]
	}
	
***question 5b
forvalues i = 55(1)65 {
	display "HPI_19"`i' " = " exp(_b[`i'.YEAR])
	}
	
local cpi_cache = 0
forvalues i = 55(1)65 {
	local cpi = `cpi_cache' + _b[`i'.YEAR]
	display "CPI_19"`i' " = " `cpi'
	local cpi_cache = `cpi'
	}
	