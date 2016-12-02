*David Crawford 2016;

options nodate nonumber;
goptions reset=all;

data anno_cities;
	set mapsgfk.uscity
		(where=(statecode='MI' and
		city in ('Lowell')));
	mylabel1="Home City";
	mylabel2="Statistics";
	flag=1;
run;
proc print data=anno_cities;
var id--city mylabel1 mylabel2 flag;
run;

data my_map;
	set mapsgfk.us_states
		(where=(statecode='MI' and density<=3));
run;

data combined;
	set my_map anno_cities;
run;

proc gproject data=combined out=combined
	eastlong degrees latlong dupok;
	id statecode;
run;

data anno_cities my_map(where=(y<0.05 /*remove little island above UP*/));
	set combined;

	if flag=1 then
		output anno_cities;
	else output my_map;
run;

*adds instructions to make the red dot for the annotated data;
data anno_cities_simple; set anno_cities;
length function $8;
xsys='2'; ysys='2'; hsys='3'; when='a';
function='pie'; style='psolid'; rotate=360; size=1;
color='red';
run;

pattern1 v=s color=white;

proc gmap map=my_map data=my_map anno=anno_cities_simple;
	id statecode;
	choro segment / levels=1 nolegend coutline=gray88;
run;

data anno_cities_simple; set anno_cities;
length function $8 text $100;
xsys='2'; ysys='2'; hsys='3'; when='a';
function='pie'; style='psolid'; rotate=360; size=1;
color='red'; output;
function='label'; position='3';
style=''; rotate=.; size=.; color='';
text=trim(left(city)); output;
run;


proc gmap map=my_map data=my_map anno=anno_cities_simple;
	id statecode;
	choro segment / levels=1 nolegend coutline=gray88;
run;
goptions cback=blue hsize=6.5 vsize=3 ;
data anno_cities;
	set anno_cities;
	length function $8 text $100  style color $10;;
	xsys='2';
	ysys='2';
	hsys='3';
	when='a';
	function="symbol";
	style="marker";
	text="N";
	color="red";
	size=4;

	/*function='pie'; style='psolid'; rotate=360; size=1;
	color='red'; */
output;
	function='label';
	position='6';
	rotate=.;
	size=4;
	color='purple';
	style='';
	text=mylabel1;
output;
	function='label';
	position='9';
	rotate=.;
	size=4;
	color='purple';
	style='';
	text=mylabel2;
	output;
	function='text';
	position='0';
	rotate=.;
	size=35;
	COLOR='Light blue';
	style='brush';
	text="Lowell!";
	x=x-.1035;
	output;
	
run;

*title1 ls=1.5 "  ";
pattern1 v=s color=white;

proc gmap map=my_map data=my_map anno=anno_cities;
	id statecode;
	choro segment / levels=1 nolegend coutline=gray88;
run;