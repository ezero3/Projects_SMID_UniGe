libname Auto base "/home/u63610025/EPG1V2/AUTO_ESAME" ;
filename car "/home/u63610025/EPG1V2/AUTO_ESAME/auto.txt";

*Impostiamo il template da usare per i nostri boxplot;
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
ods listing gpath="/home/u63610025/EPG1V2/AUTO_ESAME/grafici" style=styles.verde;	

*Creazione dataset : ;
*Importo e definisco le variabili , lettura dei dati;
data auto.car;
	infile car dlm ='20'x;
	input @1 Model_Car $ @19 Origin $ & Price Mpg Rep78 Rep77 Hroom Rseat Trunk Weight Length Turn Displa Gratio&;
	*Ora trasformiamo le unità di misura delle variabili e arrotondiamo;
	Mpg=0.43*Mpg;          Mpg=round(Mpg,0.1);           
	Hroom=2.54*Hroom;      Hroom=round(Hroom,0.2);
	Rseat=2.54*Rseat;	   Rseat=round(Rseat,0.2);
	Trunk=0.03*Trunk;	   Trunk=round(Trunk,0.2);
	Weight=0.45*Weight;    Weight=round(Weight,0.1);
	Length=Length*2.54;    Length=round(Length,0.2);
	Turn=Turn*0.30;        Turn=round(Turn,0.1);
	Displa=Displa*16.39;   Displa=round(Displa,0.2);
run;

*ANALISI DESCRITTIVA;

*Nuove variabili Incremento Condizione dal 1977 al 1978 e Fascia di Prezzo ;
proc sql;
    create table auto.dss as
    select *,
           (rep78 - rep77) as Incremento,
           case 
               when Price < 6000 then '0'
               when Price >= 6000 and Price < 8000 then '1'
               when Price >= 8000 then '2'
           end as Price_Range
    from auto.car
    where Rep77 is not null and Rep78 is not null;
quit;

proc print data=Auto.dss; run;

*Creazione dataset per origine;
data auto.america;            
	set auto.dss;
	where Origin='A';
run; 

data auto.europa;
	set auto.dss;
	where Origin='E';
run;

data auto.giappone;
	set auto.dss;
	where Origin='J';
run;

*Caratteristiche del dataset : ;
proc contents data=auto.dss;run;

proc means data=auto.dss n mean ;
	title "Medie Variabili distinte per l'Origine di Produzione";
	output out=auto.mean_origin;
	class Origin;
run;

*Osservo correlazione tra le variabili ;
proc corr data=auto.america;
	title "Statistiche Dataset-America";
run; 

proc corr data=auto.europa ;
	title "Statistiche Dataset-Europa";
run; 					                    
								     
proc corr data=auto.giappone;
	title "Statistiche Dataset-Giappone";
run;  
proc corr data=auto.dss;
	title "Statistiche Dataset";
run; 

*OSSERVAZIONI TRA VARIABILI ; 
ods graphics on;

proc sort data=auto.dss; by Origin;run;
proc boxplot data=auto.dss;
	title "Distribuzione Consumo Benzina km/l nei vari Paesi di produzione:";
	plot Mpg*Origin/ boxstyle = schematicid boxconnect=mean;
	inset min mean max stddev / header="Statistiche totali" pos=tm;
	insetgroup n mean;
	footnote "E' interessante osservare la distribuzione dell'America rispetto agli altri due paesi,colpita dalla crisi energetica del '79";
run;
footnote;

*Mpg per fascia prezzo in America;
proc sort data=auto.america;by Price_Range;run;
proc boxplot data=auto.america;
	title 'Distribuzione del chilometraggio per Fascia di Prezzo';
	plot Mpg*Price_range/ boxstyle = schematicid boxconnect=mean;
	insetgroup n mean;
run;

proc gchart data=auto.dss;
	pattern1 color=yellow; pattern2 color=red;pattern3 color=orange;
	title "Chilometraggio e Fascia di Prezzo";
    axis1 label=('Fascia di Prezzo') color=black; 
    axis2 label=(a=90 'Chilometraggio [Km/L]') color=black;
	vbar Price_Range/sumvar=Mpg type=mean discrete mean patternid=midpoint
	raxis=axis2 maxis=axis1 coutline=yellow group=Origin width=8 cframe=lightblue;
run;quit;


proc sort data=auto.dss; by Origin;run;
proc boxplot data=auto.dss;
	title 'Distribuzione Rapporto Marcia Alta per Paese di Produzione';
	plot Gratio*Origin/ boxstyle = schematicid boxconnect=mean;
	insetgroup n mean;
run;

proc sort data=auto.dss; by Origin;run;
proc boxplot data=auto.dss;
	title 'Distribuzione della Cilindrata per Paese di Produzione';
	plot Displa*Origin/ boxstyle = schematicid boxconnect=mean;
	insetgroup n mean;
run;
ods graphics off;

*Media Cilindrata per Origine;
proc gchart data=auto.dss;
	pattern1 color=darkred; pattern2 color=OrangeRed;pattern3 color=orange;
	title "Media della Cilindrata per Origine di Produzione ";
	axis1 label=('Origine di Produzione Macchina') color=black; 
    axis2 label=(a=90 'Media Cilindrata [cc]') color=black; 
	vbar Origin /  discrete patternid=midpoint 
	outside=mean sumvar=displa type=mean mean nozero width=5
	raxis=axis2 maxis=axis1 ;
	footnote "Si osserva come le macchine prodotte in America abbiano una media di cilindrata maggiore rispetto al resto del mondo";
run;quit;
title;
footnote;
************************************
*CONFRONTO VARIABILI REP77 e REP78 *
************************************;

proc gchart data=auto.dss;
	title "Condizione Macchina nel 1977 rispetto all'origine di produzione";
	axis1 label=('Origine di produzione ') color=red; 
    axis2 label=(a=90 'Condizione Macchina nel 1977') color=red; 
	pattern1 c=red;
	format rep77 ;
	vbar Origin / cframe=lightblue  discrete sumvar=Rep77 type=mean
	outside=mean width=15 coutline=darkred
	raxis=axis2 maxis=axis1;
run;quit;



*Distribuzione dell'incremento nel dataset;

axis1 label=('Incremento Condizione Macchine ') color=red ; 
axis2 label=(angle=90 'Frequenza Assoluta' ) color=red ;
proc gchart data =auto.dss ;
    pattern1 color=orange; pattern2 color=red;pattern3 color=orangered;pattern4 color=orange;pattern5 color=yellow; 
	vbar Incremento/ discrete  patternid=midpoint
	raxis=axis2 maxis=axis1 coutline=darkred  outside=freq cframe=lightblue;
run;quit;

*Osservo correlazione tra macchine rispetto alla fascia dei prezzi;

proc corr data=auto.dss (where=(Price_Range='0'));
	title "Fascia di Prezzo Bassa";	
run; *45macchine: 32 americane(71%) ,4 europee(40%) , 9giapponesi(81%);  
proc corr data=auto.dss (where=(Price_Range='1'));
	title "Fascia di Prezzo Media";
run; *8macchine: 4americane,3europee,1giapponese;  
proc corr data=auto.dss (where=(Price_Range='2'));
	title "Fascia di Prezzo Alta";
run;*13macchine:9americane,3europee,1giapponese; 
title;

*Osservo correlazioni tra rep77 e rep78 , stessi comportamenti perchè correlate tra di loro,
 vedo quando non lo sono;
symbol1 c=bilg v=dot interpol=rl h=1 pointlabel;
symbol2 c=yellow v=dot interpol=rl h=1 pointlabel;
title "shisha";
proc gplot data=auto.dss (where=(Price_Range='2'));
	plot Displa*rep77=1 / frame  ctext=black  cframe=bibg;
	plot Displa*rep78=2/ frame  ctext=bilg cframe=steelblue ;
run;quit;

*Un altro dataset nel quale è possibile osservare una distinzione tra rep77 e rep78 è nel dataset 
 ristretto all'origine europea;

symbol1 c=bilg v=dot interpol=rl h=1 pointlabel;
symbol2 c=yellow v=dot interpol=rl h=1 pointlabel;
proc gplot data=auto.europa;
	plot Weight*Rep77=1/ frame ctext=black cframe=bibg ;
	plot Weight*Rep78=2/ frame ctext=bilg cframe=steelblue;
run;quit;

******************************************************
* QUALI VARIABILI INFLUENZANO MAGGIORMENTE IL PREZZO *
******************************************************;

symbol1 c=red v=dot interpol=rl pointlabel;
symbol2 v=dot h=2 c=green interpol=rl pointlabel;
proc gplot data=auto.america;
	plot Weight*Price=1/frame cframe=yellow ctext=OrangeRed;
	plot Displa*Price=2/frame cframe=lightblue ctext=blue;
run;quit;

symbol1 c=red v=dot interpol=rl pointlabel;
symbol2 v=dot h=2 c=blue interpol=rl pointlabel;
symbol3 v=dot h=2 c=green interpol=rl pointlabel;
proc gplot data=auto.europa;
	plot Weight*Price=1/frame cframe=yellow ctext=OrangeRed;
	plot Displa*Price=2/frame cframe=lightblue ctext=blue;
	plot Length*Price=3/frame cframe=dagy ctext=green;
run;quit;

symbol1 v=dot h=2 c=red interpol=rl pointlabel; 
symbol2 v=dot h=2 c=blue interpol=rl pointlabel;
symbol3 v=dot h=2 c=green interpol=rl pointlabel;
proc gplot data=auto.giappone;
	plot Weight*Price=1/frame cframe=yellow ctext=OrangeRed;
	plot Displa*Price=2/frame cframe=lightblue ctext=blue;
	plot Length*Price=3/frame cframe=dagy ctext=green;
run;quit;