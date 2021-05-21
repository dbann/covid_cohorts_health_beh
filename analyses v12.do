*Analysis file for the following paper (Bann et al 2021, JECH)

*"Changes in the behavioural determinants of health during the coronavirus (COVID-19) pandemic: gender, socioeconomic and ethnic inequalities in 5 British cohort studies"
*David Bann, Aase Villadsen, Jane Maddock, Alun Hughes, George B. Ploubidis, Richard J. Silverwood / Praveetha Patalay
*Syntax created by David Bann, audited and amended by Aase Villadsen and Jane Maddock 
*This syntax creates the main table and figures in the above paper

*Requirements:
	//   1) you obtain data from the cohorts specified in the paper (UK Data Archive; for queries please see https://cls.ucl.ac.uk/contact/) 
	//   2) that you clean these variables (eg, you need to set n/a responses to missing; create variable names to match variables desribed in paper and named below)
	//   3) ensure you have specific packages - these can be installed using ssc install (eg, table1_mc)
	//   4) to plot the forestplots, additional files are created to help with labelling. Code to create these is shown at the end of this syntax file. 
	
*set version
version 16

*load cleaned dataset
use "$data/covid/cleaned.dta", clear

*obtain Ns to report in the paper
*Ns in each cohort (ranging from 1-5)
tab cohort

*Ns for all outcome measures
sum sleep_c pa_c alc_c  fveg_c

tab alloutcome //an indicator variable for all outcomes
tab cohort alloutcome

*correlations of outcomes - p denotes prior to pandemic, c denotes the 'during pandemic' measures obtained in surveys
foreach outcome in  sleep pa malc fveg {
spearman p`outcome' c`outcome'
}

*Table 1  //ssc install table1_mc
cap erase "$output/table 1.xlsx" 
table1_mc [fw=fweight], by(cohort) ///
vars( ///
sex bin %4.1f \ ///
fscb bin %4.1f \ ///
smedb bin %4.1f \ ///
pfmanb bin %4.1f \ ///
psleep contn %4.1f \ ///
csleep contn %4.1f \ ///
psleepb bin %4.1f \ ///
csleepb bin %4.1f \ ///
ppa contn %4.1f \ ///
cpa contn %4.1f \ ///
ppab bin %4.1f \ ///
cpab bin %4.1f \ ///
palcb bin %4.1f \ ///
calcb bin %4.1f \ ///
paclrisk bin %4.1f \ ///
caclrisk bin %4.1f \ ///
pfveg contn %4.1f \ ///
cfveg contn %4.1f \ ///
pfvegb bin %4.1f \ ///
cfvegb bin %4.1f \ ///
) ///
nospace percent  ///
saving("$output/table 1.xlsx", replace)

*Figure 1 (histograms)
foreach cohort in  1 2 3 4 5 { 
   local v : label (cohort) `cohort'
 
 *alcohol freq 
 twoway (histogram pmalc if !missing(palc, calc) & cohort==`cohort'  [fweight=fweight], discrete percent start(0)  width(1) color(red%50)) ///
       (histogram cmalc if !missing(palc, calc) & cohort==`cohort' [fweight=fweight], discrete percent start(0)  width(1) color(green%50)), ///
	      legend(rows(1) order(1 "Pre-lockdown" 2 "During Lockdown" ))  xtitle("")  ylabel(0(10)30) saving(alc`cohort', replace)  ///
		xla(0 "Highest" 1 "Moderate" 2 "Lowest" 3 "None" , labs(vsmall) noticks) title("`v'")  graphregion(color(white))
		
*sleep
twoway (histogram psleep if !missing(psleep, csleep ) & cohort==`cohort' [fweight=fweight], discrete percent start(0)  width(0.5) color(red%50)) ///
       (histogram csleep if !missing(psleep, csleep ) &cohort==`cohort' [fweight=fweight], discrete percent start(0)  width(0.5) color(green%50)), ///
	      legend(rows(1) order(1 "Pre-lockdown" 2 "During Lockdown" ))  xtitle("")  ylabel(0(10)30) saving(sleep`cohort', replace) ///
		       ylabel(0(10)30)    xla(1/13, valuelabel )  title("`v'")  graphregion(color(white))
*graph export "$output\bycohort\sleep_`cohort'.tif"   , replace width(900) 

*PA
twoway (histogram ppa if !missing(ppa, cpa) & cohort==`cohort' [fweight=fweight], discrete percent start(0)  width(0.5) color(red%50)) ///
       (histogram cpa if !missing(ppa, cpa) & cohort==`cohort' [fweight=fweight], discrete percent start(0)  width(0.5) color(green%50)), ///
	      legend(rows(1) order(1 "Pre-lockdown" 2 "During Lockdown" ))  xtitle("")  ylabel(0(10)30) saving(pa`cohort', replace) ///
		       ylabel(0(10)30)    xla(0/7, valuelabel )  title("`v'")  graphregion(color(white))
*graph export "$output\bycohort\pa_`cohort'.tif"   , replace width(900) 

*fveg
twoway (histogram pfveg if !missing(pfveg, cfveg) & cohort==`cohort' [fweight=fweight], discrete percent start(0)  width(0.5) color(red%50)) ///
       (histogram cfveg if !missing(pfveg, cfveg) & cohort==`cohort' [fweight=fweight], discrete percent start(0)  width(0.5) color(green%50)), ///
	      legend(rows(1) order(1 "Pre-lockdown" 2 "During Lockdown" ))  xtitle("")  ylabel(0(10)30) saving(fveg`cohort', replace) ///
		       ylabel(0(10)30)    xla(0/6, valuelabel )  title("`v'")  graphregion(color(white))
*graph export "$output\bycohort\fveg_`cohort'.tif"   , replace width(900) 

}

**combine graphs by cohort
grc1leg alc1.gph alc2.gph alc3.gph  alc4.gph alc5.gph, cols(2) ///
imargin(0 0 0 0) ycommon xcommon title("Alcohol consumption")  graphregion(color(white))
graph save "$output\fig_1_alc.gph"   , replace
graph export "$output\fig_1_alc.tif"   , replace width(900) 

grc1leg sleep1.gph sleep2.gph sleep3.gph sleep4.gph sleep5.gph, cols (2) ///
imargin(0 0 0 0) ycommon xcommon title("Hours of sleep/night")  graphregion(color(white))
graph save "$output\fig_1_sleep.gph"   , replace 
graph export "$output\fig_1_sleep.tif"   , replace width(900) 

grc1leg pa1.gph pa2.gph pa3.gph pa4.gph pa5.gph, cols (2) ///
imargin(0 0 0 0) ycommon xcommon title("Number of days 30mins exercise")  graphregion(color(white))
graph save "$output\fig_1_pa.gph"   , replace 
graph export "$output\fig_1_pa.tif"   , replace width(900) 

grc1leg fveg1.gph fveg2.gph fveg3.gph fveg4.gph fveg5.gph, cols (2) ///
imargin(0 0 0 0) ycommon xcommon title("Portions of fruit and veg/day")  graphregion(color(white))
graph save "$output\fig_1_fveg.gph"   , replace 
graph export "$output\fig_1_fveg.tif"   , replace width(900) 


graph combine "$output\fig_1_alc.gph" "$output\fig_1_sleep.gph" "$output\fig_1_pa.gph" "$output\fig_1_fveg.gph", iscale(.5)
graph export "$output\fig_1_compilled.tif"   , replace width(3000) 


*Figure 2  - forest plots 
*first output estimates and confidence intervals in csv files
*then subsequently import outputted files and plot as forestplots

foreach x in c p {

cap erase "$output\sex`x'.csv"

foreach outcome in  sleepb pab aclrisk fvegb {
*MCS
svyset SPTN00 [pweight=ws1_comb_wt], strata(PTTYPE2) fpc(NH2)
svy:  logit `x'`outcome'  i.sex if cohort==1 & !missing(`x'`outcome', p`outcome')  
eststo  margin1: margins, dydx(i.sex) post 

esttab   margin1 using "$output/sex`x'.csv", ///
cells("b ci_l ci_u") stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels(`outcome') collabels("") nocons  keep (1.sex) noobs  

*next steps 
svyset [pweight=ws1_comb_wt_final], psu(SampPSU) strata(SampStratum)
eststo	 : svy: logit `x'`outcome'  i.sex if cohort==2 & !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(i.sex) post

esttab   raw using "$output/sex`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(1.sex) noobs  

*70c
eststo	:  logit `x'`outcome'  i.sex [pw=weight]  if cohort==3& !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(i.sex) post
esttab   raw using "$output/sex`x'.csv", ///
cells("b ci_l ci_u") stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(1.sex) noobs  

*58c
eststo	 :  logit `x'`outcome'  i.sex [pw=weight] if cohort==4& !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(i.sex) post
esttab   raw using "$output/sex`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(1.sex) noobs  

*46c
eststo	 :  logit `x'`outcome'  i.sex [pw=weight]  if cohort==5& !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(i.sex) post
esttab   raw using "$output/sex`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(1.sex) noobs  
}
}

//use "$path/cleaned.dta", clear //aase
use "$data/covid/cleaned.dta", clear
estimates clear
cap erase "$output\smed_riditc.csv"
cap erase "$output\smed_riditp.csv"

*SEP

cap erase "$output\fsc_riditc.csv"
cap erase "$output\fsc_riditp.csv"
cap erase "$output\pfman_riditc.csv"
cap erase "$output\pfman_riditp.csv"

*fsc_ridit smed_ridit pfman_ridit 
foreach x in c p {
foreach sep in   fsc_ridit smed_ridit pfman_ridit {
foreach outcome in  sleepb pab aclrisk fvegb {
*MCS
svyset SPTN00 [pweight=ws1_comb_wt], strata(PTTYPE2) fpc(NH2)
eststo	 : svy: logit `x'`outcome'  i.sex `sep' if cohort==1& !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(`sep') post

esttab   raw using "$output/`sep'`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels(`outcome') collabels("") nocons keep(`sep') noobs  


*next steps 
svyset [pweight=ws1_comb_wt_final], psu(SampPSU) strata(SampStratum)
eststo	 : svy: logit `x'`outcome'  i.sex `sep' if cohort==2 & !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(`sep') post

esttab   raw using "$output/`sep'`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(`sep') noobs 

*70c
eststo	 :  logit `x'`outcome'  i.sex `sep' [pw=weight]  if cohort==3& !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(`sep') post

esttab  raw using "$output/`sep'`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(`sep') noobs  

*58c
eststo	 :  logit `x'`outcome'  i.sex `sep' [pw=weight] if cohort==4& !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(`sep') post

esttab   raw using "$output/`sep'`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(`sep') noobs  

*46c
eststo	 :  logit `x'`outcome'  i.sex `sep' [pw=weight]  if cohort==5& !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(`sep') post

esttab   raw using "$output/`sep'`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(`sep') noobs  
}
}
}

use "$data/covid/cleaned.dta", clear
estimates clear

cap erase "$output\ethc.csv"
cap erase "$output\ethp.csv"

*ethnic differences
foreach x in c p {
foreach outcome in  sleepb pab aclrisk fvegb {
*MCS
svyset SPTN00 [pweight=ws1_comb_wt], strata(PTTYPE2) fpc(NH2)
eststo	 : svy: logit `x'`outcome'  i.sex  i.eth if cohort==1& !missing(`x'`outcome', p`outcome'), or  

eststo  raw: margins, dydx(i.eth) post
esttab   raw using "$output/eth`x'.csv", ///
cells("b ci_l ci_u") stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels(`outcome') collabels("") nocons keep(1.eth) noobs  

*next steps 
svyset [pweight=ws1_comb_wt_final], psu(SampPSU) strata(SampStratum)
eststo	 : svy: logit `x'`outcome'  i.sex  i.eth if cohort==2 & !missing(`x'`outcome', p`outcome'), or  
eststo  raw: margins, dydx(i.eth) post

esttab   raw using "$output/eth`x'.csv", ///
cells("b ci_l ci_u")  stats() modelwidth(20) ///
plain nolabel nogaps varwidth (15) nolines  compress append   nolabel  ///
mlabels("") collabels("") nocons keep(1.eth) noobs  
}
}

*create forestpolots
**see end of file for syntax to create labels.dta - a file to aid figure labelling

foreach x in p c {
import delimited "$output/sex`x'.csv", colrange(2) clear 
gen id = _n

 merge  1:1 id using  "$output/labels.dta", force

 drop id
 drop _merge
drop if _USE==. 
rename (v1 v2 v3) (es lci uci)

label define v6 1 "Sleep, atypical (<6 or >9hrs)" 2 "Exercise, <3 days/week" 3 "Alcohol, high risk consumption" 4 "Fruit & veg, <3 portions/day", replace
  label values v6 v6
destring es lci uci, force replace

*express in percent terms
gen esp = es*100
gen lcip = lci*100
gen ucip = uci*100

metan esp lcip ucip, effect(% RD) nowt label(namevar=outcome) by(v6) nooverall null(0) xlabel(-20, 0 ,20)   force title("Gender" "males vs females (ref)", size(small) color(black)) boxsca(50) astext(60) graphregion(color(white)) favours(favours males # favours females) dp(1)

*prior
*graph export "$output\Figure_2_gender_`x'.tif"   , replace width(2000)
graph save "$output\Figure_2_gender_`x'.gph"   , replace 
}

graph combine "$output\Figure_2_gender_p.gph"   "$output\Figure_2_gender_c.gph" 
graph export "$output\fig2a_gender.tif"   , replace width(2000) 


*SES
foreach x in p c {
import delimited "$output/smed_ridit`x'.csv", colrange(2) clear 
gen id = _n

 merge  1:1 id using  "$output/labels.dta", force
 
 drop id
 drop _merge
drop if _USE==. 
rename (v1 v2 v3) (es lci uci)

label define v6 1 "Sleep, atypical (<6 or >9hrs)" 2 "Exercise, <3 days/week" 3 "Alcohol, high risk consumption" 4 "Fruit & veg, <3 portions/day", replace
  label values v6 v6
destring es lci uci, force replace
*express in percent terms
gen esp = es*100
gen lcip = lci*100
gen ucip = uci*100


metan esp lcip ucip, effect(% RD) nowt label(namevar=outcome) by(v6) nooverall null(0) xlabel(-20, 0 ,20, 40) force title("Highest education attainment" "lowest vs highest (ridit score)", size(small) color(black)) boxsca(50) astext(60) graphregion(color(white)) favours(favours lower # higher educated) dp(1)

*prior
*graph export "$output\Figure_2_education_`x'.tif"   , replace width(2000)
graph save "$output\Figure_2_education_`x'.gph"   , replace 
}

graph combine "$output\Figure_2_education_p.gph"  "$output\Figure_2_education_c.gph" 
graph export "$output\fig2b_education.tif"   , replace width(2000) 

*ethnicity
foreach x in p c {
import delimited "$output/eth`x'.csv", colrange(2) clear 
gen id = _n

 merge  1:1 id using  "$output/labels_eth.dta", force

 drop id
 drop _merge
drop if _USE==. 
rename (v1 v2 v3) (es lci uci)

label define v6 1 "Sleep, atypical (<6 or >9hrs)" 2 "Exercise, <3 days/week" 3 "Alcohol, high risk consumption" 4 "Fruit & veg, <3 portions/day", replace
  label values v6 v6
destring es lci uci, force replace
*express in percent terms
gen esp = es*100
gen lcip = lci*100
gen ucip = uci*100

metan esp lcip ucip, effect(% RD) nowt label(namevar=outcome) by(v6) nooverall null(0) xlabel(-20, 0 ,20, 40)  force title("Ethnicity" "Minority group vs White(ref)", size(small) color(black)) boxsca(70) astext(50)   graphregion(color(white)) favours(favours ethnic minority # white) dp(1)

*prior
*graph export "$output\Figure_2_ethnicity_`x'.tif"   , replace width(2000)
graph save "$output\Figure_2_ethnicity_`x'.gph"   , replace 

}

graph combine "$output\Figure_2_ethnicity_p.gph"  "$output\Figure_2_ethnicity_c.gph" , iscale(*.8)
graph export "$output\Fig2c_ethnicity.tif"   , replace width(2000) 

*father's social class
foreach x in p c {
import delimited "$output/fsc_ridit`x'.csv", colrange(2) clear 
gen id = _n

 merge  1:1 id using  "$output/labels.dta", force
 
 drop id
 drop _merge
drop if _USE==. 
rename (v1 v2 v3) (es lci uci)

label define v6 1 "Sleep, atypical (<6 or >9hrs)" 2 "Exercise, <3 days/week" 3 "Alcohol, high risk consumption" 4 "Fruit & veg, <3 portions/day", replace
  label values v6 v6
destring es lci uci, force replace
*express in percent terms
gen esp = es*100
gen lcip = lci*100
gen ucip = uci*100


metan esp lcip ucip, effect(% RD) nowt label(namevar=outcome) by(v6) nooverall null(0) xlabel(-20, 0 ,20, 40) force title("Childhood social class at 10-14y"  "lowest vs highest (ridit score)", size(small) color(black)) boxsca(50) astext(60) graphregion(color(white)) favours(favours higher# lower class) dp(1)

*prior
*graph export "$output\Figure_2_fathers_class_`x'.tif"   , replace width(2000)
graph save "$output\Figure_2_fathers_class_`x'.gph"   , replace 
}

graph combine "$output\Figure_2_fathers_class_p.gph"   "$output\Figure_2_fathers_class_c.gph" 
graph export "$output\Suppl_fig_fathers_class.tif"   , replace width(2000) 


*financial difficulties 
foreach x in p c {
import delimited "$output/pfman_ridit`x'.csv", colrange(2) clear 
gen id = _n

 merge  1:1 id using  "$output/labels.dta", force
 
 drop id
 drop _merge
drop if _USE==. 
rename (v1 v2 v3) (es lci uci)

label define v6 1 "Sleep, atypical (<6 or >9hrs)" 2 "Exercise, <3 days/week" 3 "Alcohol, high risk consumption" 4 "Fruit & veg, <3 portions/day", replace
  label values v6 v6
destring es lci uci, force replace
*express in percent terms
gen esp = es*100
gen lcip = lci*100
gen ucip = uci*100


metan esp lcip ucip, effect(% RD) nowt label(namevar=outcome) by(v6) nooverall null(0) xlabel(-20, 0 ,20, 40) force title("Financial difficulties before COVID-19" "most vs least difficulty (ridit score)", size(small) color(black)) boxsca(50) astext(60) graphregion(color(white)) favours(favours less # more financial difficulty) dp(1)

*prior
*graph export "$output\Figure_2_financial_diff_`x'.tif"   , replace width(2000)
graph save "$output\Figure_2_financial_diff_`x'.gph"   , replace 
}

graph combine "$output\Figure_2_financial_diff_p.gph"  "$output\Figure_2_financial_diff_c.gph" 
graph export "$output\Suppl_fig_financial_diff.tif"   , replace width(2000) 




*This section creates data files for the study labels (labels.dta)
*These are merged to the output files above to facilitate plotting

*/*
*make relevant files to enable automation of above plots
*
clear
input double _USE str30 outcome double v6
6 . .
0 "Sleep" . 
1 "2001c"  	1	
. . .
. . .
1 "1990c"  	1	
. . .
. . .
1 "1970c"  	1	
. . .
. . .
1 "1958c"  	1	
. . .
. . .
1 "1946c"  	1	
. . .
0 "Exercise" 2
1 "2001c"  	2
. . .
. . .
1 "1990c"  	2
. . .
. . .
1 "1970c"  	2
. . .
. . .
1 "1958c"  	2
. . .
. . .
1 "1946c"  	2
. . .
0 "Alcohol " 3
1 "2001c"  	3
. . .
. . .
1 "1990c"  	3
. . .
. . .
1 "1970c"  	3
. . .
. . .
1 "1958c"  	3
. . .
. . .
1 "1946c"  	3
. . .
0 "Fruit & veg " 4
1 "2001c"  	4
. . .
. . .
1 "1990c"  	4
. . .
. . .
1 "1970c"  	4
. . .
. . .
1 "1958c"  	4
. . .
. . .
1 "1946c"  	4
end
gen id = _n
save "$output/labels.dta", replace


*eth files
 use "$output/labels.dta", clear
 drop in 9/16

 drop in 16/23

 drop in 23/30

 drop in 30/36

drop in 14
drop in 20
drop in 8

 drop id
 gen id = _n
 save "$output/labels_eth.dta", replace
