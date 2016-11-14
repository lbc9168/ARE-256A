***DISCUSSION 7

***THIS DO FILE USES DATA ON NATIVE AND IMMIGRANT AGRICULTURAL WORKERS TO 
***ESTIMATE THE EFFECTS OF IMMIGRATION ON NATIVE EMPLOYMENT LEVELS
***BY ZACH RUTLEDGE

***SET THE WORKING DIRECTORY
*cd "F:\FINAL RESEARCH FILES FOR SUMMER\VARIABLE DATA SETS"

***LOAD THE FIRST DATA SET
use "FRACTION_IMMIGRANTS_AGRICULTURE_ALL.dta", clear

***LOOK AT THE DATA SET.  WHAT IS METAREA?
browse

***MERGE DATA SET WITH DATA ON NARIVE WORKERS
merge 1:1 metarea year using NATIVE_SHARE_FULL_TIME_AG_ALL
drop _merge

***MERGE DATA SET THAT CONTAINS THE INSTRUMENTAL VARIABLE
merge 1:1 metarea year using IMMIGRANT_SHARE_FULL_SAMPLE

***LET'S ANALYZE THE MERGED DATA
tab _merge
tab year if  _merge==2
tab metarea if _merge==2
drop if _merge==2
drop _merge

***MERGE DATA SET THAT CONTAINS DATA ON FARMERS ONLY
merge 1:1 metarea year using NATIVE_SHARE_FULL_TIME_AG_ONLY_FARMERS

***LET'S LOOK AT THE DATA
sum imm_share_ag_all, d
sum share_full_time_ag_all, d
sum immigrant_share_full_sample, d

***RUN OLS REGRESSIONS
reg share_full_time_ag_all imm_share_ag_all
reg share_full_time_ag_farmers imm_share_ag_all

reg share_full_time_ag_all imm_share_ag_all i.year
reg share_full_time_ag_farmers imm_share_ag_all i.year

reg share_full_time_ag_all imm_share_ag_all i.year, robust
reg share_full_time_ag_farmers imm_share_ag_all i.year, robust

***RUN INSTRUMENTAL VARIABLE MODELS
***USE HETEROSKEDASTICALLY ROBUST STANDARD ERRORS (i.e. ,robust)
ivregress 2sls share_full_time_ag_all i.year (imm_share_ag_all = immigrant_share_full_sample), robust first

***USE CLUSTERED STANDARD ERRORS AT THE CITY LEVEL [i.e. cluster(metarea)]
ivregress 2sls share_full_time_ag_all i.year (imm_share_ag_all = immigrant_share_full_sample), cluster(metarea) first

***RUN AN OLS REGRESSION
reg share_full_time_ag_all imm_share_ag_all i.year, robust

***FIND THE MARGINAL EFFECTS USING THE MARGINS COMMAND
margins, dydx(imm_share_ag_all) at(imm_share_ag_all=(.1(.025).3))

***RUN AN OLS REGRESSION WITH AN INTERACTION TERM
reg share_full_time_ag_all imm_share_ag_all c.imm_share_ag_all#c.imm_share_ag_all i.year, robust

***FIND THE MARGINAL EFFECTS USING THE MARGINS COMMAND
margins, dydx(imm_share_ag_all) at(imm_share_ag_all=(.1(.025).3))

***BACK TO THE FIRST REGRESSION
reg share_full_time_ag_all imm_share_ag_all i.year, robust

***THE LINCOM COMMAND ALLOWS US TO EVALUATE LINEAR COMNINATIONS OF
***THE REGRESSION COEFFICIENTS [NOTE: IT ALLOWS US TO EVALUATE THE
***REGRESSION EQUATION AT SPECIFIC VALUES OF THE VARIABLES]
lincom _cons + .2*imm_share_ag_all
lincom _cons + .3*imm_share_ag_all
lincom _cons + .4*imm_share_ag_all

***LET'S LOOK AT WHAT WILL HAPPEN TO FULL TIME WORKERS 
***WHEN THE IMMIGRANT SHARE OF THE AG WORKFORCE CHANGES
***FROM .1 TO .25 USING "LINCOM"
lincom (_cons + .25*imm_share_ag_all) - (_cons + .1*imm_share_ag_all)


***RUN SOME PANEL DATA MODLES
set matsize 800
xtset metarea year
xtreg share_full_time_ag_all imm_share_ag_all
xtivreg share_full_time_ag_all i.year (imm_share_ag_all_no_farmers = immigrant_share_industry_10), fe vce(cluster metarea) first
xtivreg share_full_time_ag_all i.year (imm_share_ag_all_no_farmers = immigrant_share_industry_5), fe vce(cluster metarea) first
