--- Progetto BD 23-24 (8CFU)
--- Grupppo 37
--- Davide Osimani 5300736, Matteo Montisci 5619902 ,Edoardo Zero 5617021

--- PARTE 2 
/* il file deve essere file SQL ... cio formato solo testo e apribili ed eseguibili in pgAdmin */

/*************************************************************************************************************************************************************************/
--1a. Schema
/*************************************************************************************************************************************************************************/ 

CREATE schema UnigeSocialSport;
set search_path to UnigeSocialSport;

create table Utente 
	(Id_utente VARCHAR(15) PRIMARY KEY,
	 Nome VARCHAR(15) NOT NULL,
	 Cognome VARCHAR(15) NOT NULL,
	 Matricola NUMERIC(7) NOT NULL,
	 LuogoN VARCHAR(20) NOT NULL,
	 AnnoN NUMERIC(4) NOT NULL,
	 Tel_utente NUMERIC(10) NOT NULL,
	 Foto_utente VARCHAR(30) NOT NULL,
	 CdS VARCHAR(30) NOT NULL,
	 Pw VARCHAR(15) NOT NULL,
	 Inaffidabile BOOLEAN,
	 Tipo_utente VARCHAR(10) CHECK (Tipo_utente IN ('Giocatore','Arbitro')),
	 Premium BOOlEAN NOT NULL,
	 UNIQUE(Matricola));
	 
create table Categoria
	(Nome_sport VARCHAR(30) PRIMARY KEY,
	 Foto_sport VARCHAR(30) NOT NULL,
	 N_giocatori DECIMAL(2) NOT NULL,
	 Regolamento VARCHAR NOT NULL,
	 UNIQUE(Regolamento));
	 
create table Impianto
	(Nome_impianto VARCHAR(30) PRIMARY KEY,
	 Via VARCHAR(30) NOT NULL,
	 Email VARCHAR(30) UNIQUE NOT NULL,
	 Tel_impianto NUMERIC(10) UNIQUE NOT NULL,
	 Long VARCHAR(15) NOT NULL,
	 Lat VARCHAR(15) NOT NULL,
	 UNIQUE(Long,Lat));

create table Torneo
	(Descrizione VARCHAR PRIMARY KEY,
	 Nome_sport VARCHAR(30) NOT NULL REFERENCES Categoria
	 						         ON DELETE CASCADE 
	 						         ON UPDATE CASCADE,
	 Tipo_torneo VARCHAR(10) NOT NULL
	 						 CHECK (Tipo_torneo IN ('Singolo', 'A squadre')),
	 Organizzatore VARCHAR(15) NOT NULL REFERENCES Utente
	 									ON DELETE CASCADE
	 									ON UPDATE CASCADE);
	 	 
create table Evento 
	(Id_evento VARCHAR(15),
	 Nome_sport VARCHAR(30) REFERENCES Categoria
	 						ON DELETE CASCADE 
	 						ON UPDATE CASCADE,
	 Data_evento DATE NOT NULL,
	 Tempo_limite DATE NOT NULL
	 				CHECK (Tempo_limite <= Data_evento),
	 Arbitro BOOLEAN NOT NULL,
	 N_giocatori NUMERIC(2),
	 Stato_evento VARCHAR(10) NOT NULL
	 			  CHECK (Stato_evento IN ('Aperto','Chiuso','Cancellato')),
	 Punti_sq_1 NUMERIC(3),
	 Punti_sq_2 NUMERIC(3),
	 Nome_impianto VARCHAR(30) NOT NULL REFERENCES Impianto
	 									ON DELETE CASCADE
	 									ON UPDATE CASCADE,
	 Organizzatore VARCHAR(15) NOT NULL REFERENCES Utente
	 									ON DELETE CASCADE
	 									ON UPDATE CASCADE,
	 Torneo VARCHAR REFERENCES Torneo
	                ON DELETE CASCADE
	 			    ON UPDATE CASCADE,
	 PRIMARY KEY(Id_evento, Nome_sport));
	 
create table Punti
	(Id_evento VARCHAR(15),
	 Nome_sport VARCHAR(30),
	 Id_utente VARCHAR(15) REFERENCES Utente
	                       ON DELETE CASCADE
	                       ON UPDATE CASCADE,
	 N_punti NUMERIC(3) NOT NULL,
	 PRIMARY KEY(Id_evento, Nome_sport, Id_utente),
	 FOREIGN KEY(Id_evento, Nome_sport) REFERENCES Evento
										ON DELETE CASCADE
										ON UPDATE CASCADE);
										
create table Iscrizione
	(Id_evento VARCHAR(15),
	 Nome_sport VARCHAR(30),
	 Id_utente VARCHAR(15) REFERENCES Utente
	                       ON DELETE CASCADE
	                       ON UPDATE CASCADE,
	 Stato_iscrizione VARCHAR(10) 
	 		          CHECK (Stato_iscrizione IN ('Accettato','Rifiutato')),
	 Ruolo VARCHAR(15) NOT NULL,
	 Data_iscrizione DATE NOT NULL,
	 Sostituto VARCHAR(15) REFERENCES Utente
	                       ON DELETE CASCADE
	                       ON UPDATE CASCADE,
	 PRIMARY KEY(Id_evento, Nome_sport, Id_utente),
	 FOREIGN KEY(Id_evento, Nome_sport) REFERENCES Evento
										ON DELETE CASCADE
										ON UPDATE CASCADE);
										
create table Livello
	(Id_utente VARCHAR(15) REFERENCES Utente
	                       ON DELETE CASCADE
	                       ON UPDATE CASCADE,
	 Nome_sport VARCHAR(30) REFERENCES Categoria
	                        ON DELETE CASCADE
	                        ON UPDATE CASCADE,
	 Livello NUMERIC(3) NOT NULL 
	 					CHECK (Livello BETWEEN 0 AND 100),
	 PRIMARY KEY (Id_utente, Nome_sport));
	 
create table Squadra
	(Nome_squadra VARCHAR(20) PRIMARY KEY,
	 Colore_maglia VARCHAR(15) NOT NULL,
	 Stato_sq VARCHAR(10) NOT NULL
	          CHECK (Stato_sq IN ('Aperta','Chiusa','Cancellata')),
	 Minimo NUMERIC(2) NOT NULL,
	 Massimo NUMERIC(2) NOT NULL
	 				CHECK (Minimo <= Massimo),
	 Creatore VARCHAR(15) NOT NULL  REFERENCES Utente
	                       ON DELETE CASCADE
	                       ON UPDATE CASCADE,
	 Nome_sport VARCHAR(30) NOT NULL REFERENCES Categoria
	                                 ON DELETE CASCADE
	                                 ON UPDATE CASCADE);

create table Note 
	(Nome_squadra VARCHAR(20) REFERENCES Squadra
							  ON DELETE CASCADE
							  ON UPDATE CASCADE,
	Nota VARCHAR,
	PRIMARY KEY(Nome_squadra, Nota));
	
create table Candidatura 
	(Nome_squadra VARCHAR(20) REFERENCES Squadra
							  ON DELETE CASCADE
							  ON UPDATE CASCADE,
	 Componente VARCHAR(15) REFERENCES Utente
	                        ON DELETE CASCADE
	                        ON UPDATE CASCADE,
	 Data_candidatura DATE NOT NULL,
	 Stato_candidatura VARCHAR(10)
	 				   CHECK (Stato_candidatura IN ('Accettato','Rifiutato')),
	 Ruolo VARCHAR(15) NOT NULL,
	 PRIMARY KEY (Nome_squadra, Componente));
	 
create table Partecipa
	(Nome_squadra VARCHAR(20) REFERENCES Squadra
							  ON DELETE CASCADE
							  ON UPDATE CASCADE,
	 Torneo VARCHAR REFERENCES Torneo
	                    ON DELETE CASCADE
	 					ON UPDATE CASCADE,
	 PRIMARY KEY(Nome_squadra, Torneo));
	 
create table Sponsor
	(Torneo VARCHAR REFERENCES Torneo
	                    ON DELETE CASCADE
	 					ON UPDATE CASCADE,
	 Sponsor VARCHAR,
	 PRIMARY KEY(Torneo, Sponsor));
	 
create table Premi
	(Torneo VARCHAR REFERENCES Torneo
	                    ON DELETE CASCADE
	 					ON UPDATE CASCADE,
	 Premio VARCHAR,
	 PRIMARY KEY(Torneo, Premio));
	 
create table Modalità
	(Torneo VARCHAR REFERENCES Torneo
	                    ON DELETE CASCADE
	 					ON UPDATE CASCADE,
	 Modalità VARCHAR,
	 PRIMARY KEY(Torneo, Modalità));

create table Restrizioni
	(Torneo VARCHAR REFERENCES Torneo
	                    ON DELETE CASCADE
	 					ON UPDATE CASCADE,
	 Restrizione VARCHAR,
	 PRIMARY KEY(Torneo, Restrizione));
	 
create table Valutazione
	(Valutatore VARCHAR(15),
	 Valutato VARCHAR(15),
	 Evento_valutato VARCHAR(15),
	 Sport_evento VARCHAR(30), 
	 Data_valutazione DATE NOT NULL,
	 Commento VARCHAR,
	 Punteggio NUMERIC(2) NOT NULL
	 					  CHECK (Punteggio BETWEEN 0 AND 10),
	 PRIMARY KEY (Valutatore, Valutato, Evento_valutato, Sport_evento),
	 FOREIGN KEY (Valutatore) REFERENCES Utente,
     FOREIGN KEY (Valutato) REFERENCES Utente,
	 FOREIGN KEY (Evento_valutato, Sport_evento) REFERENCES Evento);
/*************************************************************************************************************************************************************************/ 
--1b. Popolamento 
/*************************************************************************************************************************************************************************/ 

INSERT INTO Utente
VALUES('123','Marco','Rossi',5879903,'Genova',2003,3856788502,'ImgMR','SMID','MarRos03',FALSE,'Giocatore',TRUE);
INSERT INTO Utente
VALUES('456','Matteo','Verdi',6568777,'Chiavari',2003,3895559002,'ImgMV','Informatica','MatVer03',TRUE,'Giocatore',FALSE);
INSERT INTO Utente
VALUES('789','Luca','Biachi',5689612,'Lavagna',2002,3998885476,'ImgLB','SMID','LucBia02',NULL,'Arbitro',FALSE);
INSERT INTO Utente
VALUES('S10','Giorgio','Bruno',5918273,'Genova',2004,3332525333,'ImgGB','Informatica','GioBru04',NULL, NULL, TRUE);
INSERT INTO Utente
VALUES('S55','Davide','Gialli',7773845,'Recco',2003,3934560759,'ImgDG','Informatica','DavGia03',FALSE,'Giocatore',FALSE);
INSERT INTO Utente
VALUES('CR7','Cristiano','Urru',6788127,'Sassari',2003,4932560898,'ImgEU','SMID','CriU03',TRUE,'Giocatore',FALSE);
INSERT INTO Utente
VALUES('N1','Corrado','Lago',9127666,'San Colombano',2003,1237122424,'ImgCL','Matematica','CorLag03',FALSE,'Giocatore',TRUE);
---INSERT INTO Utente
---VALUES('AAA','Pippo','Gianni',1111111,'Arenzano',1986,9993456875,'ImgPG','Fisica','Giannissimo86',TRUE,'Allenatore',FALSE);

INSERT INTO Categoria
VALUES('Calcio a 5','imgC',18,'Regolamento calcio a 5');
INSERT INTO Categoria
VALUES('Basket','imgB',20,'Regolamento basket');
INSERT INTO Categoria
VALUES('BeachVolley','imgBV',4,'Regolamento BeachVolley');
INSERT INTO Categoria
VALUES('Tennis singolo','imgT',2,'Regolamento tennis singolo');

INSERT INTO Impianto
VALUES('Campetto Valletta Puggia', 'Via Dodecaneso','calciopuggia@gmail.com',9875341260,'44,4015','8,9725');
INSERT INTO Impianto
VALUES('Palazzetto CUS', 'Via Dodecaneso','cusbasket@gmail.com',4005768999,'44,4028','8,9736');
INSERT INTO Impianto
VALUES('Tennis Chiavari', 'Via Preli','tennischiavari@gmail.com',8866123555,'44,3218','9,3070');
INSERT INTO Impianto
VALUES('Spiaggia lavagna', 'Lungomare Labonia','beachlavagna@gmail.com',9591224361,'44,3041','9,3491');

---INSERT INTO Torneo 
---VALUES('Torneo calcio a 5 2024','Calcio','A squadre','123');
INSERT INTO Torneo 
VALUES('Torneo calcio a 5 2024','Calcio a 5','A squadre','123');
---INSERT INTO Torneo 
---VALUES('Torneo Beach Volley estate 2022','BeachVolley','A coppie','S10');
---INSERT INTO Torneo 
---VALUES('Torneo Beach Volley estate 2022','BeachVolley','A squadre','S12');
INSERT INTO Torneo 
VALUES('Torneo Beach Volley estate 2022','BeachVolley','A squadre','S10');
INSERT INTO Torneo 
VALUES('Torneo tennis singolo primo semestre anno 2023/24','Tennis singolo','Singolo','123');

INSERT INTO Evento
VALUES('E88','Calcio a 5','08-Nov-2024','06-Nov-2024',TRUE,4,'Aperto',NULL,NULL,'Campetto Valletta Puggia','123','Torneo calcio a 5 2024');
INSERT INTO Evento
VALUES('E87','Calcio a 5','04-Jun-2024','01-Jun-2024',TRUE,18,'Chiuso',4,1,'Campetto Valletta Puggia','123','Torneo calcio a 5 2024');
INSERT INTO Evento
VALUES('E86','Calcio a 5','05-Jun-2024','02-Jun-2024',TRUE,18,'Chiuso',2,3,'Campetto Valletta Puggia','123','Torneo calcio a 5 2024');
INSERT INTO Evento
VALUES('EB1','Basket','26-May-2024','25-May-2024',FALSE,8,'Cancellato',NULL,NULL,'Palazzetto CUS','123',NULL);
INSERT INTO Evento
VALUES('EB2','Basket','01-Jul-2024','27-Jun-2024',FALSE,20,'Chiuso',87,42,'Palazzetto CUS','123',NULL);
INSERT INTO Evento
VALUES('BV1SS22','BeachVolley','08-Aug-2022','01-Aug-2022',FALSE,4,'Chiuso',6,4,'Spiaggia lavagna','S10','Torneo Beach Volley estate 2022');
INSERT INTO Evento
VALUES('BV2SS22','BeachVolley','08-Aug-2022','01-Aug-2022',FALSE,4,'Chiuso',3,5,'Spiaggia lavagna','S10','Torneo Beach Volley estate 2022');
INSERT INTO Evento
VALUES('BV3SS22','BeachVolley','15-Aug-2022','09-Aug-2022',FALSE,4,'Chiuso',7,5,'Spiaggia lavagna','S10','Torneo Beach Volley estate 2022');
INSERT INTO Evento
VALUES('ETS11','Tennis singolo','10-Feb-2023','07-Feb-2023',FALSE,0,'Cancellato',NULL,NULL,'Tennis Chiavari','S10','Torneo tennis singolo primo semestre anno 2023/24');
---INSERT INTO Evento
---VALUES('ETS12','Tennis singolo','12-Feb-2023','09-Feb-2023',FALSE,2,'Finito',NULL,NULL,'Tennis Chiavari','S10','Torneo tennis singolo primo semestre anno 2023/24');
---INSERT INTO Evento
---VALUES('ETS13','Tennis singolo','12-Feb-2023','09-Feb-2023',FALSE,2,'Chiuso',NULL,NULL,'Tennis Chiavari','S10','Torneo tennis singolo primo semestre anno 2022/24');
INSERT INTO Evento
VALUES('ETS12','Tennis singolo','12-Feb-2023','09-Feb-2023',FALSE,2,'Chiuso',NULL,NULL,'Tennis Chiavari','S10','Torneo tennis singolo primo semestre anno 2023/24');
INSERT INTO Evento
VALUES('ETS13','Tennis singolo','13-Feb-2023','09-Feb-2023',FALSE,2,'Chiuso',NULL,NULL,'Tennis Chiavari','S10','Torneo tennis singolo primo semestre anno 2023/24');
---INSERT INTO Evento
---VALUES('EB3','Basket','09-Feb-2023','13-Feb-2023',FALSE,2,'Chiuso',NULL,NULL,'Palazzetto CUS','123',NULL);

---INSERT INTO Punti
---VALUES('E87','Calcio a 5','G1', 2);
---INSERT INTO Punti
---VALUES('E85','Calcio a 5','123', 2);
INSERT INTO Punti
VALUES('E87','Calcio a 5','123', 2);

---INSERT INTO Livello
---VALUES('123','Pallavolo',87);
---INSERT INTO Livello
---VALUES('123','Calcio a 5',120);
INSERT INTO Livello
VALUES('123','Calcio a 5',99);

---INSERT INTO Valutazione
---VALUES('456','123','E87','Calcio a 5','06-Jun-2024',NULL,12);
---INSERT INTO Valutazione
---VALUES('000','123','E87','Calcio a 5','06-Jun-2024',NULL,9);
INSERT INTO Valutazione
VALUES('456','123','E87','Calcio a 5','06-Jun-2024',NULL,9);

INSERT INTO Iscrizione
VALUES('E88','Calcio a 5','123','Accettato','Attaccante','30-Jun-2024',NULL);
INSERT INTO Iscrizione
VALUES('E87','Calcio a 5','123','Accettato','Attaccante','20-May-2024',NULL);
INSERT INTO Iscrizione
VALUES('EB2','Basket','123','Accettato','PlayMaker','13-Jun-2024',NULL);
INSERT INTO Iscrizione
VALUES('ETS12','Tennis singolo','123','Accettato','Giocatore','08-Feb-2024',NULL);
INSERT INTO Iscrizione
VALUES('BV1SS22','BeachVolley','123','Accettato','Giocatore','20-Jul-2022',NULL);
INSERT INTO Iscrizione
VALUES('E88','Calcio a 5','CR7','Accettato','Attaccante','27-Jun-2024',NULL);
INSERT INTO Iscrizione
VALUES('E86','Calcio a 5','CR7','Accettato','Attaccante','29-May-2024',NULL);
INSERT INTO Iscrizione
VALUES('BV3SS22','BeachVolley','CR7','Rifiutato','Giocatore','2-Aug-2022',NULL);
INSERT INTO Iscrizione
VALUES('EB2','Basket','CR7','Accettato','Ala grande','27-Jun-2024',NULL);
INSERT INTO Iscrizione
VALUES('EB2','Basket','456','Rifiutato','Guardia','26-Jun-2024',NULL);
INSERT INTO Iscrizione
VALUES('ETS12','Tennis singolo','456','Accettato','Giocatore','08-Feb-2024','CR7');
INSERT INTO Iscrizione
VALUES('BV1SS22','BeachVolley','S55','Accettato','Giocatore','21-Jul-2022',NULL);
INSERT INTO Iscrizione
VALUES('BV3SS22','BeachVolley','S55','Accettato','Giocatore','1-Aug-2022',NULL);
INSERT INTO Iscrizione
VALUES('E86','Calcio a 5','S55','Rifiutato','Portiere','30-May-2024',NULL);
INSERT INTO Iscrizione
VALUES('ETS13','Tennis singolo','S55','Accettato','Giocatore','06-Feb-2024','CR7');
INSERT INTO Iscrizione
VALUES('E87','Calcio a 5','N1','Rifiutato','Difensore','28-May-2024',NULL);
INSERT INTO Iscrizione
VALUES('EB2','Basket','N1','Rifiutato','Ala Grande','26-Jun-2024',NULL);
---INSERT INTO Iscrizione
---VALUES('BV1SS22','BeachVolley','N1','Rifiutato','Giocatore',NULL,NULL);
---INSERT INTO Iscrizione
---VALUES('BV1SS22','BeachVolley','N1','In attesa','Giocatore','21-Jul-2022',NULL);

INSERT INTO Squadra 
VALUES('Smid calcio 2024','Arancione','Chiusa',6,9,'123','Calcio a 5');
---INSERT INTO Squadra 
---VALUES('Smid Basket 2023','Arancione','Cancellata',10,5,'N1','Basket');
INSERT INTO Squadra 
VALUES('Smid Basket 2023','Arancione','Cancellata',5,10,'N1','Basket');
---INSERT INTO Squadra 
---VALUES('Informativi BV 22','Azzurri','Completa',2,2,'S10','BeachVolley');
INSERT INTO Squadra 
VALUES('Informatici BV 22','Azzurri','Chiusa',2,2,'S10','BeachVolley');

---INSERT INTO Candidatura
---VALUES('Smid calcio 2024','CR7','03-Apr-2024','Confermato','Attaccante');
INSERT INTO Candidatura
VALUES('Smid calcio 2024','CR7','03-Apr-2024','Accettato','Attaccante');
INSERT INTO Candidatura
VALUES('Informatici BV 22','S55','30-May-2022','Accettato','Giocatore');

---INSERT INTO Partecipa
---VALUES('Smid calcio 2024',NULL);
---INSERT INTO Partecipa
---VALUES('Smid calcio 2024','Torneo calcetto');
INSERT INTO Partecipa
VALUES('Smid calcio 2024','Torneo calcio a 5 2024');
INSERT INTO Partecipa
VALUES('Informatici BV 22','Torneo Beach Volley estate 2022');


/*************************************************************************************************************************************************************************/ 
--2. Vista
--Vista Programma che per ogni impianto e mese riassume tornei e eventi che si svolgono in tale impianto, 
--evidenziando in particolare per ogni categoria il numero di tornei, il numero di eventi, il numero di partecipanti 
--coinvolti e di quanti diversi corsi di studio, la durata totale (in termini di minuti) di utilizzo e la percentuale di 
--utilizzo rispetto alla disponibilitˆ complessiva (minuti totali nel mese in cui lÕimpianto  utilizzabile) 
/*************************************************************************************************************************************************************************/ 

ALTER TABLE categoria ADD COLUMN durata DOUBLE PRECISION;
UPDATE categoria
SET durata = 60
WHERE nome_sport = 'Calcio a 5';
UPDATE categoria
SET durata = 40
WHERE nome_sport = 'Basket';
UPDATE categoria
SET durata = 30
WHERE nome_sport = 'BeachVolley';
UPDATE categoria
SET durata = 120
WHERE nome_sport = 'Tennis singolo';

CREATE VIEW Programma AS
SELECT impianto.nome_impianto AS impianto,
       EXTRACT(YEAR FROM evento.data_evento) AS anno,
	   EXTRACT(MONTH FROM evento.data_evento) AS mese,
	   categoria.nome_sport AS categoria,
	   COUNT(DISTINCT evento.torneo) AS n_tornei,
	   COUNT(DISTINCT evento.id_evento) AS n_eventi,
	   COUNT(DISTINCT utente.id_utente) AS n_partecipanti, 
	   COUNT(DISTINCT utente.cds) AS n_cds,
	   COUNT(DISTINCT evento.id_evento)*durata AS tempo_utilizzo,
	   (COUNT(DISTINCT evento.id_evento)*durata/(30*24*60))*100 AS percentuale_utilizzo
FROM categoria JOIN evento on categoria.nome_sport = evento.nome_sport AND stato_evento = 'Chiuso'
     JOIN impianto ON evento.nome_impianto = impianto.nome_impianto
     LEFT JOIN iscrizione ON iscrizione.id_evento = evento.id_evento AND stato_iscrizione = 'Accettato'
     LEFT JOIN utente ON iscrizione.id_utente = utente.id_utente
GROUP BY impianto, anno, mese, categoria, durata;

SELECT * FROM programma;

/*************************************************************************************************************************************************************************/ 
--3. Interrogazioni
/*************************************************************************************************************************************************************************/ 

/*************************************************************************************************************************************************************************/ 
/* 3a: Determinare gli utenti che si sono candidati come giocatori e non sono mai 
stati accettati e quelli che sono 
stati accettati tutte le volte che si sono candidati */
/*************************************************************************************************************************************************************************/ 

(SELECT id_utente
FROM iscrizione 
WHERE ruolo != 'Arbitro'
EXCEPT
SELECT id_utente
FROM iscrizione
WHERE stato_iscrizione != 'Rifiutato')
UNION
(SELECT id_utente
FROM iscrizione 
WHERE ruolo != 'Arbitro'
EXCEPT
SELECT id_utente
FROM iscrizione
WHERE stato_iscrizione != 'Accettato');

/*************************************************************************************************************************************************************************/ 
/* 3b: determinare gli utenti che hanno partecipato ad almeno un evento di ogni 
categoria */
/*************************************************************************************************************************************************************************/ 

SELECT id_utente
FROM iscrizione NATURAL JOIN evento
WHERE stato_iscrizione='Accettato' AND data_evento < CURRENT_DATE AND stato_evento='Chiuso'
GROUP BY id_utente
HAVING COUNT(DISTINCT nome_sport)=(SELECT COUNT(DISTINCT nome_sport)
								   FROM Categoria);

/*************************************************************************************************************************************************************************/ 
/* 3c: determinare per ogni categoria il corso di laurea pi attivo in tale categoria,
cio quello i cui studenti 
hanno partecipato al maggior numero di eventi (singoli o allÕinterno di tornei) di 
tale categoria */
/*************************************************************************************************************************************************************************/ 

SELECT nome_sport, cds
FROM iscrizione NATURAL JOIN utente NATURAL JOIN evento
WHERE stato_iscrizione='Accettato' AND data_evento < CURRENT_DATE AND stato_evento='Chiuso'
GROUP BY nome_sport, cds
HAVING COUNT(cds)>=ALL (SELECT COUNT(cds)
					    FROM iscrizione NATURAL JOIN utente NATURAL JOIN evento
                        WHERE stato_iscrizione='Accettato' AND data_evento < CURRENT_DATE AND stato_evento='Chiuso'
					    GROUP BY nome_sport, cds);
