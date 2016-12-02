/*David Crawford Snow Activity 2016*/
libname out "PATH_TO_OUPUT";
title "GR snow";
title1 "Grand Rapids Historical Snowfall";
OPTIONS leftmargin=1in rightmargin=1in topmargin=1in bottommargin=1in;
OPTIONS nodate;
OPTIONS validvarname=v7;
ods pdf startpage=no file="PATH_TO_OUTPUT";

proc import datafile="PATH_TO_CSV"
	out=snow /* creates a dataset "snow" in the WORK directory*/
	dbms=csv
	replace;
	getnames=yes; /*get variable names from first row*/
run;

data out.snow;
	set snow;
	snow_to_jan=sum(of oct--jan);
	snow_after_jan=sum(of feb--june);
	label snow_after_jan="Febuary through June";
	label snow_to_jan="October through January"
		season_total="Season Total";
	seasonstart=scan(season,1,"/")+0; /*takes words out of a text string. This takes out first word from season. Adding 0 makes characters numeric*/
	label seasonstart="Season";
run;

proc means data=out.snow maxdec=2;
	var oct nov dec jan feb mar april may season_total snow_to_jan;
run;

proc means data=out.snow maxdec=2 n mean stddev min q1 median q3 max;
	var oct--may season_total snow_to_jan;
run;

proc print data=out.snow noobs label;
	where snow_to_jan<15;
	var season oct--april snow_to_jan season_total;
	title2 "Seasons with Less than 15 inches by the end of January";
run;

title2; /* Clears out title2 */

proc sgplot;
	yaxis label="Snow Depth (Inches)";
	vbox snow_to_jan / datalabel=season discreteoffset=-0.25;
	vbox season_total / datalabel=season discreteoffset=0.25;
run;

proc sgplot;
	yaxis label="Snow depth (Inches)";
	xaxis fitpolicy=thin;
	series x=seasonstart y=season_total;
	series x=seasonstart y=snow_to_jan;
run;

proc sgplot;
	yaxis label="Snow depth (inches)";
	xaxis fitpolicy=thin;
	band x=seasonstart upper=snow_to_jan lower=0 / legendlabel="January and prior";
	band x=seasonstart upper=season_total lower=snow_to_jan / legendlabel="After January";
run;

ods text="I can put my observations directly into the document";
ods pdf close;