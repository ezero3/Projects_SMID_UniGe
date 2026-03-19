/* DATA PREPROCESSING */
libname temp "/home/u63610025/EPG1V2/METODI_STATISTICI_IN_BIOMEDICINA/ESAME";

/* proc datasets lib=temp; */
/* run; */
/* quit; */
/* data PROSTA; */
/* set temp.esame_psa1_psa2_tra; */
/* 	label TRATTA="trattamento" PSA__1="PSA_basale" PSA__2="PSA_finale"; */
/* run; */
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
ods listing 
	gpath="/home/u63610025/EPG1V2/METODI_STATISTICI_IN_BIOMEDICINA/ESAME/grafici1" 
	style=styles.verde;

proc import datafile="/home/u63610025/EPG1V2/METODI_STATISTICI_IN_BIOMEDICINA/ESAME/Esame_PSA1_PSA2_TRA.xlsx" 
		out=prosta dbms=xlsx replace;
	label TRATTA="trattamento" PSA__1="PSA_basale" PSA__2="PSA_finale";
run;

ods graphics on;

/* gestione dei valori 0 di PSA su cui si dovrà poi effettuare la trasformazione logaritmica */
data PROSTA;
	set PROSTA;

	if PSA__1=0 then
		PSA__1=0.025;

	if PSA__2=0 then
		PSA__2=0.02;
run;

/* trasposizione di ETA a ETA-min(ETA) */
data PROSTA;
	set PROSTA;
	ETA=ETA-41;
run;

/* creazione della variabile DIFF */
data PROSTA;
	set PROSTA;
	DIFF=PSA__2 - PSA__1;
run;

/* creazione delle variabili MESE, GIORNO e ANNO*/
data PROSTA;
	set PROSTA;
	MESE=month(DATINI);
	GIORNO=day(DATINI);
	ANNO=year(DATINI);
run;

/* creazione della variabile STAG (stagione) */
data PROSTA;
	set PROSTA;
	attrib STAG format=$char10.;
	label STAG="stagione";

	if MESE=1 then
		STAG='inverno';

	if MESE=2 then
		STAG='inverno';

	if MESE=3 and GIORNO<21 then
		STAG='inverno';

	if MESE=3 and GIORNO>=21 then
		STAG='primavera';

	if MESE=4 then
		STAG='primavera';

	if MESE=5 then
		STAG='primavera';

	if MESE=6 and GIORNO<21 then
		STAG='primavera';

	if MESE=6 and GIORNO>=21 then
		STAG='estate';

	if MESE=7 then
		STAG='estate';

	if MESE=8 then
		STAG='estate';

	if MESE=9 and GIORNO<22 then
		STAG='estate';

	if MESE=9 and GIORNO>=22 then
		STAG='autunno';

	if MESE=10 then
		STAG='autunno';

	if MESE=11 then
		STAG='autunno';

	if MESE=12 and GIORNO<21 then
		STAG='autunno';

	if MESE=12 and GIORNO>=21 then
		STAG='inverno';
run;

/* creazione della variabile LPSA1 (trasformazione logaritmica della variabile risposta) */
data PROSTA;
	set PROSTA;
	LPSA1=log(PSA__1);
	LPSA2=log(PSA__2);
	label LPSA1="log(PSA_basale)" LPSA2="log(PSA_finale)";
run;

/* creazione variabile ETA */
data PROSTA;
	set PROSTA;
	ETA=year(DATINI)-year(DATNAS);
run;

/* creazione della variabile FASCETA */
data PROSTA;
	set PROSTA;
	attrib FASCETA format=$char20.;
	label FASCETA="fascia d'eta'";

	if ETA<52 then
		FASCETA="<52";

	if 52<=ETA<57 then
		FASCETA="52-56";

	if 57<=ETA<61 then
		FASCETA="57-60";

	if ETA>=61 then
		FASCETA=">60";
RUN;

/* creazione variabile IPERTROFIA (categorica di IPEBEN) */
data PROSTA;
	set PROSTA;
	attrib IPERTROFIA format=$char7.;
	label IPERTROFIA="ipertrofia";

	if IPEBEN=1 then
		IPERTROFIA="assente";

	if IPEBEN=2 then
		IPERTROFIA="lieve";

	if IPEBEN=3 then
		IPERTROFIA="severa";
run;

/* ANALISI DESCRITTIVE */
/* tabella di contingenza per trattamento */
proc FREQ data=PROSTA;
	tables TRATTA / nocum;
	title "distribuzione della tipologia di trattamento";
RUN;

proc FREQ data=PROSTA;
	tables ANNO / nocum;
	title "distribuzione per anno";
RUN;

proc FREQ data=PROSTA;
	tables IPEBEN / nocum;
	title "distribuzione ipertrofia prostatica";
RUN;

proc FREQ data=PROSTA;
	tables fasceta / nocum;
	title "distribuzione per fasce di età";
RUN;

proc FREQ data=PROSTA;
	tables STAG / nocum;
	title "distribuzione per Stagione";
RUN;

/* statistiche di base per PSA1 e PSA2 */
proc UNIVARIATE data=PROSTA outtable=output;
	var PSA__2 PSA__1;
	histogram PSA__2 PSA__1;
	title "analisi univariata di PSA_basale e PSA_finale";
run;

/* statistiche di base per DIFF diviso per trattamento */
proc SORT data=PROSTA;
	by TRATTA;
run;

proc UNIVARIATE data=PROSTA outtable=output;
	var DIFF;
	by TRATTA;
	title "analisi univariata della differenza tra PSA_basale e PSA_finale diviso tra trattamento";
run;

proc SGPLOT data=PROSTA;
	histogram PSA__1 / group=TRATTA;
	histogram PSA__2 / group=TRATTA;
	title "distribuzione di PSA_basale e PSA_finale per tipologia di trattamento";
run;

proc means data=PROSTA mean median std min max n;
	class TRATTA;
	var PSA__1 PSA__2;
run;

proc means data=PROSTA mean median std min max n;
	class STAG;
	var PSA__1 PSA__2;
run;

proc means data=PROSTA mean median std min max n;
	class ANNO;
	var PSA__1 PSA__2;
run;

proc means data=PROSTA mean median std min max n;
	class IPEBEN;
	var PSA__1 PSA__2;
run;

proc means data=PROSTA mean median std min max n;
	class FASCETA;
	var PSA__1 PSA__2;
run;

/* boxplot di LPSA1 e LPSA2 nei livelli di TRATTA */
proc SGPLOT data=PROSTA;
	vbox PSA__1 / category=TRATTA;
	title "distribuzione di PSA_basale per tipologia di trattamento";


proc SGPLOT data=PROSTA;
	vbox PSA__2/ category=TRATTA;
	yaxis max=8;
	xaxis label="Trattamento";
	xaxis values=(1 2) valuesdisplay=("Vecchio trattamento" "Nuovo trattamento");
	title "Distribuzione di PSA_finale per Tipologia di TRATTAMENTO";
run;

/* boxplot di PSA1 e PSA2 nei livelli di FASCETA */
proc SGPLOT DATA=PROSTA;
	vbox PSA__1 / category=FASCETA;
	yaxis max=8;
	xaxis label="Fascia d'Età";
	xaxis discreteorder=data values=("<52" "52-56" "57-60" ">60");
	title "PSA_basale per Livelli di Fasce d'Età";
run;

proc SGPLOT data=PROSTA;
	vbox PSA__2 / category=FASCETA;
	yaxis max=8;
	xaxis label="Fascia d'Età";
	xaxis discreteorder=data values=("<52" "52-56" "57-60" ">60");
	title "PSA_finale per Livelli di Fasce d'Età";
run;

/* scatterplot di PSA1 e PSA2 per eta' */
proc SGPLOT data=PROSTA;
	scatter X=ETA Y=PSA__1;
	title "scatterplot PSA_basale per età";
run;

proc SGPLOT data=PROSTA;
	scatter X=ETA Y=PSA__2;
	title "scatterplot PSA_finale per età";
run;

/* boxplot di PSA1 e PSA2 nei livelli di IPERTROFIA */
proc SGPLOT data=PROSTA;
	vbox PSA__1 / category=IPERTROFIA;
	title "distribuzione di PSA_basale per livello di ipertrofia";
run;

proc SGPLOT data=PROSTA;
	vbox PSA__2 / category=IPERTROFIA;
	title "distribuzione di PSA_finale per livello di ipertrofia";
run;

/* boxplot di PSA1 e PSA2 nei livelli di STAG */
proc SGPLOT data=PROSTA;
	vbox PSA__1 / category=STAG;
	title "distribuzione di PSA_basale per stagione di inizio del trattamento";

proc SGPLOT data=PROSTA;
	vbox PSA__2 / category=STAG;
	title "distribuzione di PSA_finale per stagione di inizio del trattamento";
run;

/* boxplot di PSA1 e PSA2 nei livelli di ANNO */
proc SGPLOT data=PROSTA;
	vbox PSA__1 / category=ANNO;
	title "distribuzione di PSA_basale per anno di inizio del trattamento";

proc SGPLOT data=PROSTA;
	title "distribuzione di PSA_finale per anno di inizio del trattamento";
	vbox PSA__2 / category=ANNO;
run;

/* STUDIO ATTRAVERSO MODELLI LINEARI */
/* studio sulla normalità della varibaile risposta */

proc UNIVARIATE data=PROSTA normal;
	var PSA__1 PSA__2 LPSA1 LPSA2;
	title "distribuzione di PSA";
	histogram PSA__1 / normal (sigma=est mu=est);
	/* est -> i parametri sono stimati dai dati */
	qqplot PSA__1 / normal (sigma=est mu=est);
	histogram PSA__2 / normal (sigma=est mu=est);
	qqplot PSA__2 / normal (sigma=est mu=EST);
	histogram LPSA1 / normal (sigma=est mu=est);
	qqplot LPSA1 / normal (sigma=est mu=est);
	histogram LPSA2 / normal (sigma=est mu=est);
	qqplot LPSA2 / normal (sigma=est mu=est);
run;

proc GENMOD data=PROSTA;
	class IPERTROFIA ANNO TRATTA STAG;
	model PSA__2=ETA ANNO TRATTA IPERTROFIA PSA__1 STAG / expected type1
		type3;
	output out=risultatiii pred=pre stdreschi= Residui_var_risposta_PSA2 ;
run;

proc sgplot data=risultatiii;
   title "Istogramma dei Residui di Pearson standardizzati";
   histogram Residui_var_risposta_PSA2 / scale=percent;
   density Residui_var_risposta_PSA2 / type=normal ; /* curva normale stimata */
   yaxis max=65;  /* limite superiore sull’asse Y */
run;


/* modello completo con LPSA1 tra i predittori e valutazione ipotesi di normalità dell'errore  */
proc GENMOD data=PROSTA;
	class IPERTROFIA ANNO TRATTA STAG;
	model LPSA2=ETA ANNO TRATTA IPERTROFIA LPSA1 STAG / expected type1 
		type3;
	output out=risultati1 pred=pre stdreschi=res_st;
run;

proc UNIVARIATE data=RISULTATI1;
	var RES_ST;
	histogram RES_ST / normal (sigma=EST mu=EST);
	qqplot res_st / normal (sigma=EST mu=EST);
	title "distribuzione dei residui";
run;

/*  modello senza LPSA1 ---> per valutare l'effetto di IPERTROFIA */
proc GENMOD data=PROSTA;
	class IPERTROFIA ANNO TRATTA STAG;
	model LPSA2=ETA ANNO TRATTA IPERTROFIA STAG / expected type1 
		type3;
	output out=risultatiii pred=pre stdreschi= Residui_var_risposta_PSA2 ;
run;




/* modello completo con variabile risposta log(PSA2/PSA1) */
data PROSTA;
	set PROSTA;
	LOGPSA12=log(PSA__2/PSA__1);
run;

proc GENMOD data=PROSTA;
	class IPERTROFIA ANNO TRATTA STAG;
	model LOGPSA12 = TRATTA ANNO IPERTROFIA ETA STAG/ expected type1 
		type3;
	output out=risultati2 pred=pre stdreschi=res_st;
run;

-----------------------------------------------------------------------------------------------------------------------


/* VALUTAZIONE DEL CONFONDIMENTO */
/* modello di riferimento per i confronti: unico predittore TRATTA */
proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2=TRATTA / expected type1 type3;
run;

/* valutazione del confondimento operato dai predittori */
proc GENMOD data=PROSTA;
	class TRATTA ANNO;
	model LPSA2=TRATTA ANNO / expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA IPERTROFIA;
	model LPSA2=TRATTA IPERTROFIA / expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA STAG;
	model LPSA2=TRATTA STAG / expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2=TRATTA ETA / expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2=TRATTA FASCETA / expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2=TRATTA LPSA1 / expected type1 type3;
run;

/* modello di riferimento per i confronti: predittori TRATTA+LPSA1 */
proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2=TRATTA LPSA1 / expected type1 type3;
run;

/* valutazione del confondimento operato dai predittori */
proc GENMOD data=PROSTA;
	class TRATTA ANNO;
	model LPSA2=TRATTA LPSA1 ANNO / expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA IPERTROFIA;
	model LPSA2=TRATTA LPSA1 IPERTROFIA / expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA STAG;
	model LPSA2=TRATTA LPSA1 STAG / expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA FASCETA;
	model LPSA2=TRATTA LPSA1 FASCETA / expected type1 type3;
run;

/* confondimento di ANNO+STAG */
proc GENMOD data=PROSTA;
	class TRATTA STAG ANNO;
	model LPSA2=TRATTA LPSA1 STAG ANNO / expected type1 type3;
run;

/* confondimento di IPERTROFIA+ETA */
proc GENMOD data=PROSTA;
	class TRATTA IPERTROFIA;
	model LPSA2=TRATTA LPSA1 IPERTROFIA ETA / expected type1 type3;
run;

/* confondimento di ANNO+STAG+ANNO*STAG */
proc GENMOD data=PROSTA;
	class IPERTROFIA ANNO TRATTA STAG;
	model LPSA2=IPERTROFIA ANNO TRATTA ETA LPSA1 STAG ANNO*STAG / TYPE1 TYPE3;
run;

/* confondimento di ANNO+STAG+ETA */
proc GENMOD data=PROSTA;
	class ANNO TRATTA STAG;
	model LPSA2=ANNO TRATTA ETA LPSA1 STAG / TYPE1 TYPE3;
run;

/* INCREMENTO MEDIO PERCENTUALE di PSA2 per ETA */

proc means data=PROSTA mean median std min max n;
/* 	class FASCETA; */
	var ETA;
run;

proc GENMOD data=PROSTA;
	model LPSA2= ETA/ expected type1 type3;
run;

data PROSTA;
	set PROSTA;
	ETA2=ETA-41;
run;

proc GENMOD data=PROSTA;
	model LPSA2= ETA2/ expected type1 type3;
run;