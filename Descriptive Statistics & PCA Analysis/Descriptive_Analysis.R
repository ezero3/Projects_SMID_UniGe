#Installazione del pacchetto da cui prendere i dati
setwd("C:/Users/Utente/AppData/Local/Temp/Rtmp4gWwZJ/downloaded_packages")
library(classifly)

#importo il data frame 'olives'
data("olives")

#Parte A - Analisi descrittiva preliminare

#Riscrivo il data frame con i valori della composizione in percentuale, essendo attualmente scritto in 10000esimi
olives[,3:10]= olives[,3:10]/100
colnames(olives)=c("Regione" , "Area" , "Acido palmitico" ,"Acido palmitoleico","Acido stearico","Acido oleico", "Acido linoleico","Acido linoleinico","Acido arachidico","Acido ecosenoico")
View(olives)

#calcolo le medie percentuali delle concentrazioni degli acidi nei diversi oli
mean(olives$`Acido palmitico`)
mean(olives$`Acido palmitoleico`)
mean(olives$`Acido stearico`)
mean(olives$`Acido oleico`)
mean(olives$`Acido linoleico`)
mean(olives$`Acido linoleinico`)
mean(olives$`Acido arachidico`)
mean(olives$`Acido ecosenoico`)

#VISUALIZZO QUANTE UNITA' PER REGIONI e AREE

table(olives$Regione)
table(olives$Area)

#Controllo i 5 numeri di Tukey della variabile acidi per vedere elementi significativi:

fivenum(olives$`Acido palmitico`)    # 6.10(Est-Liguria) 10.95 12.01 13.60 17.53 (Sud-Puglia)
fivenum(olives$`Acido palmitoleico`) # 0.150(primi 4 valori minori ceh sono 0,15 0,15 0,30 0,30 sono tutti Umbri) 0.875 1.100 1.695 2.800 (primi unidic valori più grandi tutti del Sud-Puglia)
fivenum(olives$`Acido stearico`)     # 1.52(è Sud-Puglia , primato per percentuale minore di acido stearico è Sud pugliese con anche qualche presenza umbra) 2.05 2.23 2.49 3.75 (Sicilia)
fivenum(olives$`Acido oleico`)       # 63.000(Sud-Puglia , tanta presenza sud pugliese) 70.000 73.025 76.800 84.100 (Est-Liguria)
fivenum(olives$`Acido linoleico`)    # 4.480 (Sicilia)  7.705 10.300 11.815 14.700(Sardegna costiera)
fivenum(olives$`Acido linoleinico`)   # 0.000 (Est-Liguria ed Ovest-Liguria molti oli presentano addiritura 0% di acido linolenico) 0.260 0.330 0.405 0.740 (Calabria)
fivenum(olives$`Acido arachidico`)   # 0.00 (Livìguria-Ovest , molti oli liguri ovest sono a 0%)  0.50 0.61 0.70 1.05(Centro Sardegna)
fivenum(olives$`Acido ecosenoico`)  # 0.01(Est Liguria) 0.02 0.17 0.28 0.58(Sicilia)

#Creo data frame per ogni regione/sottoregione
Calabria=subset(olives, Area=="Calabria")
SardegnaCostiera=subset(olives, Area=="Coast-Sardinia")
LiguriaLevante=subset(olives, Area=="East-Liguria")
CentroSardegna=subset(olives, Area=="Inland-Sardinia")
NordPuglia=subset(olives, Area=="North-Apulia")
LiguriaPonente=subset(olives, Area=="West-Liguria")
Umbria=subset(olives, Area=="Umbria")
SudPuglia=subset(olives, Area=="South-Apulia")
Sicilia=subset(olives, Area=="Sicily")

#Calcolo le medie percentuali della composizione degli oli per ciascuna regione
#per poi poterle confrontare con le medie totali

#Calabria
CAL=c() #creo vettore vuoto
for (i in 3:10)
{
  CAL[i-2]=mean(Calabria[,i]) #Riempo il vettore con la percentuale media di ogni componente
}

#RIPETO IL PROCEDIMENTO PER OGNI ZONA

#Coast_Sardinia
CS=c() 
for (i in 3:10)
{
  CS[i-2]=mean(SardegnaCostiera[,i]) 
}
#East-Liguria
EL=c() 
for (i in 3:10)
{
  EL[i-2]=mean(LiguriaLevante[,i])
}
#Inland-Sardinia
IS=c() 
for (i in 3:10)
{
  IS[i-2]=mean(CentroSardegna[,i])
}
#North-Apulia
NAP=c() 
for (i in 3:10)
{
  NAP[i-2]=mean(NordPuglia[,i])
}
#West-Liguria
WL=c() 
for (i in 3:10)
{
  WL[i-2]=mean(LiguriaPonente[,i])
}
#Umbria
UMB=c() 
for (i in 3:10)
{
  UMB[i-2]=mean(Umbria[,i])
}
#South-Apulia
SA=c()
for (i in 3:10)
{
  SA[i-2]=mean(SudPuglia[,i])
}

#Sicilia
SIC=c() 
for (i in 3:10)
{
  SIC[i-2]=mean(Sicilia[,i])
}

#Creo vettore con la media totale
MEDIA=c() 
for (i in 3:10)
{
  MEDIA[i-2]=mean(olives[,i])
}

#Creo il data frame contenente tutte le medie
TAB_MEDIE=as.matrix(cbind(MEDIA, CAL, NAP, SA, SIC, CS, IS, UMB, WL, EL))
rownames(TAB_MEDIE)=colnames(olives[,3:10])
colnames(TAB_MEDIE)=c("Media TOT","Calabria", "Nord Puglia", "Sud Puglia", "Sicilia", "Sardegna Costiera", "Centro Sardegna", "Umbria", "Liguria Ponente", "Liguria Levante")
View(TAB_MEDIE)

#Creo dei data frame più piccoli raggruppando regioni o sottoregioni dalle quali potrebbero scaturire osservazioni interessanti
SUD_ITALIA=TAB_MEDIE[,-c(6,7,8,9,10)]
SARDEGNA=TAB_MEDIE[,c(1,6,7)]
CENTRO_NORD=TAB_MEDIE[,c(1,8,9,10)]
ISOLE=TAB_MEDIE[,c(1,5,6,7)]
PUGLIA=TAB_MEDIE[,c(1,3,4)]
LIGURIA=TAB_MEDIE[,c(1,9,10)]
ITA_MERID=TAB_MEDIE[,-c(1,6,7,8,9,10)]
SARD=TAB_MEDIE[,-c(1,2,3,4,5,8,9,10)]
ITA_SETT_CENTR=TAB_MEDIE[,-c(1,2,3,4,5,6,7)]

#Italia meridionale

italia_meridionale = olives[-c(324:572),]      #creo la tabella togliendo le righe alla tabella principale 'olives'
italia_meridionale = italia_meridionale[-c(1)] #tolgo la colonna della regione   
View(italia_meridionale)                                  #Visualizzo la tabella

oliItaMerid = c() #creo vettore vuoto da riempire con le medie de3gli acidi per olio

for(i in 2:9)
{ oliItaMerid[i-1] = mean(italia_meridionale[,i])
}

Oli_Italia_Meridionale = as.matrix(oliItaMerid)           #creo matrice contenente la media degli oli dell'italia meridionale
colnames(Oli_Italia_Meridionale)="Oli-Italia-Meridionale"     #aggiungo nome colonne e righe
rownames(Oli_Italia_Meridionale)=colnames(olives[,3:10])
View(Oli_Italia_Meridionale)

#Procedo in egual modo con le altre aree geografiche
#Sardegna

sardegnaconregione = olives[-c(1:323 , 422:575),]
sardegna = sardegnaconregione[-c(1)]
View(sardegna)

oliSardegna = c()
for(i in 2:9)
{
  oliSardegna[i-1] = mean(sardegna[,i])
}

Oli_Sardegna = as.matrix(oliSardegna)
colnames(Oli_Sardegna)="Oli-Sardegna"
rownames(Oli_Sardegna)=colnames(olives[,3:10])
View(Oli_Sardegna)

#Italia settentrionale e centrale

italia_settentrionale_centrale = olives[-c(1:421),]
italia_settentrionale_centrale = italia_settentrionale_centrale[-c(1)]
View(italia_settentrionale_centrale)

OliItaSettCentr = c()
for(i in 2:9)
{
  OliItaSettCentr[i-1] = mean(italia_settentrionale_centrale[,i])
}

Oli_Italia_Settentrionale_Centrale  = as.matrix(OliItaSettCentr)
colnames(Oli_Italia_Settentrionale_Centrale)="Oli-Ita-Settentrionale&centrale"
rownames(Oli_Italia_Settentrionale_Centrale)=colnames(olives[,3:10])
View(Oli_Italia_Settentrionale_Centrale)


#METTO INSIEME LE TRE AREE

OLI_ITALIA=as.matrix(cbind(Oli_Italia_Meridionale,Oli_Sardegna,Oli_Italia_Settentrionale_Centrale))
View(OLI_ITALIA)

#DIFFERENZE

#Tabella contenente la differenza dalla media totale
DIFF=TAB_MEDIE[,-c(1)]-MEDIA
View(DIFF)
#Tabella contenente la differenza delle regioni o sottoregioni dalle 3 aree geografiche
DIFF_ITA_MERID=ITA_MERID-oliItaMerid
View(DIFF_ITA_MERID)

DIFF_ITA_CENTR_SETTR=ITA_SETT_CENTR-OliItaSettCentr
View(DIFF_ITA_CENTR_SETTR)

DIFF_SARDEGNA=SARD-oliSardegna
View(DIFF_SARDEGNA)

#Barplot composizione oli del Sud-Italia, paragonato alla media
palette(rainbow(8))
barplot(SUD_ITALIA, cex.axis = 1, cex.names = 0.75, beside = T, col = c(1:8), main = "Composizione oli Sud Italia", ylim = c(0, 100))
abline(h=0)
legend(y=101, x=35, cex = 0.55, legend = rownames(SUD_ITALIA), fill = (1:8))

#Barplot composizione oli del Centro-Nord Italia, paragonato alla media
palette(rainbow(8))
barplot(CENTRO_NORD, cex.axis = 1, cex.names = 0.75, beside = T, col = c(1:8), main = "Composizione oli centro e nord Italia", ylim = c(0,100))
abline(h=0)
legend(x=30, y=101, cex = 0.5, legend = rownames(SUD_ITALIA), fill = (1:8))

#Barplot composizione olio della Sardegna, paragonato alla media
palette(rainbow(8))
barplot(SARDEGNA, cex.axis = 1, cex.names = 0.75, beside = T, col = c(1:8), main = "Composizione oli della Sardegna", ylim = c(0,100))
abline(h=0)
legend("topright", cex = 0.55, legend = rownames(SUD_ITALIA), fill = (1:8))

#Barplot composizione olio delle Isole, paragonato alla media
palette(rainbow(8))
barplot(ISOLE, cex.axis = 1, cex.names = 0.65, beside = T, col = c(1:8), main = "Composizione oli delle isole italiane", ylim = c(0,100))
abline(h=0)
legend("topright", cex = 0.55, legend = rownames(SUD_ITALIA), fill = (1:8))

#Barplot composizione olio Puglia, paragonato alla media
palette(rainbow(8))
barplot(PUGLIA, cex.axis = 1, cex.names = 0.75, beside = T, col = c(1:8), main = "Composizione oli della Puglia", ylim = c(0,100))
abline(h=0)
legend("topright", cex = 0.65, legend = rownames(SUD_ITALIA), fill = (1:8))

#Barplot composizione olio Liguria, paragonato alla media
palette(rainbow(8))
barplot(LIGURIA, cex.axis = 1, cex.names = 0.75, beside = T, col = c(1:8), main = "Composizione oli Liguria", ylim = c(0,100))
abline(h=0)
legend("topleft", cex = 0.5, legend = rownames(SUD_ITALIA), fill = (1:8))

#Barplot della differenza dalla composizione media degli oli delle singole regioni
palette(rainbow(8))
for (i in 1:9) {
  barplot(DIFF[,i], cex.axis = 1, beside = T, col = c(1:8), main=colnames(DIFF)[i], ylim = c(-6,6))
  abline(h=0)
  legend("topright" , cex=0.75 , legend=rownames(TAB_MEDIE), fill=(1:8))
}

palette(rainbow(9))
for (i in 1:9) {
  barplot(t(DIFF[i,]), cex.axis = 1,cex.names = 0.3 ,beside = T, col = c(1:9), main=rownames(DIFF)[i], ylim = c(-3,2))
  abline(h=0)
  legend("topright" , cex=0.65 , legend=colnames(DIFF), fill=(1:9))
}

#NOTA BENE : il comando sopra lo ho utilizzato per creare tutti i  barplot per osservare meglio il comportamento dellgli acidi nella relazione ho modificato "ylim" e "abline" in modo da vedere meglio i dati, come ad esempio: 


for (i in 1:8) {
  barplot(t(OLI_ITALIA[i,]), cex.axis = 1,cex.names = 0.75 ,beside = T, col = c("green","blue","yellow"), main=rownames(DIFF)[i], ylim = c(0,15))
  abline(h=0)
  legend("topright" , cex=1 , legend=colnames(OLI_ITALIA), fill=c("green","blue","yellow"))
}

#NOTA BENE : il comando sopra lo ho utilizzato per creare tutti i  barplot per osservare meglio il comportamento dellgli acidi nella relazione ho modificato "ylim" in modo da vedere meglio i dati, come ad esempio: 
#for (i in 1:8) {
# barplot(t(OLI_ITALIA[i,]), cex.axis = 1,cex.names = 0.75 ,beside = T, col = c("red","orange","yellow"), main=rownames(DIFF)[i], ylim = c(0,2))
#abline(h=0)
#legend("topright" , cex=1 , legend=colnames(OLI_ITALIA), fill=c("red","orange","yellow"))
#}

#BOXPLOT della concentrazione degli acidi rispetto alle regioni, per individuare possibili legami
for(i in 3:10)
{
  boxplot(olives[,i]~olives$Region,ylab = " " , xlab = "Regione",col=c("green","blue","red","orange") ,main = paste(colnames(olives)[i], "rispetto alle regioni"))
}

#BOXPLOT della concentrazione degli acidi rispetto alle aree, per individuare possibili legami
for(i in 3:10)
{
  palette(rainbow(9))
  boxplot(olives[,i]~olives$Area, xlab="AREA" , ylab = " " ,main = paste(colnames(olives)[i], "rispetto all'area"),cex.axis = 0.3, cex.names = 0.5,col=c(1:9))
}

#Indice di correlazione lineare
library(corrplot)
IND_COR=cor(olives[-c(1,2)])
corrplot(IND_COR) #matrice degli indici di correlazione lineare
corrplot(IND_COR , method  = "number")



#Parte B - Cluster Analysis

###CLUSTER ANALYSIS DELLE VARIABILI###


#STANDARDIZZAZIONE VARIABILI
olives_ST= cbind(olives[,1:2], scale(olives[,-c(1:2)]))
View(olives_ST)

#IMPOSTO DISTANZA DA UTILIZZARE: 1-rho^2
dist_VAR = 1-cor(olives_ST[,-c(1:2)])^2

#METODO DEL WARD LINKAGE
aggregazione_variabili = hclust(as.dist(dist_VAR), method = "ward.D")

aggregazione_variabili$merge
aggregazione_variabili$height
aggregazione_variabili$order
aggregazione_variabili$labels
aggregazione_variabili$method
aggregazione_variabili$call
aggregazione_variabili$dist.method

#dendrogramma
plot(aggregazione_variabili, xlab = " ", ylab = " ", sub = " ", hang = -0.1, frame.plot = T, main = "1-rho^2 - Ward linkage")

#dendrogramma tagliato a 3 cluster
n_clust = 3
rect.hclust(aggregazione_variabili, k=n_clust, border = "red")
gruppi_var = cutree(aggregazione_variabili, k=n_clust)
gruppi_var

#Calcolo distanza media e massima interna e inerzia media interna
dist_int_medie=c(1:n_clust); dist_int_max=c(1:n_clust); inerzie_int_med=c(1:n_clust)
for (i in 1:n_clust)
{
  a=rowSums(scale(olives_ST[,-c(1:2)][gruppi_var==i,],scale=F)^2)
  dist_int_medie[i]=mean(sqrt(a))
  dist_int_max[i]=max(sqrt(a))
  inerzie_int_med[i]=mean(a)
}

compattezza= cbind(table(gruppi_var), dist_int_medie,dist_int_max,inerzie_int_med)
colnames(compattezza)[1]="n"
round(compattezza,2)


inerzia_tot= (dim(olives_ST[,-c(1:2)])[1]-1)*dim(olives_ST[,-c(1:2)])[2]
inerzia_int= sum(inerzie_int_med*table(gruppi_var))
percent_inerzia_fra=round((inerzia_tot-inerzia_int)/inerzia_tot*100,2)
percent_inerzia_fra

#METODO DEL COMPLETE LINKAGE
aggregazione_var2 = hclust(as.dist(dist_VAR), method = "complete")

plot(aggregazione_var2, xlab = " ", ylab = " ", sub = " ", hang = -0.1, frame.plot = T, main = "1-rho^2 - Complete linkage")

gruppi_var2 = cutree(aggregazione_var2, k=3)
gruppi_var2

#METODO DELL'AVERAGE LINKAGE
aggregazione_var3 = hclust(as.dist(dist_VAR), method = "average")

plot(aggregazione_var3, xlab = " ", ylab = " ", sub = " ", hang = -0.1, frame.plot = T, main = "1-rho^2 - Average linkage")

gruppi_var3 = cutree(aggregazione_var3, k=3)
gruppi_var3

#METODO DEL SINGLE LINKAGE
aggregazione_var4 = hclust(as.dist(dist_VAR), method = "single")

plot(aggregazione_var4, xlab = " ", ylab = " ", sub = " ", hang = -0.1, frame.plot = T, main = "1-rho^2 - Single linkage")

gruppi_var4 = cutree(aggregazione_var4, k=3)
gruppi_var4

###CLUSTER ANALYSIS UNITA' SPERIMENTALI###

#Definisco il tipo di distanza da utilizzare
dist_euc_us = dist(olives_ST[,-c(1:2)], method = "euclidean")


#WARD-EUCLIDEAN


#Definiamo il metodo di aggregazione e con la funzione plot creiamo il dendogramma
aggr_us_ward = hclust(dist_euc_us, method = "ward.D")
plot(aggr_us_ward, hang = -0.1, frame.plot = TRUE, labels = FALSE, xlab = "unità sperimentali", ylab="Inerzia" , main="Ward unità sperimentali")

#impostiamo il numero di cluster in cui vogliamo tagliare il nostro dendogramma
num_cluster = 5
rect.hclust(aggr_us_ward, num_cluster, border = "red")

#Visualizziamo numerosità dei cluster
gruppi_euc_ward = cutree(aggr_us_ward, num_cluster)
table(gruppi_euc_ward)

#Calcoliamo i baricentri e creiamo il data frame contenente i baricentri di tutti gli acidi per ciascun cluster
baricentri = by(olives_ST[,-c(1:2)], gruppi_euc_ward, colMeans) #Baricentri
BAR = colMeans(olives_ST[gruppi_euc_ward==1, -c(1:2)])
for (i in 2:num_cluster) {
  BAR = rbind(BAR, colMeans(olives_ST[gruppi_euc_ward==i, -c(1:2)]))
}

rownames(BAR)=rownames(table(gruppi_euc_ward))
round(BAR,3)
View(BAR)

#Calcoliamo distanza interna media, massima e inerzia interna media
d_int_medie=c(1:num_cluster); d_int_max=c(1:num_cluster); inerz_int_med=c(1:num_cluster)
for (i in 1:num_cluster)
{
  b=rowSums(scale(olives_ST[,-c(1:2)][gruppi_euc_ward==i,],scale=F)^2)
  d_int_medie[i]=mean(sqrt(b))
  d_int_max[i]=max(sqrt(b))
  inerz_int_med[i]=mean(b)
}

#Data frame con i dati appena calcolati per ciascun cluster
compatt_gruppi= cbind(table(gruppi_euc_ward), d_int_medie,d_int_max,inerz_int_med)
colnames(compatt_gruppi)[1]="n"
round(compatt_gruppi,2)

#Calcoliamo inerzia totale, l'inerzia interna e il rapporto tra inerzia fra classi e inerzia totale
inerz_tot= (dim(olives_ST[,-c(1:2)])[1]-1)*dim(olives_ST[,-c(1:2)])[2]
inerz_int= sum(inerz_int_med*table(gruppi_euc_ward))
percent_inerz_fra=round((inerz_tot-inerz_int)/inerz_tot*100,2)
percent_inerz_fra

#Dopo aver verificato che il metodo di aggregazione scelto sia il più efficace, analizziamo i cluster che si sono formati
olives$clust = ifelse(gruppi_euc_ward == 1, 1, ifelse(gruppi_euc_ward==2, 2, ifelse(gruppi_euc_ward == 3, 3, ifelse(gruppi_euc_ward == 4, 4, ifelse(gruppi_euc_ward == 5, 5, "other")))))
clust_1 = subset(olives, clust== 1)
clust_2 = subset(olives, clust== 2)
clust_3 = subset(olives, clust== 3)
clust_4 = subset(olives, clust== 4)
clust_5 = subset(olives, clust== 5)

#Osservo quante unità sperimentali ci sono per ciascun cluster per ciascuna regione
table(clust_1$Region)
table(clust_2$Region)
table(clust_3$Region)
table(clust_4$Region)
table(clust_5$Region)

#Osservo quante unità sperimentali ci sono per ciascun cluster per ciascuna Area
table(clust_1$Area)
table(clust_2$Area)
table(clust_3$Area)
table(clust_4$Area)
table(clust_5$Area)

#single-euclidean
aggr_us_sing<-hclust(dist_euc_us, method = "single")
plot(aggr_us_sing,hang = -0.1,frame.plot = TRUE, labels = FALSE)

#complete-euclidean
aggr_us_comp<-hclust(dist_euc_us, method = "complete")
plot(aggr_us_comp,hang = -0.1,frame.plot = TRUE, labels = FALSE)

num_cluster = 5

gruppi_euc_comp = cutree(aggr_us_comp, k = num_cluster)
table(gruppi_euc_comp)

baricentri = by(olives_ST[,-c(1:2)], gruppi_euc_comp, colMeans) #Baricentri
BAR = colMeans(olives_ST[gruppi_euc_comp==1, -c(1:2)])
for (i in 2:num_cluster) {
  BAR = rbind(BAR, colMeans(olives_ST[gruppi_euc_comp==i, -c(1:2)]))
}

rownames(BAR)=rownames(table(gruppi_euc_comp))
round(BAR,3)

rect.hclust(aggr_us_comp, k = num_cluster, border = "red")

d_int_medie=c(1:num_cluster); d_int_max=c(1:num_cluster); inerz_int_med=c(1:num_cluster)
for (i in 1:num_cluster)
{
  b=rowSums(scale(olives_ST[,-c(1:2)][gruppi_euc_comp==i,],scale=F)^2)
  d_int_medie[i]=mean(sqrt(b))
  d_int_max[i]=max(sqrt(b))
  inerz_int_med[i]=mean(b)
}

compatt_gruppi= cbind(table(gruppi_euc_comp), d_int_medie,d_int_max,inerz_int_med)
colnames(compatt_gruppi)[1]="n"
round(compatt_gruppi,2)


inerz_tot= (dim(olives_ST[,-c(1:2)])[1]-1)*dim(olives_ST[,-c(1:2)])[2]
inerz_int= sum(inerz_int_med*table(gruppi_euc_comp))
percent_inerz_fra=round((inerz_tot-inerz_int)/inerz_tot*100,2)
percent_inerz_fra

#centroid-euclidean
aggr_us_cent<-hclust(dist_euc_us, method = "centroid")
plot(aggr_us_cent,hang = -0.1,frame.plot = TRUE, labels = FALSE)

#average-euclidean

aggr_us_ave<-hclust(dist_euc_us, method = "average")
plot(aggr_us_ave,hang = -0.1,frame.plot = TRUE, labels = FALSE)


#Definisco il secondo tipo di distanza da utilizzare
d_man_us = dist(olives_ST[,-c(1:2)], method = "manhattan")

#ward-manhattan
aggr_us_man_ward<-hclust(d_man_us, method = "ward.D")
plot(aggr_us_man_ward,hang = -0.1,frame.plot = TRUE, labels = FALSE)

#single-manhattan
aggr_us_man_sing<-hclust(d_man_us, method = "single")
plot(aggr_us_man_sing,hang = -0.1,frame.plot = TRUE, labels = FALSE)

#complete-manhattan
aggr_us_man_comp<-hclust(d_man_us, method = "complete")
plot(aggr_us_man_comp,hang = -0.1,frame.plot = TRUE, labels = FALSE)

#centroid-manhattan
aggr_us_man_cent<-hclust(d_man_us, method = "centroid")
plot(aggr_us_man_cent,hang = -0.1,frame.plot = TRUE, labels = FALSE)

#average-manhattan
aggr_us_man_ave = hclust(d_man_us, method = "average")
plot(aggr_us_man_ave,hang = -0.1,frame.plot = TRUE, labels = FALSE)
