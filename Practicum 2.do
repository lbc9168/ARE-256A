import excel waugh, firstrow

***question 2a
reg PRICE GREEN NOSTALKS DISPERSE

***question 2b
sum

***question 2c
correlate PRICE GREEN NOSTALKS DISPERSE
correlate PRICE GREEN NOSTALKS DISPERSE, covariance


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

***question 3d
egen price_bar = mean(PRICE)
egen green_bar = mean(GREEN)
egen nostalks_bar = mean(NOSTALKS)
egen disperse_bar = mean(DISPERSE)

foreach i in GREEN{
	gen green_sub = GREEN - green_bar
	}

foreach i in PRICE{
	gen price_sub = PRICE - price_bar
	}

foreach i in NOSTALKS{
	gen nostalks_sub = NOSTALKS - nostalks_bar
	}

foreach i in DISPERSE{
	gen disperse_sub = DISPERSE - disperse_bar
	}

gen green_cov = green_sub*price_sub
gen nost_cov = nostalks_sub*price_sub
gen disp_cov = disperse_sub*price_sub

reg PRICE GREEN NOSTALKS DISPERSE

scalar d_nos = _b[NOSTALKS]
display (sum(nost_cov)/(sum(price_sub)^2))
display d_nos



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
reg lnrent i.YEAR##c.(lnmem lnmult lnaccess) if inrange(YEAR, 60, 65)

***question 4b
reg lnrent lnmem lnmult lnaccess if inrange(YEAR, 54, 59)
reg lnrent i.YEAR##c.(lnmem lnmult lnaccess) if inrange(YEAR, 54, 59)

***question 4c
gen dum_gen1 = 1
replace dum_gen1 = 0 if inrange(YEAR, 54, 59)

reg lnrent lnmem lnmult lnaccess
reg lnrent i.dum_gen1##c.(lnmem lnmult lnaccess) if inrange(YEAR, 54, 65)



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
	