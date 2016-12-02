*David Crawford 2016;

data square;
	numrep=1000;
	a=-1;
	b=1;
	do i=1 to numrep;
		u=rand("Uniform");
		x=a+(b-a)*u;
		u=rand("Uniform");
		y=a+(b-a)*u;

		incircle=((x**2)+(y**2)<1);
		notincircle+incircle;
		estpi = 4*notincircle / i;
		output;
	end;
	pi=constant('pi');
	call symput('pie',put(pi,9.7));
	call symput('piest',put(estpi,9.7));
run;

ods grapics on/width=4in height=4in;
proc sgplot data=square;
	scatter x=x y=y /group=incircle
	markerattrs=(symbol=circlefilled size=3);
	title "Pi (&pie ...) is estimated to be &piest ";
run;
ods graphics/reset;

*ods escapechar="~";
*ods text="~{style [font_size=18pt ] ~{unicode pi} is estimated to be &piest using &numsampleruns.}";

data estimate;
	numrep=1000000;
	a=-1;
	b=1;
	do i=1 to numrep;
		u=rand("Uniform");
		x=a+(b-a)*u;
		u=rand("Uniform");
		y=a+(b-a)*u;

		incircle=((x**2)+(y**2)<1);
		notincircle+incircle;
		estpi = 4*notincircle / i;
	end;
	pi=constant('pi');
	call symput('pie',put(pi,9.7));
	call symput('piest',put(estpi,9.7));
	diffpi=estpi-pi;
run;

proc print data=estimate;
	var numrep estpi pi diffpi;
	format diffpi 10.8;
run;