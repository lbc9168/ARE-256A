**Question 2
import excel "Total", firstrow
gen risk_free = IRX/90

gen APPL_Y = APPL_r - risk_free
gen GOOG_Y = GOOG_r - risk_free
gen PEP_Y = PEP_r - risk_free
gen GIS_Y = GIS_r - risk_free

gen GSPC_X = GSPC_r - risk_free

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
clear

import excel "XON_monthly", firstrow
gen month = month(Date)
gen DUMJ = 0
replace DUMJ = 1 if month == 1
regress AdjClose DUMJ
clear

import excel "PEP_monthly", firstrow
gen month = month(Date)
gen DUMJ = 0
replace DUMJ = 1 if month == 1
regress AdjClose DUMJ
clear

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

gen risk_free = IRX_AdjClose/90
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

*mean return
drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' VLKAY_`i'
	}

save VLKAY, replace
clear

import excel "GSPC", firstrow
drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' GSPC_`i'
	}

merge 1:1 Date using VLKAY
drop _merge

gen market_return = (GSPC_Close - GSPC_Close[_n-1])/(GSPC_Close[_n-1])
gen vw_return = (VLKAY_Close - VLKAY_Close[_n-1])/(VLKAY_Close[_n-1])
gen event = 0
replace event = 1 if Date == 20349

reg vw_return if inrange(Date, 20254, 20346)
predict abnormal_returns1, residuals

*abnormal returns during the event window
twoway(line abnormal_returns1 Date) if inrange(Date, 20349, 20356)

egen CAR_1 = total(abnormal_returns1) if inrange(Date, 20349, 20356)
twoway(line CAR_1 Date) if inrange(Date, 20349, 20356) 
list CAR_1 if inrange(Date, 20349, 20356)

sum abnormal_returns1 if inrange(Date, 20349, 20356)

***question b

*market model
reg vw_return market_return if inrange(Date, 20254, 20346)
predict abnormal_returns2, residuals
twoway(line abnormal_returns2 Date, xline(20349)) if inrange(Date, 20349, 20356)

egen CAR_2 = total(abnormal_returns2) if inrange(Date, 20349, 20356)
twoway(line CAR_2 Date) if inrange(Date, 20349, 20356)
list CAR_2 if inrange(Date, 20349, 20356)

sum abnormal_returns2 if inrange(Date, 20349, 20356)


***question c 
reg vw_return market_return if inrange(Date, 20542, 20632)
predict abnormal_returns3, residuals
twoway(line abnormal_returns3 Date, xline(20633)) if inrange(Date, 20633, 20640)

egen CAR_3 = total(abnormal_returns3) if inrange(Date, 20633, 20640)
twoway(line CAR_3 Date) if inrange(Date, 20633, 20640)
list CAR_3 if inrange(Date, 20633, 20640)

sum abnormal_returns2 if inrange(Date, 20633, 20640)


***question d
clear
*GM
*data prepare
import excel "GM", firstrow

drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' GM_`i'
	}

save GM, replace
clear

import excel "GSPC", firstrow
drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' GSPC_`i'
	}

merge 1:1 Date using GM
drop _merge

gen market_return = (GSPC_Close - GSPC_Close[_n-1])/(GSPC_Close[_n-1])
gen gm_return = (GM_Close - GM_Close[_n-1])/(GM_Close[_n-1])

*market model
reg gm_return market_return if inrange(Date, 20254, 20346)
predict abnormal_returns2, residuals
twoway(line abnormal_returns2 Date, xline(20349)) if inrange(Date, 20349, 20356)

egen CAR_2 = total(abnormal_returns2) if inrange(Date, 20349, 20356)
twoway(line CAR_2 Date) if inrange(Date, 20349, 20356)
list CAR_2 if inrange(Date, 20349, 20356)

sum abnormal_returns2 if inrange(Date, 20349, 20356)

*FORD
*data prepare
clear
import excel "FORD", firstrow

drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' FORD_`i'
	}

save FORD, replace
clear

import excel "GSPC", firstrow
drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' GSPC_`i'
	}

merge 1:1 Date using FORD
drop _merge

gen market_return = (GSPC_Close - GSPC_Close[_n-1])/(GSPC_Close[_n-1])
gen ford_return = (FORD_Close - FORD_Close[_n-1])/(FORD_Close[_n-1])

*market model
reg ford_return market_return if inrange(Date, 20254, 20346)
predict abnormal_returns2, residuals
twoway(line abnormal_returns2 Date, xline(20349)) if inrange(Date, 20349, 20356)

egen CAR_2 = total(abnormal_returns2) if inrange(Date, 20349, 20356)
twoway(line CAR_2 Date) if inrange(Date, 20349, 20356)
list CAR_2 if inrange(Date, 20349, 20356)

sum abnormal_returns2 if inrange(Date, 20349, 20356)


*HMC
*data prepare
clear
import excel "HMC", firstrow

drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' HMC_`i'
	}

save HMC, replace
clear

import excel "GSPC", firstrow
drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' GSPC_`i'
	}

merge 1:1 Date using HMC
drop _merge

gen market_return = (GSPC_Close - GSPC_Close[_n-1])/(GSPC_Close[_n-1])
gen hmc_return = (HMC_Close - HMC_Close[_n-1])/(HMC_Close[_n-1])

*market model
reg hmc_return market_return if inrange(Date, 20254, 20346)
predict abnormal_returns2, residuals
twoway(line abnormal_returns2 Date, xline(20349)) if inrange(Date, 20349, 20356)

egen CAR_2 = total(abnormal_returns2) if inrange(Date, 20349, 20356)
twoway(line CAR_2 Date) if inrange(Date, 20349, 20356)
list CAR_2 if inrange(Date, 20349, 20356)

sum abnormal_returns2 if inrange(Date, 20349, 20356)



*TM
*data prepare
clear
import excel "TM", firstrow

drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' TM_`i'
	}

save TM, replace
clear

import excel "GSPC", firstrow
drop Open High Low Volume
foreach i in Close AdjClose{
	rename `i' GSPC_`i'
	}

merge 1:1 Date using TM
drop _merge

gen market_return = (GSPC_Close - GSPC_Close[_n-1])/(GSPC_Close[_n-1])
gen tm_return = (TM_Close - TM_Close[_n-1])/(TM_Close[_n-1])

*market model
reg tm_return market_return if inrange(Date, 20254, 20346)
predict abnormal_returns2, residuals
twoway(line abnormal_returns2 Date, xline(20349)) if inrange(Date, 20349, 20356)

egen CAR_2 = total(abnormal_returns2) if inrange(Date, 20349, 20356)
twoway(line CAR_2 Date) if inrange(Date, 20349, 20356)
list CAR_2 if inrange(Date, 20349, 20356)

sum abnormal_returns2 if inrange(Date, 20349, 20356)
