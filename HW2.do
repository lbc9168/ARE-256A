**Question 2
import excel "Total", firstrow

gen APPL_Y = APPL_r - IRX_r
gen GOOG_Y = GOOG_r - IRX_r
gen PEP_Y = PEP_r - IRX_r
gen GIS_Y = GIS_r - IRX_r

gen GSPC_X = GSPC_r - IRX_r

regress APPL_Y GSPC_X
regress GOOG_Y GSPC_X
regress PEP_Y GSPC_X
regress GIS_Y GSPC_X

***Draw graphs
tsset Date
tsline GOOG_Y
graph twoway (scatter GOOG_Y GSPC_X)(lfit GOOG_Y GSPC_X)

regress GOOG_Y GSPC_X
rvfplot, yline(0)

clear

**Question 3
***Question c create dummy variables
import excel "GOOG_monthly", firstrow
gen month = month(Date)
gen DUMJ = 0
replace DUMJ = 1 if month == 1
regress AdjClose DUMJ

import excel "XON_monthly", firstrow
gen month = month(Date)
gen DUMJ = 0
replace DUMJ = 1 if month == 1
regress AdjClose DUMJ

import excel "PEP_monthly", firstrow
gen month = month(Date)
gen DUMJ = 0
replace DUMJ = 1 if month == 1
regress AdjClose DUMJ

***Question d under CAPM framework
import excel "GOOG_monthly", firstrow
drop Open High Low Close Volume
foreach i in AdjClose{
	rename `i' GOOG_`i'
	}
save GOOG_monthly, replace
clear

import excel "XON_monthly", firstrow
drop Open High Low Close Volume
foreach i in AdjClose{
	rename `i' XON_`i'
	}
save XON_monthly, replace
clear

import excel "PEP_monthly", firstrow
drop Open High Low Close Volume
foreach i in AdjClose{
	rename `i' PEP_`i'
	}
save PEP_monthly, replace
clear

import excel "IRX_monthly", firstrow
drop Open High Low Close Volume
foreach i in AdjClose{
	rename `i' IRX_`i'
	}
save IRX_monthly, replace
clear

import excel "GSPC_monthly", firstrow
drop Open High Low Close Volume
foreach i in AdjClose{
	rename `i' GSPC_`i'
	}
save GSPC_monthly, replace

merge 1:1 Date using GOOG_monthly
drop _merge
merge 1:1 Date using XON_monthly
drop _merge
merge 1:1 Date using PEP_monthly
drop _merge
merge 1:1 Date using IRX_monthly
drop _merge

drop if year(Date)<1970

gen risk_free = IRX_AdjClose-IRX_AdjClose[_n-1]
gen market_return = (GSPC_AdjClose-GSPC_AdjClose[_n-1])/(GSPC_AdjClose[_n-1])

gen GOOG_return = (GOOG_AdjClose-GOOG_AdjClose[_n-1])/(GOOG_AdjClose[_n-1])
gen XON_return = (XON_AdjClose-XON_AdjClose[_n-1])/(XON_AdjClose[_n-1])
gen PEP_return = (PEP_AdjClose-PEP_AdjClose[_n-1])/(PEP_AdjClose[_n-1])

*generate y variable
gen GOOG_risk_premium = GOOG_return - risk_free
gen XON_risk_premium = XON_return - risk_free
gen PEP_risk_premium = PEP_return - risk_free

*generate x variables
gen market_risk_premium = market_return - risk_free
gen month = month(Date)
gen DUMJ = 0
replace DUMJ = 1 if month == 1

reg GOOG_risk_premium market_risk_premium DUMJ
reg XON_risk_premium market_risk_premium DUMJ
reg PEP_risk_premium market_risk_premium DUMJ


**Question 4
***Question a
import excel "VLKAY", firstrow
gen N_date = dofd(Date)
twoway(line Close Date, xline(20349)) if inrange(Date, 20257, 20363)








