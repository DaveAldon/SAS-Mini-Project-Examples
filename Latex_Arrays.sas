*David Crawford 2016;

%let path = PATH_TO_DATA;

data bodytemp;
	infile "&path\bodytemp.dat";
	input id $ tempf1-tempf10;
	array tempf(10) tempf1-tempf10;
	do i=1 to 10;
		if tempf(i) = 999 then
			tempf(i) = .;
	end;
	drop i;
run;

/* after you read in data make sure you do a little
exploratory data analysis to check for issues*/

/* running a proc means without a VAR statement will 
give basic summary statistics on all numerical variables*/

proc means data=bodytemp;
run;

data bodytemp;
	infile "&path\bodytemp.dat";
	input id $ tempf1-tempf10;

	* in cases like this where the array name is tempf and the variables start with prefix tempf it is
	not necessary to include a variable list;

	array tempf(10);
	do i=1 to 10;
		if tempf(i) = 999 then
			tempf(i) = .;
	end;
	drop i;
run;

* sometimes numeric variables have lots of different names, in that case you can use the _numeric_ variable list;

data bodytemp;
	infile "&path\bodytemp.dat";
	input id $ tempf1-tempf10;
	*we may want to recode all numeric vars in a data set;
	array allnumeric(*) _numeric_;
	do i=1 to dim(allnumeric); *dim is number of elements in the array;
		if allnumeric(i) = 999 then
			allnumeric(i) = .;
	end;
	drop i;
run;

*Alternative method using 'do over';

data bodytemp;
	infile "&path\bodytemp.dat";
	input id $ tempf1-tempf10;
	array _numeric_;
	do over allnumeric;
		if allnumeric(i) = 999 then
			allnumeric(i) = .;
	end;
run;

data bodytemp;
	infile "&path\bodytemp.dat";
	input id $;
	array tempf(10) tempf1-tempf10;
	array tempc(10); *this creates the array and the 10 variables tempc1-tempc10;
	do i=1 to 10;
		if tempf(i) = 999 then
			tempf(i) = .;
		if tempc(i) = round((5/9)*(tempf(i)-32),0.1); *round function used because we don't want false accuracy, rounds to nearest tenth;
	end;
	drop i;
run;

data bodytemp;
	infile "&path\bodytemp.dat";
	input id $;
	array tempf(10);
	do hour = 1 to 10;
		if tempf(hour) = 999 then tempf(hour_ = .;
		temp=tempf(hour_;
		output;
	end;
	keep if hour temp;
run;

/*

data sales;
infile 'PATH_TO_LOCATION' dlm=',' dsd missover;
input month:monyy7. units;
retain total 0;
total = total + units;
format month monyy7.;
run;
*/