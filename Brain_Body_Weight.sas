*David Crawford 2016;

Title "Brain Weight and Body Weight Example";

/*create a data set in work*/
data mrexample;
	* Lunneborg (2000) - body weight brain example;
	input species $ bodywt brainwt @@;

	/* @@ holds pointer so multiple
	observations can be read from a single line*/
	logbody = log10(bodywt);

	* transform the body and brain weights;
	logbrain = log10(brainwt);

	* define the indicator of dinosaurs;
	idino= (species="diplodoc" or species="tricerat" or species="brachios");
	idinobod = idino*logbody;
	label idino="Is a Dinosaur?" idinobod="Idino logbody interaction";
	datalines;
beaver        1.35   8.1   cow   465.  423. wolf        36.33  119.5 
goat          27.66  115.  guipig 1.04  5.5  diplodocus  11700. 50. 
asielephant   2547.  4603. donkey 187.1 419. horse       521.   655. 
potarmonkey   10.    115.  cat  3.30  25.6 giraffe     529.   680. 
gorilla       207.   406.  human 62.   1320. afrelephant 6654.  5712. 
triceratops   9400.  70.  rhemonkey 6.8 179. kangaroo    35.    56. 
hamster       0.12   1.   mouse  0.023 0.4 rabbit      2.5    12.1 
sheep         55.50  175. jaguar 100. 157. chimp       52.16  440. 
brachiosaurus 87000. 154.5  rat 0.28  1.9 mole        0.122  3. 
pig           192.0  180
;
run;

*sort by species;
proc sort data=mrexample;
	by species;
run;

title2 "descriptive statistics";
ods graphics on / reset=all width=5.5in;

proc sgscatter data=mrexample;
	matrix bodywt brainwt logbody logbrain/diagonal=(histogram);
run;

ods graphics/ reset=all;
ods graphics on;
title2 "Simple Linear Regression- Same Slope and intercept";

proc reg data=mrexample plots(only) = (residualplot fit(nolimits));
	model logbrain=logbody;
	output out=same predicted=same_int_fit;
run;

title2 "Model with different Intercepts- same slope";

proc reg data=mrexample plots(only) = (residualplot fit(nolimits));
	*different intercepts;
	title2 'Dinosaurs fitted with potentially different intercepts';
	model logbrain=logbody idino;
	output out=dif_int predicted=dif_int_fit;
run;