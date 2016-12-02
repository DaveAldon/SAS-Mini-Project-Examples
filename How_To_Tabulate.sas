*David Crawford 2016;

filename indat "PATH_TO_DATA";

proc format;
	value $type 'cat'='Catamarane' 'sch'='Schooner' 'yac'='Yatch';
run;

data boats;
	infile indat;
	input name $ 1-12 port $ 14-20 locomotion $ 22-26 type $ 28-30 price 32-37 length 39-41;
run;

proc tabulate data= boats FORMAT=dollar9.2;
	class locomotion type;
	var price;
	table locomotion ALL, mean*price*(type all) /box="Full day excursions" misstext="none";
	title;
	format type $type.;
run;


proc tabulate data= boats;
	class port locomotion type;
	table port, locomotion, type;
	title "Number of Boats by Port, Locomotion, and Type";
run;


proc tabulate data= boats;
	class locomotion type;
	var price;
	table locomotion ALL, mean*price*(type all);
	title "Mean price by locomotion and type";
run;


proc tabulate data= boats FORMAT=dollar9.2;
	class locomotion type;
	var price;
	table locomotion ALL, mean*price*(type all) /box="Full day excursions" misstext="none";
	title;
run;


proc tabulate data= boats FORMAT=dollar9.2;
	class locomotion type;
	var price;
	table locomotion="" ALL, mean=""*price="Mean price by type of boat"*(type="" ALL) /box="full day excursions" misstext="none";
	title;
run;


proc tabulate data= boats;
	class locomotion type;
	var price length;
	table locomotion ALL, mean=''*(price="Mean Price"*F=dollar7.2 length="Mean Length"*F=2.0) * (type all)
	/box="Full day Excursions" misstext="none";
	title "Price and length by type of boat";
run;


