*David Crawford 2016;
/*st106d02.sas*/
/*Part A*/
%let homefolder=PATH_TO_OUTPUT;

proc plm restore=STAT1.amesstore;
	score data=stat1.ameshousing4 out=scored;
	code file="&homefolder\scoring.sas";
run;

/*scoring.sas is sas code that can be
used within a data step*/

/* using a %include pastes the code in*/
data scored2;
	set STAT1.ameshousing4;

	%include "&homefolder\scoring.sas";
run;

proc compare base=scored compare=scored2 criterion=0.0001;
	var Predicted;
	with P_SalePrice;
run;

proc glmselect data=STAT1.ameshousing3 noprint;
	class &categorical / param=glm ref=first;
	model SalePrice=&categorical &interval / 
		selection=backward
		select=sbc 
		choose=validate;
	partition fraction (validate=.3333);
	score data=stat1.ameshousing4 out=score1;
	store out=store1;
	title "Selecting the Best Model using Honest Assessment";
run;

proc plm restore=store1;
	score data=stat1.ameshousing4 out=score2;
	code file="&homefolder\scoring.sas";
run;

proc compare base=scored compare=scored2 criterion=0.0001;
	var Predicted;
	with P_SalePrice;