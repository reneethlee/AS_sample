
global pol "SO2 PM2.5 PM10 CO O3 NO NO2 NOx"
global avg " log_avg log_max avg max "

foreach avg of global avg{
foreach pol of global pol{
use "D:\User_Data\Desktop\poll\\`pol'\\`avg'\\`avg'_`pol'_2003-2016.dta"
drop date var1stdev
gen date = date(D, "YMD")
drop D
drop if date < 16344

qui bysort date: egen sd = sd(var1pred)
drop if sd == 0
drop sd
qui merge m:1 x y using "D:\User_Data\Desktop\poll\tw_grid_1km_Shenao_minimize.dta", nogen keep(match)
qui drop if town==""

gen D1 = 0
replace D1 = 1 if date>=17439

tw (lpoly var1pred date if sd!=0 & T90==0 & date<17439, lcolor(red) lpattern(dash) lwidth(thick))(lpoly var1pred date if sd!=0 & T90==0 & date>=17439, lcolor(red) lpattern(dash) lwidth(thick))(lpoly var1pred date if sd!=0 & T90==1 & date<17439, lcolor(blue) lpattern(solid) lwidth(thick))(lpoly var1pred date if sd!=0 & T90==1 & date>=17439, lcolor(blue) lpattern(solid) lwidth(thick)), ///
title("`pol'_`avg'") ///
ytitle("`pol'") xtitle("TIME") ///
legend(label(1 "T=0") label(2 "T=0") label(3 "T=1") label(4 "T=1"))

graph export "D:\User_Data\Desktop\poll\graph_T\\`avg'\\`pol'_90.png", as(png) replace


tw (lpoly var1pred date if sd!=0 & T60==0 & date<17439, lcolor(red) lpattern(dash) lwidth(thick))(lpoly var1pred date if sd!=0 & T60==0 & date>=17439, lcolor(red) lpattern(dash) lwidth(thick))(lpoly var1pred date if sd!=0 & T60==1 & date<17439, lcolor(blue) lpattern(solid) lwidth(thick))(lpoly var1pred date if sd!=0 & T60==1 & date>=17439, lcolor(blue) lpattern(solid) lwidth(thick)), ///
title("`pol'_`avg'") ///
ytitle("`pol'") xtitle("TIME") ///
legend(label(1 "T=0") label(2 "T=0") label(3 "T=1") label(4 "T=1"))

graph export "D:\User_Data\Desktop\poll\graph_T\\`avg'\\`pol'_60.png", as(png) replace


tw (lpoly var1pred date if sd!=0 & T90C==0 & date<17439, lcolor(red) lpattern(dash) lwidth(thick))(lpoly var1pred date if sd!=0 & T90C==0 & date>=17439, lcolor(red) lpattern(dash) lwidth(thick))(lpoly var1pred date if sd!=0 & T90C==1 & date<17439, lcolor(blue) lpattern(solid) lwidth(thick))(lpoly var1pred date if sd!=0 & T90C==1 & date>=17439, lcolor(blue) lpattern(solid) lwidth(thick)), ///
title("`pol'_`avg'") ///
ytitle("`pol'") xtitle("TIME") ///
legend(label(1 "T=0") label(2 "T=0") label(3 "T=1") label(4 "T=1"))

graph export "D:\User_Data\Desktop\poll\graph_T\\`avg'\\`pol'_90C.png", as(png) replace


tw (lpoly var1pred date if sd!=0 & T60C==0 & date<17439, lcolor(red) lpattern(dash) lwidth(thick))(lpoly var1pred date if sd!=0 & T60C==0 & date>=17439, lcolor(red) lpattern(dash) lwidth(thick))(lpoly var1pred date if sd!=0 & T60C==1 & date<17439, lcolor(blue) lpattern(solid) lwidth(thick))(lpoly var1pred date if sd!=0 & T60C==1 & date>=17439, lcolor(blue) lpattern(solid) lwidth(thick)), ///
title("`pol'_`avg'") ///
ytitle("`pol'") xtitle("TIME") ///
legend(label(1 "T=0") label(2 "T=0") label(3 "T=1") label(4 "T=1"))

graph export "D:\User_Data\Desktop\poll\graph_T\\`avg'\\`pol'_60C.png", as(png) replace

clear
}
}
