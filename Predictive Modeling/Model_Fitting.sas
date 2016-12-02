*David Crawford 2016;

/*st106d01.sas*/

libname out "PATH_TO_OUTPUT";
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
         Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
         Masonry_Veneer Lot_Shape_2 Central_Air;

ods graphics;

proc glmselect data=STAT1.ameshousing3
               plots=all 
               valdata=STAT1.ameshousing4;
			   *in proc gml and glmselect we can include 
			   categorical predictors, we need to use a 
			   class statement so they are handled properly;
    class &categorical / param=glm ref=first;
	*saleprice is target;
    model SalePrice=&categorical &interval / 
               selection=backward
			   /* start with a model with all variables and remove a variable one buy one based on the selection criteria*/
               select=sbc /*selection criterion. SBC equals the Shwarz Bayezion Information Criteria
			   It is a function of the sum of squared errors (SSE)
			   We want a small SBC */
               choose=validate; *use validation dataset that uses average squared error for the validation data;
    store out=out.amesstore;
    title "Selecting the Best Model using Honest Assessment";
run;




