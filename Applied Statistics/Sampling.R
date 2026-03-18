library(readxl)
library(sampling)


rm( list=ls() )

#CARICARE DATASET DA FILE EXCEL
dataset_gioco <- read_excel("C:/Users/Utente/OneDrive/Desktop/Statistica Applicata 1/dataset_applicata.xlsx",
                            col_types = c("text", "text", "numeric", "text", "numeric"))


attach(dataset_gioco)

table(Strato_Abitanti,Provincia)

#PARAMENTRO DI INTERESSE: TOTALE DI GIOCO_FISICO NELLA POPOLAZIONE
parametro<-sum(Giocato_Fisico)

set.seed(2345)

#CAMPIONAMENTO CASUALE SEMPLICE SENZA REINSERIMENTO
N<-length(Giocato_Fisico)
stime_parametro<-numeric(N)

#STIMO IL PARAMETRO CON TUTTE LE TAGLIE CAMPIONARIE POSSIBILI
for (i in 1:N) {
  campioni<-sample(Giocato_Fisico, size = i, replace = FALSE)
  stime_parametro[i]<-N*mean(campioni)
}

#GRAFICO CON TAGLIA CAMPIONARIA IN ASCISSA E STIMA DEL PARAMETRO IN ORDINATA
taglie_campionarie<-c(1:N)
plot(taglie_campionarie, stime_parametro, type = "l" ,
     xlab = "Dimensione campionaria", ylab = "Stima del parametro", 
     main = "Stima del Giocato fisico al variare della dimensione campionaria", sub = "(Usando un campionamento casuale semplice senza ripetizione)")
abline(h = parametro, col = "red", lty = 2)
abline(v=70, col = "green", lty = 1)
legend( x="topright", legend = c("valore reale","60"), lty = c(2,1), col = c("red","blue"))


#TAGLIA CAMPIONARIA SCELTA: 70
n<-70
s<-srswor(n,N)

#CAMPIONE
campione<-dataset_gioco[s==1,]

#STIMA
stima_totale<-N*mean(campione$Giocato_Fisico)

#INTERVALLO DI CONFIDENZA PER IL TOTALE
var_total<-N^2*var(campione$Giocato_Fisico)/n*(N-n)/(N-1)
sd_total<-sqrt(var_total)
IC_total<-c(stima_totale-qnorm(0.975)*sd_total,stima_totale+qnorm(0.975)*sd_total)


###STRATIFICAZIONE PER PROVINCIA
dataset_gioco<-dataset_gioco[order(Provincia),]

#VETTORE CON LE TAGLIE DI OGNI STRATO
st_prov<-table(Provincia)
n_st_prov<-as.vector(round(st_prov*n/N)) #vettore con le taglie campionarie di ogni strato
sum(round(st_prov*n/N)) # sommano a 70 ok

#CAMPIONE STRATIFICATO
campione_st_prov<-strata(dataset_gioco,c("Provincia"),size = n_st_prov, method = "srswor")
x<-getdata(dataset_gioco,campione_st_prov)
table(Provincia)
table(campione_st_prov$Provincia)

#MEDIA CAMPIONARIA DEGLI STRATI
media_strati_prov<-tapply(x$Giocato_Fisico,x$Provincia,mean)

#TOTALE CAMPIONARIO DI OGNI STRATO
total_strati_prov<-media_strati_prov*st_prov

#STIMA DEL TOTALE DELLA POPOLAZIONE
stima_tot_str_prov<-sum(total_strati_prov)
stima_tot_str_prov

var_strati_prov <- tapply(Giocato_Fisico, Provincia, var)

var_stimatore_strati_prov <- ((st_prov - n_st_prov) * (st_prov)^2 * var_strati_prov)/ (n_st_prov*(st_prov-1))

sd_stimatore_totale_prov <- sqrt(sum(var_stimatore_strati_prov))


###STRATIFICAZIONE PER ABITANTI
dataset_gioco<-dataset_gioco[order(Strato_Abitanti),]

#VETTORE CON LE TAGLIE DI OGNI STRATO
st_ab<-table(Strato_Abitanti)

nst_ab<-as.vector( round( st_ab*n/N ) )
nst_ab[2]=nst_ab[2]-1;

sum(nst_ab) # sommano a 70 ok

#CAMPIONE STRATIFICATO
campione_st_ab<-strata(dataset_gioco,c("Strato_Abitanti"),size = nst_ab, method = "srswor")
y<-getdata(dataset_gioco,campione_st_ab)
table(Strato_Abitanti)
table(campione_st_ab$Strato_Abitanti)

#MEDIA CAMPIONARIA DEGLI STRATI
media_strati_ab<-tapply(y$Giocato_Fisico,y$Strato_Abitanti,mean)

#TOTALE CAMPIONARIO DI OGNI STRATO
total_strati_ab<-media_strati_ab*st_ab

#STIMA DEL TOTALE DELLA POPOLAZIONE
stima_tot_str_ab<-sum(total_strati_ab)
stima_tot_str_ab

var_strati_ab <- tapply(Giocato_Fisico, Strato_Abitanti, var); var_strati_ab[5]=0

var_stimatore_strati_ab <- ((st_ab - nst_ab) * (st_ab)^2 * var_strati_ab)/ (nst_ab*(st_ab-1))

sd_stimatore_totale_ab <- sqrt(sum(var_stimatore_strati_ab))

stime <- c(parametro, stima_tot_str_prov, stima_tot_str_ab)
errori <- c(0, abs(parametro - stima_tot_str_prov), abs(parametro - stima_tot_str_ab))


###STRATIFICAZIONE PER ABITANTI CON ALLOCAZIONE OTTIMA DI NEYMAN
library(optimall)

ney<-optimum_allocation(data=dataset_gioco, strata="Strato_Abitanti", y="Giocato_Fisico",nsample=70,method = "WrightII")
campione_st_ab_ney<-strata(dataset_gioco,c("Strato_Abitanti"),size = ney$stratum_size, method = "srswor")
z<-getdata(dataset_gioco,campione_st_ab_ney)
table(Strato_Abitanti)
table(campione_st_ab_ney$Strato_Abitanti)

#MEDIA CAMPIONARIA DEGLI STRATI
media_strati_ab_ney <-tapply(z$Giocato_Fisico,z$Strato_Abitanti ,mean)

#TOTALE CAMPIONARIO DI OGNI STRATO
total_strati_ab_ney <- media_strati_ab_ney*st_ab

#STIMA DEL TOTALE DELLA POPOLAZIONE
stima_tot_str_ab_ney <-sum(total_strati_ab_ney)
stima_tot_str_ab_ney

var_stimatore_strati_ab_ney <- ((st_ab - ney$stratum_size) * st_ab * var_strati_ab)/ ney$stratum_size

sd_stimatore_totale_ab_ney <- sqrt(sum(var_stimatore_strati_ab_ney))


#BOOTSTRAP
vet<-dataset_gioco$Giocato_Fisico
NB<-10000
sum(vet) #totale vero

s<-sample(vet,n,replace = FALSE) #primo campione
N*mean(s) #stima del totale nel campione

bootstrap<-c(rep(0,NB))
for(i in 1:NB) bootstrap[i]<-N*mean(sample(vet,n,replace = TRUE))
mean(bootstrap) #totale stimato sui 10000 campioni bootstrap

hist(bootstrap)
abline(v = sum(vet), col = "red")
abline(v = N*mean(s), col = "green")
abline(v = mean(bootstrap), col = "blue")
legend(x="topright",
       legend = c("Totale vero", "Totale 1 campione",
                  "Totale Bootstrap"),
       col = c("red", "green", "blue"),
       lty = c(1, 1, 1))

#effetto del TLC sulla stima del parametri al variare della taglia campionaria
for (i in seq(50, 170, by = 10))
{
  bootstrap<-c(rep(0,NB))
  for(j in 1:NB) bootstrap[j]<-N*mean(sample(vet,i,replace = TRUE))
  hist(bootstrap)
  abline(v = sum(vet), col = "red")
  abline(v = mean(bootstrap), col = "blue")
}

