*we wonder if a coin is fair? We are going to simulate different 
situations and do a hypothesis test(s);

*Situation: Effect size = how much larger than .5 the true probability
of heads is.
Test:
H_o: p=.5 (coin is fair)
H_a: P>.5

n is sample size;
%let n=100;

*# of coin flips;
%let effect_size=.05;

data flipped;
	do i=.05 to .4 by .01;
		p_true=.5+&effect_size;
		n=&n;
		x=rand('binomial',p_true,n);

		*x is simulated # of heads;
		p_hat=x/n;

		*simulated proportion of heads;
		p_value=1-cdf('binomial',x-1,.5,n);
		output;
	end;
run;

proc print data=flipped;
run;

proc freq;
table p_value;
run;

proc sgplot;
	histogram p_value;
run;

/*simulation, what is a p-value*/
/* is it a fair coin??*/
title " with effect size of &effect_size and n of &n";
data simulate;
	p=&p_null+&effect_size;
	n=&n;

	do i=1 to 200;
		x=rand('binomial',p,&n);
		p_value=1-cdf('binomial',x-1,&p_null,&n);
		rejecth0=(p_value<.05);
	output;
	end;
run;

title;

data simulated;
	do effect_size=0 to .5 by .01;
		do n=10,50,100;
			truep=.5+effect_size;
			do i=1 to 1000;
				num_heads=rand('binomial',truep,n);
				pvalue=1-CDF('BINOMIAL',num_heads-1,.5,n);
				rejecth0=(pvalue<.05);
				output;
			end;
		end;
	end;
run;

*proc means is used to summarize how many are significant;
proc means data=simulated nway noprint;
	class truep  n;
	var rejecth0;
	output out=stat sum=num_significant;
run;

data stat;
	set stat;
	prop_sig=num_significant/_freq_;
	drop _freq_ _type_;
run;

proc sgplot;
	loess x=truep y=prop_sig /group=n;

	/* loess is a locally smoothed curve*/
	label prop_sig ="Proportion Significant" n="Sample Size"
		truep="Probability of Heads";
	Title "Simulation Results:  More Flips, Bigger Advantage Heads";
	title2 "More Likely to Detect the Coin is Unfair";
run;

proc freq;
	table rejecth0;
run;