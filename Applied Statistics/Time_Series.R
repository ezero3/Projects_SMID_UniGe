#Arrivi e partenze totali in Australia all'estero - da marzo 2014 ad aprile 2024
library(readxl)
library(stats)
library(forecast)
library(tseries)
library(quadprog)
library(fracdiff)
library(ggplot2)

dataset <- read_excel("C:/Users/Utente/OneDrive/Desktop/Statistica Applicata 1/dataset_australia.xlsx",
                      col_types = c("text", "numeric", "numeric"))
View(dataset)

attach(dataset)

#GRAFICO DI CONFRONTO TRA LE DUE SERIE
datetime <- seq.POSIXt(c(ISOdate(2014,3,20)), by = "month", length.out = nrow(dataset))
dt <- data.frame(valore=c(Arrivi,Partenze), Leggenda = c(rep("Arrivi",122), rep("Partenze",122)), datetime=rep(datetime,2))
ggplot(data = dt, aes(x = datetime, y = valore, colour = Leggenda)) + 
  geom_line() +
  ggtitle("Grafico delle serie per Arrivi e Partenze") +
  xlab("Anno") + ylab("Arrivi/Partenze") +
  theme(legend.position = "bottom", legend.background = element_rect(fill = "white"),legend.title = element_blank())

#SERIE STORICA SUGLI ARRIVI

#ANALISI SERIE COMPLETA
Serie_Arrivi<-ts(Arrivi,frequency=12,start=c(2014,3))
is.ts(Serie_Arrivi)
plot.ts(Serie_Arrivi, main="Serie reale da Marzo 2014 ad Aprile 2024", cex.axis=0.7,
        xlab="Anno",ylab="Arrivi",col="green")
grid(nx = NULL, ny = NULL, col = "grey", lty = "dotted")

#1) ANALISI GRAFICA DELLA SERIE TEMPORALE PRIMA DEL COVID

Arrivi_pre<-ts(Arrivi,frequency=12,start=c(2014,3), end=c(2019,12))
is.ts(Arrivi_pre)
start(Arrivi_pre)
end(Arrivi_pre)
head(Arrivi_pre)
tail(Arrivi_pre)
summary(Arrivi_pre)
plot.ts(Arrivi_pre, main="Arrivi in Australia da Marzo 2014 a Dicembre 2019",cex.axis=0.7,
        xlab="Anno",ylab="Arrivi pre Covid",col="green")
grid(nx = NULL, ny = NULL, col = "grey", lty = "dotted")
lag.plot(Arrivi_pre,12,do.lines = F,diag = TRUE, diag.col = "green", main="Lagplot arrivi prima del covid")

#season plot
seasonplot(Arrivi_pre,12,col=rainbow(7), main="Season plot arrivi",
           xlab="Mese",ylab="Arrivi pre Covid")
legend(x=0,y=0, legend = c("2014", "2015", "2016", "2017", "2018", "2019"), 
       col = rainbow(7), lty = 1, cex = 0.4)

#2) TRASFORMAZIONE DELLA SERIE PRIMA DEL COVID ORIGINALE IN SERIE STAZIONARIA

#Stazionarietà di varianza 
lambda_arrivi_pre <- BoxCox.lambda(Arrivi_pre,lower=0)
lambda_arrivi_pre 
arrivi_pre_bc<-(Arrivi_pre^lambda_arrivi_pre-1) / lambda_arrivi_pre 
plot.ts(arrivi_pre_bc, main="Grafico sugli arrivi prima del covid stazionario in varianza",
        xlab="Anno",ylab="Arrivi pre Covid",col="green")
grid(nx = NULL, ny = NULL, col = "grey", lty = "dotted")

#Metodo delle differenze per individuare il trend
arrivi_pre_bcd<- diff(arrivi_pre_bc) 
plot.ts(arrivi_pre_bcd,main="Grafico stazionario degli arrivi",
        xlab="Anno",ylab="Arrivi pre Covid",col="green")
grid(nx = NULL, ny = NULL, col = "grey", lty = "dotted")
lag.plot(arrivi_pre_bcd, 16, do.lines = FALSE, main="Lag plot arrivi stazionari",diag = TRUE, diag.col = "green")

#Metodo delle differenze per trattare la stagionalità
arrivi_pre_bcd12<- diff(arrivi_pre_bcd, lag=12) 
plot.ts(arrivi_pre_bcd12,main="Componente erratica arrivi",
        xlab="Anno",ylab="Arrivi pre Covid",col="green")
grid(nx = NULL, ny = NULL, col = "grey", lty = "dotted")
lag.plot(arrivi_pre_bcd12, 12, layout = c(1,1), do.lines = FALSE,
         main="Lag plot arrivi senza stagionalità",diag = TRUE, diag.col = "green")

#3) ANALISI DELLA FUNZIONE DI AUTOCORRELAZIONE (ACF) E AUTOCORRELAZIONE PARZIALE (PACF) PRIMA DEL COVID

#acf
acf(Arrivi_pre,main="ACF Serie arrivi")
acf(arrivi_pre_bc,main="ACF Serie arrivi BocCox")
acf(arrivi_pre_bcd,main="ACF Serie arrivi differenze")
acf(arrivi_pre_bcd12,main="ACF Serie arrivi stazionaria")

#pacf
pacf(Arrivi_pre,main="PACF Serie arrivi")
pacf(arrivi_pre_bc,main="PACF Serie arrivi BocCox")
pacf(arrivi_pre_bcd,main="PACF Serie arrivi differenze")
pacf(arrivi_pre_bcd12,main="PACF Serie arrivi stazionaria")

#4) STIMA DEL MODELLO PRIMA DEL COVID

modello_arrivi_pre<-auto.arima(Arrivi_pre, trace = TRUE)
modello_arrivi_pre

modello_arrivi_pre_2<-arima(Arrivi_pre,order = c(0, 1, 2),seasonal = list(order = c(0, 1, 1), period = 12))
modello_arrivi_pre_2

modello_arrivi_pre_3<-arima(Arrivi_pre,order = c(0, 1, 1),seasonal = list(order = c(0, 1, 0), period = 12))
modello_arrivi_pre_3

#5) SCELTA E VERIFICA SULLA PRECISIONE DI APPROSIMAZIONE DEI MODELLI PRIMA DEL COVID

acf(modello_arrivi_pre$residuals,main="ACF residui arrivi") 
pacf(resid(modello_arrivi_pre),main="PACF residui arrivi",ylab="PACF") 
plot(resid(modello_arrivi_pre),xlab="Anno",ylab="Residui",col="green",
     main="Timeplot residui arrivi")
grid(nx = NULL, ny = NULL, col = "grey", lty = "dotted")
lag.plot(resid(modello_arrivi_pre),3,do.lines=FALSE)
#title(xlab = "Lag", ylab = "Residui")

acf(modello_arrivi_pre_3$residuals,main="ACF secondo Modello") 
pacf(resid(modello_arrivi_pre_3),main="PACF secondo Modello",ylab="PACF") 
plot(resid(modello_arrivi_pre_3),xlab="Anno",ylab="Residui",col="green",
     main="Timeplot redidui secondo modello arrivi")
grid(nx = NULL, ny = NULL, col = "grey", lty = "dotted")
lag.plot(resid(modello_arrivi_pre_3),3,do.lines=FALSE)

#6) PREDIZIONE ATTRAVERSO IL MODELLO PRIMA DEL COVID

plot(forecast(modello_arrivi_pre, h=52), main = "Predizione attraverso ARIMA(0,1,1)(0,1,1)[12]",
     col = "green",xlab = "Anno",ylab="Arrivi")
grid(nx = NULL, ny = NULL, col = "grey", lty = "dotted")

#SERIE STORICA SULLE PARTENZE

#ANALISI SERIE COMPLETA
Serie_Partenze<-ts(Partenze,frequency=12,start=c(2014,3))
is.ts(Serie_Partenze)
plot.ts(Serie_Partenze, main="Serie reale da Marzo 2014 ad Aprile 2024", cex.axis=0.7,
        ylab="Partenze",xlab="Anno",col="red")
grid(nx = NULL, ny = NULL, col = "darkgrey", lty = "dotted")


#1) ANALISI GRAFICA DELLA SERIE TEMPORALE PRIMA DEL COVID
Partenze_pre<-ts(Partenze,frequency=12,start=c(2014,3), end=c(2019,12))
is.ts(Partenze_pre)
start(Partenze_pre)
end(Partenze_pre)
head(Partenze_pre)
tail(Partenze_pre)
summary(Partenze_pre)
plot.ts(Partenze_pre, main="Partenze in Australia da Marzo 2014 a Dicembre 2019",cex.axis=0.7,
        ylab="Partenze pre covid",xlab="Anno",col="red")
grid(nx = NULL, ny = NULL, col = "darkgrey", lty = "dotted")
lag.plot(Partenze_pre,12,do.lines = F,diag = TRUE, diag.col = "green", main="Lag plot partenze prima del covid")

#season plot
seasonplot(Partenze_pre,12,col=rainbow(7), main="Season plot partenze",
           xlab="Mese",ylab="Partenze pre Covid")
legend(x=2,y=0.88, legend = c("2014", "2015", "2016", "2017", "2018", "2019"), 
       col = rainbow(7), lty = 1, cex = 0.5)

#2) TRASFORMAZIONE DELLA SERIE PRIMA DEL COVID ORIGINALE IN SERIE STAZIONARIA 

#Stazionarietà di varianza 
lambda_partenze_pre <- BoxCox.lambda(Partenze_pre,lower=0)
lambda_partenze_pre 
partenze_pre_bc<-(Partenze_pre^lambda_partenze_pre-1) / lambda_partenze_pre 
plot.ts(partenze_pre_bc, main="Grafico sulle partenze prima del covid stazionario in varianza",
        ylab="Partenze",xlab="Anno",col="red")
grid(nx = NULL, ny = NULL, col = "darkgrey", lty = "dotted")

#Metodo delle differenze per individuare il trend
partenze_pre_bcd<- diff(partenze_pre_bc) 
plot.ts(partenze_pre_bcd,main="Grafico stazionario delle partenze",
        ylab="Partenze pre covid",xlab="Anno",col="red")
grid(nx = NULL, ny = NULL, col = "darkgrey", lty = "dotted")
lag.plot(partenze_pre_bcd, 16, do.lines = FALSE, main="Lag plot partenze stazionarie",diag = TRUE, diag.col = "red")

#Metodo delle differenze per trattare la stagionalità
partenze_pre_bcd12<- diff(partenze_pre_bcd, lag=12) 
plot.ts(partenze_pre_bcd12,main="Componente erratica partenze",
        ylab="Partenze pre covid",xlab="Anno",col="red")
grid(nx = NULL, ny = NULL, col = "darkgrey", lty = "dotted")
lag.plot(partenze_pre_bcd12, lag=12 , layout=c(1,1), do.lines = FALSE, 
         main="Lag plot partenze senza stagionalità",diag = TRUE, diag.col = "green")

#3) ANALISI DELLA FUNZIONE DI AUTOCORRELAZIONE (ACF) E AUTOCORRELAZIONE PARZIALE (PACF) PRIMA DEL COVID

#acf
acf(Partenze_pre,main="ACF Serie Partenze")
acf(partenze_pre_bc,main="ACF Serie Partenze BocCox")
acf(partenze_pre_bcd,main="ACF Serie Partenze differenze")
acf(partenze_pre_bcd12,main="ACF Serie Partenze stazionaria")

#pacf
pacf(Partenze_pre,main="PACF Serie Partenze")
pacf(partenze_pre_bc,main="PACF Serie Partenze BocCox")
pacf(partenze_pre_bcd,main="PACF Serie Partenze differenze")
pacf(partenze_pre_bcd12,main="PACF Serie Partenze stazionaria")

#4) STIMA DEL MODELLO PRIMA DEL COVID

modello_partenze_pre<-auto.arima(Partenze_pre, trace = TRUE)
modello_partenze_pre

modello_partenze_pre_2<-arima(Partenze_pre,order = c(0, 1, 1),seasonal = list(order = c(1, 1, 0), period = 12))
modello_partenze_pre_2

modello_partenze_pre_3<-arima(Partenze_pre,order = c(0, 1, 1),seasonal = list(order = c(0, 1, 0), period = 12))
modello_partenze_pre_3

#5) SCELTA E VERIFICA SULLA PRECISIONE DI APPROSIMAZIONE DEI MODELLI PRIMA DEL COVID

acf(modello_partenze_pre$residuals,main="ACF residui partenze") 
pacf(resid(modello_partenze_pre),main="PACF residui partenze",
     ylab="PACF") 
plot(resid(modello_partenze_pre),main="Timeplot residui partenze",xlab="Anno",ylab="Residui",
     col="red")
grid(nx = NULL, ny = NULL, col = "darkgrey", lty = "dotted")
lag.plot(resid(modello_partenze_pre),3,do.lines=FALSE)

acf(modello_partenze_pre_3$residuals,main="ACF Residui secondo Modello Partenze")
pacf(resid(modello_partenze_pre_3),main="PACF Residui secondo Modello Partenze",
     ylab="PACF") 
plot(resid(modello_partenze_pre_3),main="Timeplot residui secondo modello partenze",xlab="Anno",ylab="Residui",
     col="red")
grid(nx = NULL, ny = NULL, col = "darkgrey", lty = "dotted")
lag.plot(resid(modello_partenze_pre_3),3,do.lines=FALSE)

#6) PREDIZIONE ATTRAVERSO IL MODELLO PRIMA DEL COVID

plot(forecast(modello_partenze_pre, h=52), main = "Predizione attraverso ARIMA(0,1,1)(0,1,1)[12]",
     col="red",xlab="Anno",ylab = "Partenze")
grid(nx = NULL, ny = NULL, col = "darkgrey", lty = "dotted")

#VEDIAMO SE SI STA TORNANDO A VIAGGIARE COME PRIMA

#L'andamento di arrivi e partenze nei primi mesi del 2024 sembra tornare simile a quello del 2017,
#questo ci suggerisce che i numeri dei viaggiatori stanno tornando come quelli prima del covid.
Arrivi[35:38]
Arrivi[119:122]
Partenze[35:38]
Partenze[119:122]

#E i dati del 2023? Confrontiamo i dati degli anni 2016/17 con quelli del 2023/24 per vedere
#se già nel 2023 si è tornati ad un andamento pre covid

#GRAFICO DI CONFRONTO ARRIVI 2016/17 2023/24
a_2016<-Arrivi[23:38]
a_2023<-Arrivi[107:122]
dati_a_2016 <- seq(from = as.Date("2016-01-01"), by = "month", length.out = length(a_2016))
dati_a_2023 <- seq(from = as.Date("2023-01-01"), by = "month", length.out = length(a_2023))
df_a_2016 <- data.frame(date = dati_a_2016, value = a_2016, period = "2016/*17", month = format(dati_a_2016, "%m"))
df_a_2023 <- data.frame(date = dati_a_2023, value = a_2023, period = "2023/*24", month = format(dati_a_2023, "%m"))
df_a_combined <- rbind(df_a_2016, df_a_2023)
df_a_combined$month_name <- factor(month.abb[as.integer(df_a_combined$month)], levels = month.abb)
levels(df_a_combined$month_name)<-c(levels(df_a_combined$month_name),"Jan*","Feb*","Mar*","Apr*")
df_a_combined$month_name[c(13,14,15,16,29,30,31,32)]<-c("Jan*","Feb*","Mar*","Apr*","Jan*","Feb*","Mar*","Apr*")
ggplot(df_a_combined, aes(x = month_name, y = value, color = period, group = period)) +
  geom_line() +
  geom_point() +
  labs(title = "Confronto arrivi 2016/17 e 2023/24",
       x = "Mese",
       y = "Arrivi",
       color = "Periodo") +
  theme_minimal()

#GRAFICO DI CONFRONTO PARTENZE 2016/17 2023/24
p_2016<-Partenze[23:38]
p_2023<-Partenze[107:122]
dati_p_2016 <- seq(from = as.Date("2016-01-01"), by = "month", length.out = length(p_2016))
dati_p_2023 <- seq(from = as.Date("2023-01-01"), by = "month", length.out = length(p_2023))
df_p_2016 <- data.frame(date = dati_p_2016, value = p_2016, period = "2016/*17", month = format(dati_p_2016, "%m"))
df_p_2023 <- data.frame(date = dati_p_2023, value = p_2023, period = "2023/*24", month = format(dati_p_2023, "%m"))
df_p_combined <- rbind(df_p_2016, df_p_2023)
df_p_combined$month_name <- factor(month.abb[as.integer(df_p_combined$month)], levels = month.abb)
levels(df_p_combined$month_name)<-c(levels(df_p_combined$month_name),"Jan*","Feb*","Mar*","Apr*")
df_p_combined$month_name[c(13,14,15,16,29,30,31,32)]<-c("Jan*","Feb*","Mar*","Apr*","Jan*","Feb*","Mar*","Apr*")
ggplot(df_p_combined, aes(x = month_name, y = value, color = period, group = period)) +
  geom_line() +
  geom_point() +
  labs(title = "Confronto partenze 2016/17 e 2023/24",
       x = "Mese",
       y = "Partenze",
       color = "Periodo") +
  theme_minimal()
#Da Maggio 2023 l'andamento sembra tornare come prima e nel 2024 sembra che i dati
#superino addirittura quelli del 2017

#VEDIAMO INVECE LA DIFFERENZA NEL 2024 SE NON CI FOSSE STATO IL COVID 

#ARRIVI
predizione_arrivi<-forecast(modello_arrivi_pre, h=52)
autoplot(predizione_arrivi) + autolayer(Serie_Arrivi, series = "Arrivi", color="green") +
  ggtitle("Predizione arrivi vs Serie reale") + ylab("Arrivi") + xlab("Anni") +
  theme_minimal()+
  scale_color_manual(values = c("green", "blue"), labels = c("Reali", "Predizione")) +
  theme(legend.position = "bottom")

#PARTENZE
predizione_partenze<-forecast(modello_partenze_pre, h=52)
autoplot(predizione_partenze) + autolayer(Serie_Partenze, series = "Partenze", color="red") +
  ggtitle("Predizione partenze vs Serie reale") + ylab("partenze") + xlab("Anni") +
  theme_minimal()+
  scale_color_manual(values = c("red", "blue"), labels = c("Reali", "Predizione")) +
  theme(legend.position = "bottom")

