*David Crawford 2016;

libname out "PATH_TO_OUTPUT";
libname stat1 "PATH_TO_DATA";

%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
         Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
         Masonry_Veneer Lot_Shape_2 Central_Air;

ods graphics;

proc glmselect data=STAT1.ameshousing3
               plots=all;

    class &categorical / param=glm ref=first;
	*saleprice is target;
    model SalePrice=&categorical &interval / 
               selection=stepwise
               select=aic 
               choose=validate;
			   partition fraction (validate=.3333);
    title "Selecting the Best Model using Honest Assessment";
run;