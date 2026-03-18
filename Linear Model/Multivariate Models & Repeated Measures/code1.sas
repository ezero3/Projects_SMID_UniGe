LIBNAME LAB1 "/home/u63610025/MODELLI_LINEARI/LABO1";

/*
1) importare dataset e disporlo in formato multivariato
*/
data LAB1.PULSE;
	infile "/home/u63610025/MODELLI_LINEARI/LABO1/pulse_diet_exertype.txt" 
		FIRSTOBS=2 DSD delimiter='	';
	input ID DIET EXERTYPE $ PULSE TIME;  
run;

proc template;
	define style styles.Verde;
		parent=styles.Ocean;
		class GraphAxisLines / contrastcolor=stolg color=viyg;
		class GraphBackground / color=aquamarine;
		class GraphOutlier / color=black;
		class GraphBox / capstyle="serif" connect="mean";
		class GraphBoxMean/ contrastcolor=yellow markersymbol="diamondfilled";
		class GraphWalls/ color=bibg;
	end;
run;

ods graphics;
ods listing gpath="/home/u63610025/MODELLI_LINEARI/GRAFICI" style=styles.verde;

/*
1) importare dataset e disporlo in formato multivariato;
*/

data lab1.pulse1;
	set lab1.pulse;
	where time=1;
	rename pulse=PULSE_1MIN time=time1;
run;

data lab1.pulse2;
	set lab1.pulse;
	where time=2;
	rename pulse=PULSE_15MIN time=time2;
run;

data lab1.pulse3;
	set lab1.pulse;
	where time=3;
	rename pulse=PULSE_30MIN time=time3;
run;

*formato multivariato;
proc sql;
	create table lab1.PULSE_TOT as select id, pulse_1min, pulse_15min, 
		pulse_30min, diet, exertype from lab1.pulse1 natural inner join lab1.pulse2 
		natural inner join lab1.pulse3;
quit;


/*
2) Analisi descrittive
*/
proc means data=lab1.pulse_tot;
	var pulse_1min pulse_15min pulse_30min;
run;

proc means data=lab1.pulse_tot;
	class diet;
	var pulse_1min pulse_15min pulse_30min;
run;

proc means data=lab1.pulse_tot;
	class exertype;
	var pulse_1min pulse_15min pulse_30min;
run;

proc means data=lab1.pulse_tot mean std;
	class diet exertype;
	var pulse_1min pulse_15min pulse_30min ;
run;


*correlazione;
proc corr data=lab1.pulse_tot noprob; /*correlazione tra pulsazione15 e puls30 , 0.85 */
	var pulse_1min pulse_15min pulse_30min;
	title "Correlazione tra battiti cardiaci a tempi diversi";
run;

proc sort data=lab1.pulse_tot;
	by diet;
run; 

proc corr data=lab1.pulse_tot noprob; /*la correlazione tra pulsazioni nei due tipi di dieta diverse si comportano similarmente = a prima*/
	by diet;
	var pulse_1min pulse_15min pulse_30min;
	title "Correlazione tra battiti cardiaci a tempi diversi per dieta seguita";
run;

proc sort data=lab1.pulse_tot;
	by exertype;
run;

proc corr data=lab1.pulse_tot noprob;
	by exertype; /*per es 1*/
	var pulse_1min pulse_15min pulse_30min;
	title "Correlazione tra battiti cardiaci a tempi diversi per tipo di esercizi";
run; 

title;

*matrice di contingenza;
proc freq data=lab1.pulse_tot; 
tables diet*exertype/ nocol norow nopercent;
run;

*boxplot;
%let variabili=pulse_1min pulse_15min pulse_30min;

%macro boxplot;
	%do i=1 %to 3;
		%let vet=%scan(&variabili, &i);

		proc boxplot data=lab1.pulse_tot;
			plot &vet*exertype/ boxstyle=schematic boxconnect=mean boxwidthscale=1;
			insetgroup mean;
		run;

		quit;
	%end;

	proc sort data=lab1.pulse_tot;
		by diet;
	run;

	%do i=1 %to 3;
		%let vet=%scan(&variabili, &i);

		proc boxplot data=lab1.pulse_tot;
			plot &vet*diet/ boxstyle=schematic boxconnect=mean boxwidthscale=1;
			insetgroup mean;
		run;

		quit;
	%end;
%mend;

%boxplot;

*scatter plot;
symbol1 height=1.5 c=bioy v=diamondfilled interpol=rl;
symbol2 height=1.5 c=green v=squarefilled interpol=rl;
symbol3 height=1.5 c=bib v=dot interpol=rl;


proc gplot data=lab1.pulse_tot;
	plot pulse_1min*pulse_15min=exertype;
	title "Scatterplot delle pulsazioni misurate dopo 1 min e dopo 15 min a seconda del tipo di esercizio svolto";
	run;

proc gplot data=lab1.pulse_tot;
	plot pulse_1min*pulse_30min=exertype;
	title "Scatterplot delle pulsazioni misurate dopo 1 min e dopo 30 min a seconda del tipo di esercizio svolto";
	run;

proc gplot data=lab1.pulse_tot;
	plot pulse_15min*pulse_30min=exertype;
	title "Scatterplot delle pulsazioni misurate dopo 15 min e dopo 30 min a seconda del tipo di esercizio svolto";
	run;

proc gplot data=lab1.pulse_tot;
	plot pulse_1min*pulse_15min=diet;
	title "Scatterplot delle pulsazioni misurate dopo 1 min e dopo 15 min a seconda del tipo di dieta seguita";
	run;

proc gplot data=lab1.pulse_tot;
	plot pulse_1min*pulse_30min=diet;
	title "Scatterplot delle pulsazioni misurate dopo 1 min e dopo 30 min a seconda del tipo di dieta seguita";
	run;

proc gplot data=lab1.pulse_tot;
	plot pulse_15min*pulse_30min=diet;
	title "Scatterplot delle pulsazioni misurate dopo 15 min e dopo 30 min a seconda del tipo di dieta seguita";
	run;


*istogrammi;

proc means data=lab1.pulse noprint;
	class diet exertype time;
	var pulse;
	output out=medie mean=mean;
run;


data medie_diet1;
set medie;
if nmiss(of diet, time)=0 and diet=1;
if exertype= null then
		exertype="Tot";
run;

data medie_diet2;
set medie;
if nmiss(of diet, time)=0 and diet=2;
if exertype= null then
		exertype="Tot";
run;

data medie_tot;
set medie;
where _type_=1;
run;

proc sgplot data=medie_diet1;
	vbar exertype / response=mean group=time groupdisplay=cluster 
		attrid=time datalabel datalabelattrs=(size=10);
	yaxis label='Media' values=(0 to 150 by 25);
	title 'Medie delle pulsazioni cardiache assegnate alla dieta 1 rispetto al tempo';
run;

proc sgplot data=medie_diet2;
	vbar exertype / response=mean group=time groupdisplay=cluster 
		attrid=time datalabel datalabelattrs=(size=10);
	yaxis label='Media' values=(0 to 150 by 25);
	title 'Medie delle pulsazioni cardiache assegnate alla dieta 2 rispetto al tempo';
run;

proc sgplot data=medie_tot;
	vbar time / response=mean datalabel=mean;
	yaxis label='Media';
	title 'Medie delle pulsazioni cardiache totali rispetto al tempo';
run;


data aumento_pulsazioni1_30;
	set lab1.pulse_tot;
	incremento_pulsazioni=PULSE_30MIN - PULSE_1MIN;
run;

data aumento_pulsazioni1_15;
	set lab1.pulse_tot;
	incremento_pulsazioni=pulse_15min - pulse_1min;
run;

proc gchart data = aumento_pulsazioni1_15;
	pattern1 color=yellow; pattern2 color=red;
	title "Istogramma aumento di pulsazioni da 1 min a 15 min";
    axis1 label=('Dieta') color=black; 
    axis2 label=(a=90 'MEDIA AUMENTO PULSAZIONI') color=black;
    vbar diet / sumvar=incremento_pulsazioni type= mean discrete mean patternid=midpoint
    raxis=axis2 maxis=axis1 coutline=yellow group=exertype width=8 cframe=lightblue;
run;quit;

proc gchart data=aumento_pulsazioni1_30;
	pattern1 color=yellow; pattern2 color=red;
	title "Istogramma aumento di pulsazioni da 1 min a 30 min";
    axis1 label=('Dieta') color=black; 
    axis2 label=(a=90 'MEDIA AUMENTO PULSAZIONI') color=black;
	vbar diet /sumvar=incremento_pulsazioni type=mean discrete mean patternid=midpoint
	raxis=axis2 maxis=axis1 coutline=yellow group=exertype width=8 cframe=lightblue;
run;quit;

title;

/*
3) analisi multivariata
*/

proc glm data=lab1.pulse_tot;
	class exertype diet;
	model pulse_1min pulse_15min pulse_30min = exertype| diet ; 
	repeated time 3 contrast(1) / summary printm;
run; quit;