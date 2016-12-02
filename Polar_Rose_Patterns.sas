*David Crawford 2016;

ods pdf file="PATH_TO_OUTPUT";

/*http://blogs.sas.com/content/iml/2015/12/16/polar-rose.html*/

%let k = 4; *create a macro variable, it is referenced with &k in the code;

/* draw the curve r=cos(k * theta) in polar coords, which is a k-leaved rose */
data Rose;
do theta = 0 to 2*constant("pi") by 0.01;
   r = cos(&k * theta);       /* rose */
   x = r*cos(theta);          /* convert to Euclidean coords */
   y = r*sin(theta);
   output; *output is inside the loop;
end;
run;
 
title "Polar Rose: r = cos(&k theta)";;
proc sgplot data=Rose aspect=1;
   refline 0 / axis=x;
   refline 0 / axis=y;
   series x=x y=y;
   xaxis min=-1 max=1;
   yaxis min=-1 max=1;
run;

data Roses;
do n = 1 to 4; *numerator;
   do d = 1 to 6; *denominator;
      k = n / d; /* this is a variable k, only exists
	  in the data step, does not impact the macro variable k,
	  macro variable is referenced with &k*/
      /* draw the rose r=cos(n/d * theta) */
      group = mod(n+d, 2);        /* optional: use for color */
      do theta = 0 to 2*lcm(n,d)*constant("pi") by 0.15;
         r = cos(k * theta);      /* generalized rose */
         x = r*cos(theta);        /* convert to Euclidean coords */
         y = r*sin(theta);
         output;
      end;
   end;
end;
run;

title "Polar Roses: r = cos(n/d theta)";
proc sgpanel data=Roses aspect=1 noautolegend;
   styleattrs datacontrastcolors=(purple red);
   panelby n d / layout=lattice onepanel rowheaderpos=left;
   refline 0 / axis=x transparency=0.5;
   refline 0 / axis=y transparency=0.5;
   series x=x y=y / group=group;
   colaxis display=none;
   rowaxis display=none;
run;

data temp;
	do n=1 to 6;
		do d=1 to 4;
		k=n/d;
		output;
		end;
	end;
run;

ods pdf close;
