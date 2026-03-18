setwd("C:/Users/Utente/AppData/Local/Temp/Rtmp4gWwZJ/downloaded_packages")
library(classifly)
data("olives")
olives[,3:10]= olives[,3:10]/100

#Standardizzo la tabella olives
olives_ST= cbind(olives[,1:2], scale(olives[,-c(1:2)])) 
View(olives_ST)

#matrice degli indici di correlazione lineare
library(corrplot)
IND_COR=cor(olives[-c(1,2)])
corrplot(IND_COR , method  = "number")

levels(olives$Area)

#PCA

#Creo tabella delle componenti 
pca_olives=princomp(olives_ST[,3:10], cor=T)
pca_olives

#Visualizzo per ogni componente : Standard Deviation , Percentuale di Varianza e
#Frequenza percentuale cumulata della varianza
summary(pca_olives)


pca_olives$sdev       #standard deviation
pca_olives$loadings   #Fornisce due tabelle nella prima sono presenti gli autovettori
                      #della matrice di correlazione , la seconda di poco interesse 
                      #in quanto le variabili sono standardizzate e gli autovettori 
                      # sono normalizzati
pca_olives$center     #Medie delle variabili originali
pca_olives$scaleb     #standard deviation delle variabili originali
pca_olives$scores     #Componenti principali


#Altro modo per ottenere valori arrotondati alla terza cifra decimale

Var_olives=pca_olives$sdev^2 #Varianza ogni componente
percVar_olives=Var_olives/sum(Var_olives) #Pecentuale varianza
TabArr=rbind(pca_olives$sdev,Var_olives,percVar_olives,
             cumsum(percVar_olives))
rownames(TabArr)=c("Standard deviation" , "Varianza" , "Proporzione della Varianza" , "Varianza cumulata")
TabArr = round(TabArr,3)
View(TabArr)

#Diagramma a barre delle varianze delle componenti principali
plot(pca_olives, main="Varianza componenti principali" , 
     col=c("green" ,"red","yellow","blue", "pink","orange","white", "black"),
     ylim=c(0,4),cex.names=0.5)
abline(h=0)
abline(h=1)
 

#Costruzione della matrice contenente le correlazioni fra variabili originali
#e componenti principali e del grafico delle variabili

R=pca_olives$loadings%*%diag(pca_olives$sdev) 
R = round(R,3)
R

#Osservando la matrice delle corellazioni tra le variabili originali e le
#componenti principali , si osservano le righe con valori più alti 
#in modulo assoluto, la prima ,la seconda e la terza componente presentano 
#i valori più alti

#Considero queste tre componenti : la prima, la seconda e la terza

#Grafico delle variabili a coppie di componenti:

#Prima con seconda :
plot(R[,1],R[,2],xlim=c(-1,1),ylim=c(-1,1),asp=1,xlab="primo asse", 
     ylab="secondo asse",main="Grafico delle variabili")
abline(h=0,v=0)
symbols(0, 0,circles= 1,inches =F,add=T)
text(R[,1],R[,2], pos=1,labels=colnames(olives_ST[-c(1,2)]),cex=0.8)
symbols(0,0,circles=0.8,inches=F,fg="red",add=T)
#Visualizzo Fedelta prima e seconda componente
Fedelta_olives_12=sqrt(R[,1]^2+R[,2]^2 ); Fedelta_olives_12

#Prima con terza:
plot(R[,1],R[,3],xlim=c(-1,1),ylim=c(-1,1),asp=1,xlab="primo asse",
     ylab="terzo asse",main="Grafico delle variabili")
abline(h=0,v=0)
symbols(0, 0,circles= 1,inches =F,add=T)
text(R[,1],R[,3], pos=4,labels=colnames(olives_ST[-c(1,2)]),cex=0.8)
symbols(0,0,circles=0.8,inches=F,fg="red",add=T)
#Visualizzo Fedelta prima e terza componente
Fedelta_olives_13=sqrt(R[,1]^2+R[,3]^2) ; Fedelta_olives_13

#Seconda con terza:
plot(R[,2],R[,3],xlim=c(-1,1),ylim=c(-1,1),asp=1,xlab="secondo asse", 
     ylab="terzo asse",main="Grafico delle variabili")
abline(h=0,v=0)
symbols(0, 0,circles= 1,inches =F,add=T)
text(R[,2],R[,3], pos=1,labels=colnames(olives_ST[-c(1,2)]),cex=0.8)
symbols(0,0,circles=0.8,inches=F,fg="red",add=T)
#Visualizzo Fedelta seconda e terza componente
Fedelta_olives_23=sqrt(R[,2]^2+R[,3]^2) ; Fedelta_olives_23

#Grafici unità sperimentali per Regione

#Prima e seconda componente :
plot(pca_olives$scores[,1],pca_olives$scores[,2], xlab="prima componente", 
     ylab="seconda componente",pch=c(15,16,17)[olives$Region],
     col=c("red", "blue","darkgreen")[olives$Region],cex=0.65,
     main="Grafico delle unità sperimentali per Regioni")
abline(h=0,v=0)
legend("bottomleft",legend=c("Sud","sardegna","Centro-Nord"),pch=c(15,16,17),
       cex=0.75,col=c("red","blue","darkgreen"))

#Prima e terza componente :
plot(pca_olives$scores[,1],pca_olives$scores[,3], xlab="prima componente", 
     ylab="terza componente",pch=c(15,16,17)[olives$Region],
     col=c("red", "blue","darkgreen")[olives$Region],cex=0.65,
     main="Grafico delle unità sperimentali per Regioni")
abline(h=0,v=0)
legend("bottomright",legend=c("Sud","sardegna","Centro-Nord"),pch=c(15,16,17),
       cex=0.75,col=c("red","blue","darkgreen"))

#Seconda e terza componente :

plot(pca_olives$scores[,2],pca_olives$scores[,3], xlab="seconda componente", 
     ylab="terza componente",pch=c(15,16,17)[olives$Region],
     col=c("red", "blue","darkgreen")[olives$Region],cex=0.65,
     main="Grafico delle unità sperimentali per Area")
abline(h=0,v=0)
legend("bottomright",legend=c("Sud","sardegna","Centro-Nord"),pch=c(15,16,17),
       cex=0.75,col=c("red","blue","darkgreen"))

#Grafici delle unità sperimentali per Area e Regioni

#Prima e seconda componente :
plot(pca_olives$scores[,1],pca_olives$scores[,2], xlab="prima componente", ylab="seconda componente",
     pch=c(15,16,17)[olives$Region],col=c("yellow","orange","red","forestgreen","chartreuse2","blue3","purple","cyan4","cyan")[olives$Area],
     cex=0.65,main="Grafico delle unità sperimentali: prima e seconda componente",cex.main=0.75)
abline(h=0,v=0)
legend("bottomleft",legend=c("Calabria", "Sardegna Costiera","Liguria Levante" ,"Sardegna Interna" , "Nord Puglia", "Sicilia", "Sud Puglia" , "Umbria", "Liguria Ponente"),
       fill =c("yellow","orange","red","forestgreen","chartreuse2","blue3","purple","cyan4","cyan"),
       cex = 0.5)
legend("bottomright", pch=c(15,16,17), cex = 1, legend=c("Sud","Sardegna","Centro-Nord"))

#Seconda e terza componente :
plot(pca_olives$scores[,2],pca_olives$scores[,3], xlab="seconda componente", ylab="terza componente",
     pch=c(15,16,17)[olives$Region],col=c("yellow","orange","red","forestgreen","chartreuse2","blue3","purple","cyan4","cyan")[olives$Area],
     cex=0.65,main="Grafico delle unità sperimentali: seconda e terza componente",cex.main=0.75)
abline(h=0,v=0)
legend("bottomright",legend=c("Calabria", "Sardegna Costiera","Liguria Levante" ,"Sardegna Interna" , "Nord Puglia", "Sicilia", "Sud Puglia" , "Umbria", "Liguria Ponente")
       ,fill=c("yellow","orange","red","forestgreen","chartreuse2","blue3","purple","cyan4","cyan"),
       cex = 0.5)
legend("bottomleft", pch=c(15,16,17), cex = 0.75, legend=c("Sud","Sardegna","Centro-Nord"))

#Prima e terza componente :
plot(pca_olives$scores[,1],pca_olives$scores[,3], xlab="prima componente", ylab="terza componente",pch=c(15,16,17)[olives$Region],
     col=c("yellow","orange","red","forestgreen","chartreuse2","blue3","purple","cyan4","cyan")[olives$Area],
     cex=0.65,main="Grafico delle unità sperimentali: prima e terza componente",cex.main=0.75)
abline(h=0,v=0)
legend("bottomleft",legend=c("Calabria", "Sardegna Costiera","Liguria Levante" ,"Sardegna Interna" , "Nord Puglia", "Sicilia", "Sud Puglia" , "Umbria", "Liguria Ponente"),
       fill=c("yellow","orange","red","forestgreen","chartreuse2","blue3","purple","cyan4","cyan"),
       cex = 0.5)
legend("bottomright", pch=c(15,16,17), cex = 0.75, legend=c("Sud","Sardegna","Centro-Nord"))

#CONFRONTO CLUSTER ANALYSIS

#distanza euclidea

d_eu_us<-dist(olives_ST[-c(1,2)], method = "euclidean")

#metodo di ward

aggr_us_eu_ward<-hclust(d_eu_us, method = "ward.D")
num_clust_eu_ward=5 #scelgo di tagliare a 5 cluster
gruppi_eu_ward<-cutree(aggr_us_eu_ward, k=num_clust_eu_ward)  #creo i 5 cluster

#Grafico di dispersione delle unità sperimentali rispetto alla cluster di appartenenza

plot(pca_olives$scores[,1], pca_olives$scores[,2], xlab = "prima componente", ylab = "seconda componente",
     main = "Grafico unità sperimentali" , col=c("red", "purple" ,"darkgreen", "blue","orange")[gruppi_eu_ward])
abline(h=0, v=0)
legend("bottomleft", legend = c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4","Cluster 5")
       , fill =c("red", "purple" ,"darkgreen", "blue", "orange"), cex = 0.7)

#Prima e terza componente

plot(pca_olives$scores[,1], pca_olives$scores[,3], xlab = "prima componente", ylab = "terza componente",
     main = "Grafico unità sperimentali" , col=c("red", "purple" ,"darkgreen", "blue","orange")[gruppi_eu_ward])
abline(h=0, v=0)
legend("bottomleft", legend = c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4","Cluster 5")
       , fill =c("red", "purple" ,"darkgreen", "blue","orange"), cex = 0.7)

#Seconda e terza componente

plot(pca_olives$scores[,2], pca_olives$scores[,3], xlab = "seconda componente", ylab = "terza componente",
     main = "Grafico unità sperimentali" , col=c("red", "purple" ,"darkgreen", "blue","orange")[gruppi_eu_ward])
abline(h=0, v=0)
legend("bottomleft", legend = c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4","Cluster 5")
       , fill =c("red", "purple" ,"darkgreen", "blue","orange"), cex = 0.7)



