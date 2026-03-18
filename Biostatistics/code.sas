
/* DATA PREPROCESSING */

libname temp "C:\Users\lorif\Desktop\MSB\ESAME";

data PROSTA;
set temp.Esame_PSA1_PSA2_TRA;
	label TRATTA="trattamento" PSA__1="PSA_basale" PSA__2="PSA_finale";
run;

/* gestione dei valori 0 di PSA su cui si dovrà poi effettuare la trasformazione logaritmica */
data PROSTA;
set PROSTA;
	if PSA__1=0 then PSA__1=0.025;
	if PSA__2=0 then PSA__2=0.02;
run;

/* trasposizione di ETA a ETA-min(ETA) */
data PROSTA;
set PROSTA;
	ETA = ETA-41;
run;

/* creazione della variabile DIFF */
data PROSTA;
set PROSTA;
	DIFF = PSA__2 - PSA__1;
run;

/* creazione delle variabili MESE e GIORNO */
data PROSTA;
set PROSTA;
	MESE = month(DATINI);
	GIORNO = day(DATINI);
	ANNO = year(DATINI);
run;

/* creazione della variabile STAG (stagione) */
data PROSTA;
set PROSTA;
	attrib STAG format=$char10.;
	label STAG="stagione";
	if MESE=1 then STAG='inverno';
	if MESE=2 then STAG='inverno';
	if MESE=3 and GIORNO<21 then STAG='inverno';
	if MESE=3 and GIORNO>=21 then STAG='primavera';
	if MESE=4 then STAG='primavera';
	if MESE=5 then STAG='primavera';
	if MESE=6 and GIORNO<21 then STAG='primavera';
	if MESE=6 and GIORNO>=21 then STAG='estate';
	if MESE=7 then STAG='estate';
	if MESE=8 then STAG='estate';
	if MESE=9 and GIORNO<22 then STAG='estate';
	if MESE=9 and GIORNO>=22 then STAG='autunno';
	if MESE=10 then STAG='autunno';
	if MESE=11 then STAG='autunno';
	if MESE=12 and GIORNO<21 then STAG='autunno';
	if MESE=12 and GIORNO>=21 then STAG='inverno';
run;

/* creazione della variabile LPSA1 (trasformazione logaritmica della variabile risposta) */
data PROSTA;
set PROSTA;
	LPSA1 = log(PSA__1);
	LPSA2 = log(PSA__2);
	label LPSA1="log(PSA_basale)" LPSA2="log(PSA_finale)";
run;

/* creazione variabile ETA */
data PROSTA;
set PROSTA;
	ETA = year(DATINI)-year(DATNAS);
run;

/* creazione della variabile FASCETA */
data PROSTA;                                                                                                                                                                                                                                                    
set PROSTA;                                                                                                                                                                                                                                                    
	attrib FASCETA format=$char20.;
	label FASCETA="fascia d'eta'"; 
	if ETA<52 then FASCETA="eta<52";                                                                                                                                                                                                                                
	if 52<=ETA<57 then FASCETA="52<=eta<57";                                                                                                                                                                                                                        
	if 57<=ETA<61 then FASCETA="57<=eta<61";                                                                                                                                                                                                                        
	if ETA>=61 then FASCETA="61<=eta";                                                                                                                                                                                                                              
RUN; 

/* creazione variabile IPERTROFIA (categorica di IPEBEN) */
data PROSTA;
set PROSTA;
	attrib IPERTROFIA format=$char7.;
	label IPERTROFIA="ipertrofia";
	if IPEBEN=1 then IPERTROFIA="assente";
	if IPEBEN=2 then IPERTROFIA="lieve";
	if IPEBEN=3 then IPERTROFIA="severa";
run;



/* ANALISI DESCRITTIVE */

/* tabella di contingenza per trattamento */
proc FREQ data=PROSTA;
	tables TRATTA	/ nocum;
	title "distribuzione della tipologia di trattamento";
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
	vbox DIFF / category=TRATTA;
	title "distribuzione della differenza tra PSA_basale e PSA_finale per tipologia di trattamento";
run;

/* boxplot di LPSA1 e LPSA2 nei livelli di TRATTA */
proc SGPLOT data=PROSTA;
	vbox PSA__1	/ category=TRATTA;
	title "distribuzione di PSA_basale per tipologia di trattamento";
proc SGPLOT data=PROSTA;
	vbox PSA__2	/ category=TRATTA;
	title "distribuzione di PSA_finale per tipologia di trattamento";
run;

/* boxplot di PSA1 e PSA2 nei livelli di FASCETA */
proc SGPLOT DATA=PROSTA;
	vbox PSA__1	/	category=FASCETA;
	title "PSA_basale per fasce d'età";
run;
proc SGPLOT data=PROSTA;
	vbox PSA__2	/	category=FASCETA;
	title "PSA_finale per fasce d'età";
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
	vbox PSA__1	/ category=IPERTROFIA;
	title "distribuzione di PSA_basale per livello di ipertrofia";
run;
proc SGPLOT data=PROSTA;
	vbox PSA__2	/ category=IPERTROFIA;
	title "distribuzione di PSA_finale per livello di ipertrofia";
run;

/* boxplot di PSA1 e PSA2 nei livelli di STAG */
proc SGPLOT data=PROSTA;
	vbox PSA__1	/ category=STAG;
	title "distribuzione di PSA_basale per stagione di inizio del trattamento";
proc SGPLOT data=PROSTA;
	vbox PSA__2	/ category=STAG;
	title "distribuzione di PSA_finale per stagione di inizio del trattamento";
run;

/* boxplot di PSA1 e PSA2 nei livelli di ANNO */
proc SGPLOT data=PROSTA;
	vbox PSA__1	/ category=ANNO;
	title "distribuzione di PSA_basale per anno di inizio del trattamento";
proc SGPLOT data=PROSTA;
	title "distribuzione di PSA_finale per anno di inizio del trattamento";
	vbox PSA__2	/ category=ANNO;
run;



/* STUDIO ATTRAVERSO MODELLI LINEARI */

/* studio sulla normalità della varibaile risposta */
proc UNIVARIATE data=PROSTA;
var PSA__1 PSA__2 LPSA1 LPSA2;
	title "distribuzione di PSA";
	histogram PSA__1  / normal (sigma=est mu=est);
    qqplot PSA__1  / normal (sigma=est mu=est);
    histogram PSA__2  / normal (sigma=est mu=est);
    qqplot PSA__2 / normal (sigma=est mu=EST);
    histogram LPSA1  / normal (sigma=est mu=est);
    qqplot LPSA1  / normal (sigma=est mu=est);
    histogram LPSA2  / normal (sigma=est mu=est);
    qqplot LPSA2 / normal (sigma=est mu=est);
run;


/* modello completo con LPSA1 tra i predittori e valutazione ipotesi di normalità dell'errore  */
proc GENMOD data=PROSTA;
	class IPERTROFIA ANNO TRATTA STAG;
		model LPSA2 = ETA ANNO TRATTA IPERTROFIA LPSA1 STAG ANNO*STAG
		/ expected type1 type3;
	output out=risultati1 pred=pre stdreschi=res_st;
run;
proc UNIVARIATE data=RISULTATI1;
	var RES_ST;
	histogram RES_ST  / normal (sigma=EST mu=EST);
	qqplot res_st  / normal (sigma=EST mu=EST);
	title "distribuzione dei residui";
run;

/* modello completo con variabile risposta log(PSA2/PSA1) */
data PROSTA;
set PROSTA;
	LOGPSA12 = log(PSA__2/PSA__1);
run;
proc GENMOD data=PROSTA;
	class IPERTROFIA ANNO TRATTA STAG;
	model LOGPSA12 = TRATTA ANNO IPERTROFIA ETA STAG ANNO*STAG
		/ expected type1 type3;
	output out=risultati2 pred=pre stdreschi=res_st;
run;
proc UNIVARIATE data=RISULTATI2;
	var RES_ST;
	histogram RES_ST  / normal (sigma=est mu=est);
	qqplot RES_ST  / normal (sigma=est mu=est);
run;




/* VALUTAZIONE DEL CONFONDIMENTO */

/* modello di riferimento per i confronti: unico predittore TRATTA */
proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2 = TRATTA
		/ expected type1 type3;
run;

/* valutazione del confondimento operato dai predittori */
proc GENMOD data=PROSTA;
	class TRATTA ANNO;
	model LPSA2 = TRATTA ANNO
		/ expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA IPERTROFIA;
	model LPSA2 = TRATTA IPERTROFIA
		/ expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA STAG;
	model LPSA2 = TRATTA STAG
		/ expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2 = TRATTA ETA
		/ expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2 = TRATTA LPSA1
		/ expected type1 type3;
run;
 

/* modello di riferimento per i confronti: predittori TRATTA+LPSA1 */
proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2 = TRATTA LPSA1
		/ expected type1 type3;
run;
 
/* valutazione del confondimento operato dai predittori */
proc GENMOD data=PROSTA;
	class TRATTA ANNO;
	model LPSA2 = TRATTA LPSA1 ANNO
		/ expected type1 type3;
run;
 
proc GENMOD data=PROSTA;
	class TRATTA IPERTROFIA;
	model LPSA2 = TRATTA LPSA1 IPERTROFIA
		/ expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA STAG;
	model LPSA2 = TRATTA LPSA1 STAG
		/ expected type1 type3;
run;

proc GENMOD data=PROSTA;
	class TRATTA;
	model LPSA2 = TRATTA LPSA1 ETA
		/ expected type1 type3;
run;

/* confondimento di ANNO+STAG */
proc GENMOD data=PROSTA;
	class TRATTA STAG ANNO;
	model LPSA2 = TRATTA LPSA1 STAG ANNO
		/ expected type1 type3;
run;

/* confondimento di IPERTROFIA+ETA */
proc GENMOD data=PROSTA;
	class TRATTA IPERTROFIA;
	model LPSA2 = TRATTA LPSA1 IPERTROFIA ETA
		/ expected type1 type3;
run;

/* confondimento di ANNO+STAG+ANNO*STAG */
proc GENMOD data=PROSTA;
	class IPERTROFIA ANNO TRATTA STAG;
	model LPSA2 = IPERTROFIA ANNO TRATTA ETA LPSA1 STAG ANNO*STAG
	/ TYPE1 TYPE3;
run;

/* confondimento di ANNO+STAG+ETA */
proc GENMOD data=PROSTA;
	class ANNO TRATTA STAG;
	model LPSA2 = ANNO TRATTA ETA LPSA1 STAG
	/ TYPE1 TYPE3;
run;

