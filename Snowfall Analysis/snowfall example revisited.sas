/* Look at Grand Rapids Snowfall Data */
options validvarname=v7;
ods proctitle=off;
ods graphics on/imagemap=on width=7in height=4in;
title "Grand Rapids Snowfall Data ";

/*read in data*/
PROC IMPORT OUT= WORK.GRSNOW 
	DATAFILE= "PATH_TO_CSV" 
	DBMS=CSV REPLACE;
	guessingrows=2;
	GETNAMES=YES;
	DATAROW=2;
RUN;

/* 1. Create a data set that deletes the months with no recorded snowfall and only 
includes seasons with non-missing season total, call it snow and put it in the work directory*/
data snow;
	set grsnow;
	drop june july aug sept;
	where season ne '' and season_total ne .;
run;

/* Create a data set called Outliers  */

/* Recall from Introductory statistics that a definition for an outlier is a point that is more
than 1.5IQRs from the first or third quartile */
data snowskinny;
	set snow;
	array months{*} OCT--MAY;

	do i=1 to dim(months);
		month=vname(months{i});
		snowfall=months{i};
		monthnum=i;
		output;
	end;

	keep season season_total month snowfall monthnum;
run;

/* using proc means to get an output dataset with summary statistics */
proc means data=snowskinny q1 q3 nway noprint;
	/* q1 q3 are statistics 
	keywordsthey include q1 and q3 in output, nway is an option that says
	only return the summary stats for each level of month */
	class month;
	var snowfall;
	output out=quartiles q1= q3= /autoname;

	/* quartiles  is the name of the output dataset, 
	 autoname tells sas to name the variables automatically */
run;

proc sort data=snowskinny;
	by month;
run;

data outliers;
	merge snowskinny quartiles;
	by month;

	iqr=snowfall_q3-snowfall_q1;
	if (0 < snowfall < (snowfall_q1 - 1.5* IQR))
	or (snowfall > (snowfall_q3 + 1.5*IQR));

	where month in('NOV','DEC','JAN','FEB','MAR');

	/* finish the code to select observations that are outliers*/
	/* use an if statement */

	/*select our attention
	to the months where snow occurs often*/
run;

title "Which month is most snowy on average?";
proc means data=work.snowskinny
	n mean stddev min q1 median q3 max maxdec=1;
	class month;
	var snowfall;
run;

/* which month is snowiest each year?
rewrite the code below using arrays*/
data most;
	set snow; *uses season level data;
	maxs=max(of oct -- may); *snowfall for month with most snow;

	if maxs = dec then
		most="December";
	else if maxs = jan then
		most="January";
	else if maxs= feb then
		most="February";
	else if maxs= mar then
		most="March";
	else if maxs=nov then
		most = "November";
	label most="Seasons where this month has the most snow";
run;

data most_array;

set snow; *uses season level data;
maxs=max(of oct--may);
array months{*} oct--may;
do i=1 to dim(months);
	if maxs = months{i} then most=vname(months{i});
	end;
	
	label most="Seasons where this month has the most snow";

proc sort data=work.snowskinny;
	by season descending snowfall;
run;

data most_by_group;
	set work.snowskinny;
	by season;
	if first.season;
	rename month=most;
run;


title "January is usually the month with the most snowfall";

proc freq data=most;
	table most /missing;
run;

proc freq data=most_array;
	table most /missing;
run;

proc freq data=most_by_group;
	table most /missing;
run;

title "Average total snowfall for each month";

proc means data=snow;
	var oct -- season_total;
run;

proc sort data=snowskinny;
	by monthnum;
run;

proc sgplot data=snowskinny;
	hbox snowfall / category=Month;
	title "Snow Fall in Grand Rapids and Table for Outliers";
	yaxis discreteorder=data;
	label month = "Month of the Year" 
		snowfall="Snow Fall (inches)";
run;

proc report data=outliers;
	columns season month snowfall season_total;
run;

title;

data snowskinny2;
	set snowskinny;
	smallseason1=scan(season,1,'/');
	smallseason2=scan(season,2,'/');

	if month in("OCT","NOV","DEC") then
		year=smallseason1;
	else if month in("JAN","FEB","MAR","APRIL","MAY") then
		year=smallseason2;
run;

proc sgplot data=snowskinny2;
	hbox snowfall / category=Month datalabel=year labelfar; *datalabel puts labels only on extreme outliers over 3 IQR;
	title "Snowfalls in Grand Rapids, Extreme Outliers Labeled";
	yaxis discreteorder=data;
	label month = "Month of the Year" 
		snowfall="Snow Fall (inches)";
	where month not in("OCT","MAY","APRIL");
run;