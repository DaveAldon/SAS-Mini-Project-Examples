
*%let categorical=id lake;

%let interval=alkalinity pH calcium chlorophyll avg_Mercury No_Samples min max _3_yr_Standard_mercury age_data;

*Problem 1;
options validvarname=v7;
ods rtf style=journal2 gtitle bodytitle file="Z:\HW7.rtf" startpage=no;
proc import datafile="R:\STAT\Kapitula\Stat318\homework\HW7\mercury_in_bass.csv"
/*"\\office\DFS\GVSU-Labdata\STAT\Kapitula\Stat318\homework\HW7\mercury_in_bass.csv"*/
out=mercury;
run;

*Probem 2;
ods select histogram;
proc univariate data=work.mercury noprint;
    var &interval;
    histogram &interval / normal kernel;
    inset n mean std / position=ne;
	*puts summary stats in our histogram;
    title "Interval Variable Distribution Analysis";
	*footnote 'Comments for problem 2:';
run;

ods text='COMMENTS ON PROBLEM 2: Alkalinity is skewed right; PH levels are close to symetrical, but it is slightly skewed left; Calcium is skewed right;
Chlorophyll is skewed right; The average mercury levels are skewed right; The distribution of the number of samples is skewed right; The minimum distribution
is skewed right; The maximum distribution is skewed right; The distribution of the three year standard mercury levels is skewed right; and the distribution 
of age data is skewed left.';
title;
*footnote;

ods graphics on;

*Problem 3;
 proc sgscatter data=work.mercury;
    plot Ph*Avg_Mercury / reg;
    title 'Ph levels and average Mercury in fish';
run;

ods text='COMMENTS ON PROBLEM 3: There is a negative correlation between Ph levels and the average mercury in fish. There do not seem to
be any plots that do not fit this relationship.';
title;

*Problem 4;
proc sgscatter data=work.mercury;
    plot Alkalinity*Avg_Mercury / reg;
    title 'Alkalinity levels and average Mercury in fish';
run;

ods text='COMMENTS ON PROBLEM 4: There is a negative correlation between Alkalinity levels and the average mercury in fish. There is a plot at about 80
mg/L of alkalinity and 1.12 parts per million of mercury that does not fit this relationship, however.';
title;

*Problem 5;
 proc corr data=work.mercury rank
          plots=scatter (nvar=all ellipse=none);
   var Ph;
   with Avg_Mercury;
   title "Correlations and Scatter showing association between Ph levels and average mercury found in fish";
run;

ods text='COMMENTS ON PROBLEM 5: Based on the -0.575 correlation, there is a moderate negative relationship between Ph levels and average 
mercury found in fish.';
title;

*Problem 6;
*ods graphics on;
proc reg data=work.mercury;
    model Ph=Avg_Mercury;
    title "Simple Regression with Average Mercury Levels found in fish as Regressor";
run;
ods escapechar='~';
ods text='COMMENTS ON PROBLEM 6: Least Squares Regression Line equation: Ph = 7.74 + (-2.17)
~n COMMENTS ON PROBLEM 7: For each increase in Ph levels, the average mercury concentration found in fish decreases by 2.17 parts per million.
~n COMMENTS ON PROBLEM 8: There is no concerning pattern.
~n COMMENTS ON PROBLEM 9: There is one point that has a residual value over 2.
~n COMMENTS ON PROBLEM 10: 33.11%';

ods rtf close;


