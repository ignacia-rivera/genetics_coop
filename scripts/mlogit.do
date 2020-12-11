
clear

*Data import (set your own working directory) 

use "C:\Users\Ignacia Rivera\Box Sync\Ignacia (m_i_rivera@ucsb.edu)\GitHub\genetics_coop\data\DB_Classificated.dta"

*Changing variables from string to number

encode type_10_001, gen (type_10)
encode type_20_001, gen (type_20)
encode type_30_001, gen (type_30)
encode gender, gen(ngender)
encode oxtr, gen(noxtr)
encode avpr1_341, gen(navpr1)
encode maoa, gen(nmaoa)
encode gender, gen(sex)

*Missing values

replace noxtr = . if noxtr == 4
replace navpr1 = . if navpr1 == 2
*Heterozygous women cannot be classfied as high or low expression 
replace nmaoa = . if nmaoa == 4| nmaoa == 2 

*Multinomial logit for each polymorphism by sex

local s = 1


foreach gen in noxtr navpr1 nmaoa {
                       foreach sex in 1 2 {                                               
                                 quietly: mlogit type_20 i.`gen' if ngender == `sex', baseoutcome(1) vce(bootstrap) nolstretch nolog
                                 
                              if (e(p) != .) {
                                
                                if `sex' == 1 display _newline(2) "GENDER: Female   GENE: `gen'"
                                if `sex' == 2  display _newline(2) "GENDER: Male     GENE: `gen'"                 
                                        
                                       margins, dydx(*) predict(outcome(1))
                                         display _newline
                                        margins, dydx(*) predict(outcome(2))
                                         display _newline
                                        margins, dydx(*) predict(outcome(3))
                                         display _newline
                                         margins, dydx(*) predict(outcome(4))
                                         
            display _newline(1) "======================================================================"
                                 }
                                 
                         }
                 }

