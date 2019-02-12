/* Alicia Mergenthaler
Loading, cleaning data, creating dummy variables for
analysis
*/
import delimited "/Users/Alicia/Desktop/Inflection Slide
Deck and Work/interviewSamp.csv"
*summarize data
summarize
*Dummy Variables for Gender
gen female=0
replace female=1 if gender=="Female"
*Variables for Product Types
gen reportA=0
gen reportB=0
gen reportC=0
gen subscriptionX=0
gen subscriptionY=0
gen subscriptionZ=0
replace reportA=1 if product=="reportA"
replace reportB=1 if product=="reportB"
replace reportC=1 if product=="reportC"
replace subscriptionX=1 if product=="subscriptionX"
replace subscriptionY=1 if product=="subscriptionY"
replace subscriptionZ=1 if product=="subscriptionZ"
*Separate Ages into groups
gen age1 = inrange(age,20,30)
gen age2= inrange(age,30,40)
gen age3 = inrange(age,40,50)
gen age4 = inrange(age,50,60)
*Exploratory graph of paying customers by age
graph pie age1 age2 age3 age4 if isnetsale==1
*Looking for outliers and missing values
tab daysaftersignup
*Destring DaysAfterSignup
destring daysaftersignup, gen(newdaysaftersignup) ignore(,
N/A ) force
*Exploratory plot
ssc install catplot
catplot isnetsale newdaysaftersignup
*Regress days after signup on netsale, ignoring the missing
values
probit isnetsale newdaysaftersignup

**Analysis of Card types
gen visa=1 if cardtype=="Visa"
gen masterCard=1 if cardtype=="Mastercard"
gen americanexpress=1 if cardtype=="American Express"
gen paypal=1 if cardtype=="PayPal"
gen discover=1 if cardtype=="Discover"
gen clickbank=1 if cardtype=="ClickBank"
**Online Payment Sources vs. Credit Cards
gen onlinepayment=0
replace onlinepayment=1 if
cardtype=="ClickBank"|cardtype=="PayPal"
**Mac vs. Windows
gen Mac=0
gen Mac=1 if system=="Mac"
**Analysis of marketing channels (organic baseline)
gen advertising=0
replace advertising=1 if channelname=="Advertising"
gen partners=0
replace partners=1 if channelname=="Partners"
gen SEM= 0
replace SEM=1 if channelname=="SEM"
save InterviewSamp.dta, replace
***********************************************************
********************
******Investigating Trends*****
*Age groups and likelihood of purchase
probit isnetsale age1
probit isnetsale age2
probit isnetsale age3
probit isnetsale age4
probit isnetsale age5
*Which marketing channel is most likely to cause a sale?
probit isnetsale advertising partners SEM
*Mac vs. PC users?
probit isnetsale mac
*People that pay online?
probit isnetsale onlinepayment
*Investigating possible trends in subscription
probit isnetsale newdaysaftersignup
*Region?
tab region
tab region if isnetsale==1
gen west=0
replace west=1 if region=="West"
gen east=0
replace east=1 if region=="East"
gen south=0
replace south=1 if region=="South"
gen midwest=0
replace midwest=1 if region=="Midwest"
probit isnetsale west
*Subscription and Premium Services
**Organic baseline
probit isnetsale ispremium issubscription
*Which products are customers buying?
tab product
tab product if isnetsale==1
probit isnetsale reportA reportB reportC subscriptionX
tab price if reportA==1
tab price if reportB==1
tab price if reportC==1
tab price if subscriptionX==1
tab price if subscriptionY==1
tab price if subscriptionZ==1
*When are typical purchase times after signing up?
gen subscription1=0
gen subscription2=0
gen subscription3=0
gen subscription4=0
gen subscription5=0
replace subscription1 = inrange(newdaysaftersignup,0,20)
replace subscription2= inrange(newdaysaftersignup,20,40)
replace subscription3 = inrange(newdaysaftersignup,40,60)
replace subscription4 = inrange(newdaysaftersignup,60,80)
replace subscription5 = inrange(newdaysaftersignup,80,100)
graph pie subscription1 subscription2 subscription3
subscription4 subscription5 if isnetsale==1
probit isnetsale subscription1
/*** End of .do file