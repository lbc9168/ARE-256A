***DO FILE FOR 256 A***
***DISCUSSION 2***
***PROBLEMS 1 AND 2***


********************************************************************************
****************************MONTE CARLO EXPERIMENTS*****************************
********************************************************************************



********************************************************************************
*****************************UNIFORM RANDOM VARIABLE****************************
********************************************************************************

***Clear data in stata
clear

***Look for help regarding how to generate a uniform random variable
help runiform

***1.1 Draw a uniform random variable
set seed 10101
set obs 1
gen l = runiform()

***1.2 Draw 10 uniform random variables
***Set the number of observations in Stata to N=10
set obs 10

***(i.e. draw 10 observations from the Uniform Distribution)***
gen m=runiform()

***1.3 Summarize the outcome
summarize m

***1.4 Make a histogram
histogram m
histogram m, addplot (kdensity m)

***1.5 Repeat this for N=100
set obs 100
gen n = runiform()
sum n
histogram n
histogram n, addplot (kdensity n)

***1.5 Repeat this for N=1000
set obs 1000
gen o = runiform()
sum o
histogram o
histogram o, addplot (kdensity o)

********************************************************************************
***************************NORMAL RANDOM VARIALBES******************************
********************************************************************************

***1.6 Draw 1000 random variables with mean 2 and standard deviation 3
***(i.e. draw 1000 observations from a normal(2, 3)
help rnormal
gen p = rnormal(2,3)
sum p
hist p
histogram p, addplot (kdensity p)

********************************************************************************
**************************CENTRAL LIMIT THEOREM*********************************
********************************************************************************



***Write a program that generates 30 observations from a uniform distribution
***and computes the mean of that sample
program onesample, rclass
drop _all
quietly set obs 30
gen x= runiform(0,1)
summarize x
return scalar meanofonesample= r(mean)
end

***Run the program 1 time
onesample

***Look at the details of the scalar "meanofonesample"
return list

***Run the program 1000 times, and save the results each time
simulate mean=r(meanofonesample), reps(1000) saving(sample, replace) nodots :onesample

***Summarize the variable mean 
***(which is a summary the 1000 observations of "meanofonesample""
sum mean
hist mean
hist mean, addplot (kdensity mean)
