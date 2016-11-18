***Question 2
**question a
import excel nerlov, firstrow

gen LNCP3 = log(COSTS/PF)
gen LNP13 = log(PL/PF)
gen LNP23 = log(PK/PF)
gen LNKWH = log(KWH)

list LNKWH

**question b
reg LNCP3 LNKWH LNP13 LNP23

**question e
rvpplot LNKWH
predict Resid, residuals
cor Resid LNKWH


***Question 3
**question a
forvalues i = 1(1)5 {
	local x = `i'*100 + 1
	local y = `i'*100 + 29
	reg LNCP3 LNKWH LNP13 LNP23 if inrange(ORDER,`x',`y')
	}


**question c
gen Group = int(ORDER/100)
reg LNCP3 LNKWH LNP13 LNP23 i.Group i.Group#c.(LNKWH)
	
**question e
reg LNCP3 LNKWH LNP13 LNP23 i.Group i.Group#c.(LNKWH LNP13 LNP23)

**question f
gen LNKWH2 = (LNKWH)^2
reg LNCP3 LNKWH LNKWH2 LNP13 LNP23
test (LNKWH = 1) (LNKWH2 = 0) 

*calculating range
reg LNCP3 LNKWH LNKWH2 LNP13 LNP23
forvalues i = 1(1)5 {
	local a = (`i'-1)*29 + 1
	local b = `i'*29
	local c = (`a' + `b')/2
	
	local betay = _b[LNKWH]
	local betayy = _b[LNKWH2]
	local small = 1/(`betay' + `betayy'*2*LNKWH[`b'])
	local large = 1/(`betay' + `betayy'*2*LNKWH[`a'])
	local median = 1/(`betay' + `betayy'*2*LNKWH[`c'])
	
	display "range of group " `i' " = [" `small' ", " `large' "]"
	display "range of group median " `i' " = [" `median' "]"
	}
	

	
***Question 4
import excel update, firstrow
**question a
gen LNC70 = log(COST70/PF70)
gen LNY70 = log(KWH70)
gen LNP170 = log(PL70/PF70)
gen LNP270 = log(PK70/PF70)

sum KWH70

**question b
reg LNC70 LNY70 LNP170 LNP270

**question c
gen LNY702 = (LNY70)^2
reg LNC70 LNY70 LNY702 LNP170 LNP270
test (LNY70 = 1) (LNY702 = 0) 

**question d
forvalues i = 1(1)5 {
	local a = (`i'-1)*20 + 1
	
	if inrange(`i',1,4){
		local b = `i'*20
		local c = (`a' + `b' + 1)/2
	else
		local b = `i'*20-1
		local c = (`a' + `b')/2
		}
	local betay = _b[LNY70]
	local betayy = _b[LNY702]
	local small = 1/(`betay' + `betayy'*2*LNY70[`b'])
	local large = 1/(`betay' + `betayy'*2*LNY70[`a'])
	local median = 1/(`betay' + `betayy'*2*LNY70[`c']) 
	
	display "range of group " `i' " = [" `small' ", " `large' "]"
	display "range of group median " `i' " = [" `median' "]"

	}






