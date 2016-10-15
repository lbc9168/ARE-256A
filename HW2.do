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

tsset Date
tsline GOOG_Y
graph twoway (scatter GOOG_Y GSPC_X)(lfit GOOG_Y GSPC_X)

regress GOOG_Y GSPC_X
rvfplot, yline(0)
