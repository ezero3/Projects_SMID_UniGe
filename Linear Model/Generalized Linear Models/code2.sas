LIBNAME LAB4 "/home/u6361002/MODELLI_LINEARI/LABO4";

/*Costruzione dataset*/

Data Contraccettivi;
input age $6. education $5. wantsMore $4. notUsing using;
datalines;
<25   low  yes 53  6
<25   low  no  10  4
<25   high yes 212 52
<25   high no  50  10
25-29 low  yes 60  14
25-29 low  no  19  10
25-29 high yes 155 54
25-29 high no  65  27
30-39 low  yes 112 33
30-39 low  no  77  80
30-39 high yes 118 46
30-39 high no  68  78
40-49 low  yes 35  6
40-49 low  no  46  48
40-49 high yes 8   8
40-49 high no  12  31
;

Data Contraccettivi;
set contraccettivi;
total= using + notUsing;
run;

/*Ananlisi descrittiva*/

proc sql;
	create table contraccettivi_2 as
	select 
		*,
		using/total as p_using
	from
		contraccettivi;
	select * from contraccettivi_2;
quit;

proc sql;
	create table contraccettivi_total as 
	select
		sum(notUsing) as total_notUsing,
		sum(using) as total_using,
		sum(total) as total,
		sum(using)/sum(total) as p_using
	from
		contraccettivi;
	select * from contraccettivi_total;
quit;
		
	
proc sql;
    create table Age as
    select 
        age,
        sum(notUsing) as sum_notUsing,
        sum(using) as sum_using,
        sum(total) as sum_total,
        sum(using)/sum(total) as p_using
    from 
        contraccettivi
    group by 
        age;
    select * from Age;
quit;

proc sql;
    create table Education as
    select
        education,
        sum(notUsing) as sum_notUsing,
        sum(using) as sum_using,
        sum(total) as sum_total,
        sum(using)/sum(total) as p_using
    from 
        contraccettivi
    group by 
        education;
    select * from Education;
quit;

proc sql;
    create table WantsMore as
    select 
        wantsMore,
        sum(notUsing) as sum_notUsing,
        sum(using) as sum_using,
        sum(total) as sum_total,
        sum(using)/sum(total) as p_using
    from 
        contraccettivi
    group by 
        WantsMore;
    select * from WantsMore;
quit;

proc sql;
    create table Age_education as
    select 
        age,
        education,
        sum(notUsing) as sum_notUsing,
        sum(using) as sum_using,
        sum(total) as sum_total,
        sum(using)/sum(total) as p_using
    from 
        contraccettivi
    group by 
        age, education;
    select * from Age_education;
quit;

title "Percentuale utilizzo contraccettivo nelle fasce d'età raggruppate per livello di istruzione";
PROC SGPLOT DATA=Age_education;
	VBAR age / RESPONSE=p_using GROUP=education GROUPDISPLAY=CLUSTER DATALABEL;
	XAXIS LABEL="Fasce di Età";
	YAXIS LABEL="Proporzione di Using";
RUN;

proc sql;
    create table Age_wantsMore as
    select 
        age,
        wantsMore,
        sum(notUsing) as sum_notUsing,
        sum(using) as sum_using,
        sum(total) as sum_total,
        sum(using)/sum(total) as p_using
    from 
        contraccettivi
    group by 
        age, wantsMore;
    select * from Age_wantsMore;
quit;

title "Percentuale utilizzo contraccettivo nelle fasce d'età rispetto alla volontà di aver dei figli";
PROC SGPLOT DATA=Age_wantsMore;
	VBAR age / RESPONSE=p_using GROUP=wantsMore GROUPDISPLAY=CLUSTER DATALABEL;
	XAXIS LABEL="Fasce di Età";
	YAXIS LABEL="Proporzione di using";
RUN;

proc sql;
    create table Education_wantsMore as
    select 
        education,
        wantsMore,
        sum(notUsing) as sum_notUsing,
        sum(using) as sum_using,
        sum(total) as sum_total,
        sum(using)/sum(total) as p_using
    from 
        contraccettivi
    group by 
        education, wantsMore;
    select * from education_wantsMore;
quit;

title "Percentuale utilizzo contraccettivo per livello di istruzione rispetto alla volontà di aver dei figli";
PROC SGPLOT DATA=Education_wantsMore;
	VBAR education / RESPONSE=p_using GROUP=wantsMore GROUPDISPLAY=CLUSTER DATALABEL;
	XAXIS LABEL="Livello di istruzione";
	YAXIS LABEL="Proporzione di using";
RUN;

title;

/*GLM*/

proc genmod data=contraccettivi;
	class age education wantsMore;
	model using/total = age education wantsMore / link= logit cl; 
run;

proc genmod data=contraccettivi;
	class age education wantsMore;
	model using/total = age education wantsMore / link= identity cl; 
run;

proc genmod data=contraccettivi;
	class age education wantsMore;
	model using/total = age education wantsMore / link= probit cl;
run;

proc genmod data=contraccettivi;
	class age education wantsMore;
	model using/total = age education wantsMore / link= cloglog cl;
	OUTPUT OUT=output_genmod_cloglog PRED=predicted_values RESRAW=residuals; /*Modello migliore*/
run;


proc logistic data=contraccettivi;
	class age education wantsMore / param= effect;
	model using/total = age education wantsMore / link= logit;
run;

proc logistic data=contraccettivi;
	class age education wantsMore / param= ref;
	model using/total = age education wantsMore / link= logit;
run;
