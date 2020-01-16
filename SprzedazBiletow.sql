USE master 
GO 

IF DB_ID('PKP') IS NULL 
	CREATE DATABASE PKP 
GO

USE PKP
GO

IF OBJECT_ID('dbo.Poz_Biletu','U') IS NOT NULL
	DROP TABLE dbo.Poz_Biletu
GO

IF OBJECT_ID('dbo.Bilet','U') IS NOT NULL
	DROP TABLE dbo.Bilet 
GO

IF OBJECT_ID('dbo.Sprzedawal','U') IS NOT NULL
	DROP TABLE dbo.Sprzedawal
GO

IF OBJECT_ID('dbo.Dojade','U') IS NOT NULL
	DROP TABLE dbo.Dojade  
GO

IF OBJECT_ID('dbo.Pociag','U') IS NOT NULL
	DROP TABLE dbo.Pociag
GO

IF OBJECT_ID('dbo.Polaczenie','U') IS NOT NULL
	DROP TABLE dbo.Polaczenie
GO

IF OBJECT_ID('dbo.Zestaw_Polaczen','U') IS NOT NULL
	DROP TABLE dbo.Zestaw_Polaczen
GO

IF OBJECT_ID('dbo.Typ_Polaczen','U') IS NOT NULL
	DROP TABLE dbo.Typ_Polaczen 
GO

IF OBJECT_ID('dbo.Cel_Podrozy','U') IS NOT NULL
	DROP TABLE dbo.Cel_Podrozy 
GO

IF OBJECT_ID('dbo.Kasjer_Sprzedawca','U') IS NOT NULL
	DROP TABLE dbo.Kasjer_Sprzedawca
GO

IF OBJECT_ID('dbo.Kasy','U') IS NOT NULL
	DROP TABLE dbo.Kasy
GO

IF OBJECT_ID('dbo.Znizka','U') IS NOT NULL
	DROP TABLE dbo.Znizka 
GO

-- ----------------------------------------
-- Tworzenie bazy danych
-- ----------------------------------------

CREATE TABLE dbo.Znizka (
	Nazwa VARCHAR(25) PRIMARY KEY,
	Ile_procent INT NOT NULL,
	)
GO

CREATE TABLE dbo.Kasy (
	Kasa VARCHAR(6) PRIMARY KEY,
	Na_Dworcu CHAR(3) NOT NULL,
	)
GO

CREATE TABLE dbo.Kasjer_Sprzedawca (
	id_K_S INT IDENTITY(1,1) PRIMARY KEY,
	Imie VARCHAR(15) NOT  NULL,
	Nazwisko VARCHAR(20) NOT NULL,
	Zatrudniony DATE NOT NULL,
	)
GO

CREATE TABLE dbo.Cel_Podrozy (
	id_C_P INT IDENTITY(1,1) PRIMARY KEY,
	Skad VARCHAR(25) NOT NULL,
	Dokad VARCHAR(25) NOT NULL,
	Odleglosc_w_km INT CONSTRAINT sk_do CHECK( odleglosc_w_km > 0 ) NOT NULL,
	)
GO
CREATE TABLE dbo.Zestaw_Polaczen (
	id_Z_P INT IDENTITY(1,1) PRIMARY KEY,
	Z VARCHAR(25) NOT NULL,
	DO VARCHAR(25) NOT NULL,
	)
GO

CREATE TABLE dbo.Typ_Polaczen (
	Typ VARCHAR(5) PRIMARY KEY,
	Cena_za_1km_KL1 FLOAT CONSTRAINT ce_km CHECK( cena_za_1km_KL1 BETWEEN 0.1 AND  1.0 ) ,
	Cena_za_1km_KL2 FLOAT CONSTRAINT ce_km2 CHECK( cena_za_1km_KL2 BETWEEN 0.1 AND  1.5 ) ,
	Kategoria VARCHAR(20) ,
	)
GO                                       

CREATE TABLE dbo.Polaczenie (
	id_P INT IDENTITY(1,1) PRIMARY KEY,
	id_Zes_Pol INT REFERENCES dbo.Zestaw_Polaczen(id_Z_P) NOT NULL,
	id_Typ_Pol VARCHAR(5) REFERENCES dbo.Typ_Polaczen(Typ) NOT NULL,   
	)
GO

CREATE TABLE dbo.Pociag (
	Numer VARCHAR(15) PRIMARY KEY,
	Wyjechal TIME NOT NULL,	
	id_Polaczenia INT REFERENCES dbo.Polaczenie(id_P) NOT NULL,
	)
GO

CREATE TABLE dbo.Dojade (
	id_D INT IDENTITY(1,1) PRIMARY KEY,
	id_Cel INT REFERENCES dbo.Cel_Podrozy(id_C_P) NOT NULL,
	Pociagiem VARCHAR(15) REFERENCES dbo.Pociag(Numer) ON DELETE CASCADE NOT NULL,
	)
GO

CREATE TABLE dbo.Sprzedawal (
	id_S INT IDENTITY(1,1) PRIMARY KEY,
	Kasjer INT REFERENCES dbo.Kasjer_Sprzedawca(id_K_S), 
	W_Kasie VARCHAR(6) REFERENCES dbo.Kasy(Kasa),
	)
GO

CREATE TABLE dbo.Bilet (
	id_B INT IDENTITY(1,1) PRIMARY KEY,
	id_Sprzedane INT REFERENCES dbo.Sprzedawal(id_S) NULL,
	Data_Podrozy DATE NOT NULL,
	Data_Sprzedazy DATETIME DEFAULT GETDATE() NOT NULL,
	)	
GO

CREATE TABLE dbo.Poz_Biletu (
	id_Biletu INT REFERENCES dbo.Bilet(id_B) NOT NULL,
	id_Poz INT ,
	Liczba_Podroznych INT CONSTRAINT L_POD CHECK(liczba_Podroznych > 0) NOT NULL,
	id_Dojade INT REFERENCES dbo.Dojade(id_D) NOT NULL,
	id_Znizki VARCHAR(25) REFERENCES dbo.Znizka(Nazwa) NULL,
	PRIMARY KEY ( id_Poz , id_Biletu ),
	)
GO

-- -------------------------------------------
-- Wstawianie wartoœci do tabel
-- -------------------------------------------

INSERT INTO dbo.Cel_Podrozy VALUES
('Poznañ G³ówny','Ko³o',130),
('Ko³o','Poznañ G³ówny',130),
('Ko³o','Kutno',69),
('Kutno','Ko³o',69),  
('Poznañ G³ówny','Konin',100),
('Konin','Poznañ G³ówny',100), 
('Poznañ G³ówny','Wrzeœnia',61),
('Wrzeœnia','Poznañ G³ówny',61),
('Poznañ G³ówny','Szczecin G³ówny',293),
('Szczecin G³ówny','Poznañ G³ówny',293),					
('Poznañ G³ówny','Kraków G³ówny',522),
('Kraków G³ówny','Poznañ G³ówny',522),
('Poznañ G³ówny','Katowice',433),
('Kaowice','Poznañ G³ówny',433),
('Poznañ G³ówny','Bydgoszcz G³ówna',312),
('Bydgoszcz G³ówna','Poznañ G³ówny',312),
('Poznañ G³ówny','Gdañœk G³ówny',415),
('Gdañsk G³ówny','Poznañ G³ówny',415),
('Poznañ G³ówny','Gdynia G³ówna',430),
('Gdynia G³ówna','Poznañ G³ówny',430),
('Poznañ G³ówny','Wroc³aw G³ówny',325),
('Wroc³aw G³ówny','Poznañ G³ówny',325),
('Poznañ G³ówny','Jelenia Góra',421),
('Jelenia Góra','Poznañ G³ówny',421),
('Poznañ G³ówny','Rzepin',227),
('Poznañ G³ówny','Berlin Ostbahnhof',473),
('Poznañ G³ówny','Warszawa Wschodnia',310),
('Warszawa Wschodnia','Poznañ G³ówny',310),
('Poznañ G³ówny','Rzeszów G³ówny',584),
('Rzeszów G³ówny','Poznañ G³ówny',584),
('Poznañ G³ówny','Olsztyn G³ówny',597),
('Olsztyn G³ówny','Poznañ G³ówny',597),
('Poznañ G³ówny','£ódŸ Kaliska',288),
('£ódŸ Kaliska','Poznañ G³ówny',288),
('Poznañ G³ówny','Pi³a G³ówna',165),
('Pi³a G³ówna','Poznañ G³ówny',165),
('Poznañ G³ówny','Kutno',190),
('Kutno','Poznañ G³ówny',190),
('Poznañ G³ówny','S³upsk',349),
('S³upsk','Poznañ G³ówny',349),
('Poznañ G³ówny','Koszalin',312),
('Koszalin','Poznañ G³ówny',312),
('Poznañ G³ówny','Leszno',94),
('Leszno','Poznañ G³ówny',94),
('Poznañ G³ówny','Gniezno',56),
('Gniezno','Poznañ G³ówny',56),
('Poznañ G³ówny','Zb¹szynek',81),
('Zb¹szynek','Poznañ G³ówny',81),
('Poznañ G³ówny','Wolsztyn',59),
('Wolsztyn','Poznañ G³ówny',59),
('Poznañ G³ówny','Swarzêdz',15),
('Swarzêdz','Poznañ G³ówny',15),
('Poznañ G³ówny','Kostrzyñ Wielkopolski',33),
('Kostrzyñ Wielkopolski','Poznañ G³ówny',33),
('Poznañ G³ówny','Bia³ystok',640),
('Bia³ystok','Poznañ G³ówny',640)
GO

INSERT INTO dbo.Zestaw_Polaczen VALUES 
('Szczecin G³ówny','Kraków G³ówny'),
('Kraków G³ówny','Szczecin G³ówny'),  
('Jelenia Góra','Gdynia G³ówna'), 
('Gdynia G³ówna','Jelenia Góra'), 
('Gdynia G³ówna','Wroc³aw G³ówny'),
('Wroc³aw G³ówny','Gdynia G³ówna'), 
('Moskwa Bel.','Berlin Licht.'),
('Berlin Licht.','Moskwa Bel.'), 
('Poznañ G³ówny','Warszawa Wschodnia'),
('Warszawa Wschodnia','Poznañ G³ówny'), 
('Zielona Góra','Warszawa Wschodnia'),
('Warszawa Wschodnia','Zielona Góra'), 
('Zakopane','Szczecin G³ówny'),
('Szczecin G³ówny','Zakopane'), 
('Poznañ G³ówny','Przemyœl G³ówny'),       
('Przemyœl G³ówny','Poznañ G³ówny'), 
('Poznañ G³ówny','Olsztyn G³ówny'),
('Olsztyn G³ówny','Poznañ G³ówny'), 
('£ódŸ Fabryczna','Szczecin G³owny'),
('Szczecin G³ówny','£ód¿ Fabryczna'), 
('Gorzów Wielkopolski','Katowice'),
('Katowice','Gprzów Wielkopolski'), 
('Wroc³aw G³ówny','Bia³ystok'),
('Bia³ystok','Wroc³aw G³ówny'), 
('Lublin','Zielona Góra'),
('Zielona Góra','Lublin'), 
('Poznañ G³ówny','Kutno'),
('Kutno','Poznañ G³ówny'), 
('Poznañ G³ówny','Zb¹szynek'),
('Zb¹szynek','Poznañ G³ówny'),        
('Poznañ G³ówny','Wolsztyn'),
('Wolsztyn','Poznañ G³ówny'), 
('Leszno','Ostrów Wielkopolski'),
('Ostrów Wielkopolski','Leszno'), 
('Leszno','Zb¹szynek'),
('Zb¹szynek','Leszno'), 
('Poznañ G³ówny','Mogilno'),
('Mogilno','Poznañ G³ówny'), 
('Poznan G³ówny','S³upsk'),
('S³upsk','Poznan G³ówny')
GO

INSERT INTO dbo.Typ_Polaczen VALUES
('KW',NULL ,0.1825,'Osobowy'),
('IC',0.3261 ,0.2692,'InterCity'),
('EIC',0.4615 ,0.4115,'Express InterCity'),
('TLK',0.3261 ,0.2692,'Twoje Linie Kolejowe'),
('EN',0.5101,NULL,'EuroNight')
GO

INSERT INTO dbo.Polaczenie VALUES
(1,'EIC'),(1,'TLK'),(2,'EIC'),  
(2,'TLK'),(3,'IC'),(4,'IC'),
(5,'TLK'),(5,'IC'),(6,'IC'),
(6,'TLK'),(7,'EN'),(8,'EN'),
(9,'IC'),(10,'IC'),(11,'IC'),
(11,'EIC'),(12,'EIC'),(12,'IC'),
(13,'TLK'),(13,'IC'),(14,'TLK'),
(15,'TLK'),(16,'TLK'),(17,'IC'),
(17,'EIC'),(18,'IC'),(19,'IC'),
(20,'IC'),(21,'IC'),(22,'IC'),
(23,'TLK'),(24,'TLK'),(25,'EIC'),
(25,'TLK'),(26,'TLK'),(27,'KW'),
(28,'KW'),(29,'KW'),(30,'KW'),
(31,'KW'),(32,'KW'),(33,'KW'),
(34,'KW'),(35,'KW'),(36,'KW'),
(37,'KW'),(38,'KW'),(39,'TLK'),(40,'TLK')
GO

INSERT INTO dbo.Pociag VALUES
('19301/5',CAST('07:24:00' AS Time),1),
('45201/4/51',CAST('12:04:00' AS Time),2),
('15007/3/4',CAST('18:56:00' AS TIME),2),
('28174/5',CAST('15:05:00' AS Time),4),
('23236/5',CAST('07:05:00' AS Time),3),
('271640/12',CAST('11:08:00' AS Time),4),
('25154/11',CAST('12:35:00' AS Time),5),
('456894/7',CAST('09:23:00' AS Time),6),
('47698/5/4',CAST('20:13:00' AS Time),6),
('2156/7',CAST('13:15:00' AS Time),7),
('365274/5',CAST('15:05:00' AS Time),8),
('14894/5',CAST('06:42:00' AS Time),7),
('5687/5/7',CAST('06:25:00' AS Time),9),
('45632/8/14',CAST('12:05:00' AS Time),10),
('5212/4',CAST('16:37:00' AS Time),9),
('1423/5/6',CAST('22:05:00' AS Time),11),
('23411/4',CAST('23:12:00' AS Time),12),
('58876/5',CAST('14:28:00' AS Time),13),
('69784/45/1',CAST('16:08:00' AS Time),14),
('2645/7/9',CAST('10:47:00' AS Time),15),
('6321/8/6',CAST('13:09:00' AS Time),16),
('45781/4',CAST('07:35:00' AS Time),17),
('21475/5',CAST('11:45:00' AS Time),18),
('1225/4',CAST('06:05:00' AS Time),19),
('33584/4',CAST('15:05:00' AS Time),20),
('21447/4',CAST('10:08:00' AS Time),21),
('11289/5',CAST('15:26:00' AS Time),21),
('4570/1/4/12',CAST('06:53:00' AS Time),22),
('102856/4',CAST('09:03:00' AS Time),23),
('59667/4',CAST('13:36:00' AS Time),24),
('31225/7',CAST('09:15:00' AS Time),25),
('12469/4',CAST('12:45:00' AS Time),26),
('28211/6/8',CAST('17:34:00' AS Time),27),
('33541/11/2',CAST('15:21:00' AS Time),28),
('11469/6/4',CAST('08:32:00' AS Time),29),
('65231/5',CAST('12:14:00' AS Time),30),
('33541/4/4',CAST('20:21:00' AS Time),31),
('52899/7',CAST('21:07:00' AS Time),32),
('32456/4',CAST('12:45:00' AS Time),33),
('21247/6',CAST('17:45:00' AS Time),34),
('221470/4',CAST('16:25:00' AS Time),35),
('79308',CAST('04:28:00' AS Time),36),
('33693',CAST('11:01:00' AS Time),36),
('758852',CAST('20:45:00' AS Time),36),
('2844',CAST('04:56:00' AS Time),37),
('1147',CAST('12:15:00' AS Time),37),
('1312',CAST('17:25:00' AS Time),37),
('4562',CAST('07:06:00' AS Time),38),
('5214',CAST('15:52:00' AS Time),38),
('1254',CAST('05:23:00' AS Time),39),
('5887',CAST('11:34:00' AS Time),39),
('4521',CAST('15:16:00' AS Time),39),
('61284',CAST('09:21:00' AS Time),40),
('59987',CAST('11:58:00' AS Time),40),
('65221',CAST('18:12:00' AS Time),40),
('1040',CAST('10:30:00' AS Time),41),
('3639',CAST('15:20:00' AS Time),41),
('2047',CAST('17:20:00' AS Time),42),
('45632',CAST('08:20:00' AS Time),42),
('1250',CAST('10:07:00' AS Time),43),
('3797',CAST('12:11:00' AS Time),43),
('2634',CAST('15:48:00' AS Time),43),
('5284',CAST('15:03:00' AS Time),44),
('4825',CAST('15:18:00' AS Time),45),
('1524',CAST('07:29:00' AS Time),46),
('56203',CAST('11:42:00' AS Time),46),
('2051',CAST('15:25:00' AS Time),46),
('6987',CAST('15:57:00' AS Time),47),
('2874',CAST('10:06:00' AS Time),47),
('20304/5/4',CAST('17:24:00' AS Time),48),
('32104/4',CAST('11:45:00' AS Time),49)
GO

INSERT INTO dbo.Dojade VALUES
(1,'79308'),(1,'33693'),(1,'758852'),
(1,'33541/11/2'),(1,'11469/6/4'),(1,'58876/5'),
(2,'1147'),(2,'1312'),(2,'2844'),
(2,'2645/7/9'),(2,'69784/45/1'),(2,'102856/4'),
(2,'1225/4'),(3,'79308'),(3,'758852'),
(3,'45201/4/51'),(4,'1312'),(4,'28174/5'),
(5,'4570/1/4/12'),(5,'45201/4/51'),(5,'11469/6/4'),
(5,'33541/11/2'),(5,'33693'),(5,'758852'),
(5,'79308'),(6,'1147'),(6,'1312'),
(6,'2844'),(6,'69784/45/1'),(6,'21475/5'),
(6,'45781/4'),(6,'23236/5'),(7,'79308'),
(7,'33693'),(7,'58876/5'),(8,'1312'),
(8,'2844'),(8,'28211/6/8'),(8,'65231/5'),
(9,'28211/6/8'),(9,'1225/4'),(10,'15007/3/4'),
(9,'28174/5'),(10,'33541/11/2'),(11,'21447/4'),
(10,'19301/5'),(11,'15007/3/4'),(12,'271640/12'),
(12,'28174/5'),(12,'23236/5'),(13,'11469/6/4'),
(13,'19301/5'),(14,'23236/5'),(14,'65231/5'),
(15,'31225/7'),(15,'5212/4'),(15,'59667/4'),
(16,'365274/5'),(16,'456894/7'),(16,'14894/5'),
(17,'45632/8/14'),(17,'25154/11'),(17,'5212/4'),
(18,'456894/7'),(18,'365274/5'),(19,'5687/5/7'),
(19,'5212/4'),(19,'45632/8/14'),(20,'14894/5'),
(20,'2156/7'),(20,'365274/5'),(20,'456894/7'),
(21,'14894/5'),(21,'2156/7'),(21,'52899/7'),
(21,'365274/5'),(22,'5212/4'),(22,'5687/5/7'),
(22,'25154/11'),(23,'456894/7'),(24,'25154/11'),
(25,'1423/5/6'),(26,'1423/5/6'),(27,'2645/7/9'),
(27,'58876/5'),(27,'6321/8/6'),(28,'69784/45/1'),
(28,'45781/4'),(29,'4570/1/4/12'),(30,'102856/4'),
(31,'31225/7'),(31,'59667/4'),(32,'12469/4'),
(33,'33541/11/2'),(34,'28211/6/8'),(35,'20304/5/4'),
(36,'32104/4'),(37,'758852'),(37,'33693'),
(37,'79308'),(37,'19301/5'),(37,'33541/11/2'),
(37,'58876/5'),(38,'69784/45/1'),(38,'28211/6/8'),
(38,'23236/5'),(39,'20304/5/4'),(40,'32104/4'),
(41,'20304/5/4'),(42,'32104/4'),(43,'14894/5'),
(43,'365274/5'),(44,'5212/4'),(45,'1524'),(45,'2051'),
(46,'2874'),(47,'5214'),(47,'4562'),(48,'4521'),
(48,'5887'),(49,'65221'),(49,'61284'),(49,'59987'),
(50,'3639'),(50,'1040'),(51,'33693'),(51,'758852'),
(51,'79308'),(51,'33541/11/2'),(51,'15007/3/4'),
(52,'1147'),(52,'1312'),(52,'2844'),(53,'33693'),
(53,'758852'),(53,'79308'),(54,'1147'),(54,'1312'),
(54,'2844'),(55,'33541/4/4'),(56,'52899/7')
GO

INSERT INTO dbo.Znizka VALUES
('Funkcyjna',100),('Dzieci poni¿ej 4 lat',100),
('Inwalidzka',78),('Emeryci',37),
('Dzieci powy¿ej 4 lat',37),('Studenci',51),
('Kombatanci',37)
GO

INSERT INTO dbo.Kasjer_Sprzedawca VALUES
('Roman','R¹czka','20001013'),
('Iwona','Jêdrasik','20030108'),
('Anna','Okrasa','20071014'),
('Micha³','Gzik','20051026'),
('Justyna','Krawczyk','19980102'),
('Rados³aw','Wilczur','19930401'),
('Wiktor','Wojciechowicz','20000201'),
('Mariusz','Kamiñski','20051026'),
('Marta','Zawisna','20040501'),
('Magdalena','Szurgot','20051014'),
('Jerzy','Borówka','20010201'),
('Marzena','Andrzejewska','20150401'),
('Karolina','Zapasiewicz','20001102'),
('Jadwiga','Skorupko','19951201'),
('Zofia','Barcisz','19990102'),
('Grzegorz','Brzozowski','20010515')
GO

INSERT INTO dbo.Kasy VALUES
('KASA-1','TAK'),
('KASA-2','TAK'),
('KASA-3','TAK'),
('KASA-4','TAK'),
('KASA-5','TAK'),
('KASA-6','NIE'),
('KASA-7','NIE')
GO

INSERT INTO dbo.Sprzedawal VALUES
(1,'KASA-1'),(2,'KASA-3'),
(3,'KASA-2'),(4,'KASA-5'),
(5,'KASA-1'),(6,'KASA-6'),
(7,'KASA-4'),(8,'KASA-2'),
(3,'KASA-1'), (5,'KASA-4'),
(4,'KASA-3'),(1,'KASA-5'),
(6,'KASA-5'),(7,'KASA-2'),
(8,'KASA-1'), (9,'KASA-3'),
(10,'KASA-2'),(11,'KASA-5'),
(12,'KASA-1'),(9,'KASA-1'),
(6,'KASA-2'),(7,'KASA-3'),
(8,'KASA-4'),(9,'KASA-5'),
(10,'KASA-1'),(1,'KASA-2'),
(2,'KASA-2'),(11,'KASA-2'),
(12,'KASA-3'),(4,'KASA-2'),
(8,'KASA-6'),(10,'KASA-4')
GO

INSERT INTO dbo.Bilet VALUES
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 06:05:00'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 06:25:49'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 06:38:15'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 06:41:05'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 06:45:15'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 07:05:15'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 07:12:32'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 07:26:19'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 07:32:52'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 08:25:27'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 08:34:12'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 08:41:52'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 08:45:45'AS datetime) ),
(1,CAST('2017-01-16' AS date),CAST('2017-01-15 09:14:02'AS datetime) ),
(1,CAST('2017-01-16' AS date),CAST('2017-01-15 09:55:02'AS datetime) ),
(1,CAST('2017-01-16' AS date),CAST('2017-01-15 10:15:28'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 10:32:10'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 10:42:24'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 10:47:23'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 10:51:52'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 11:01:09'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 11:21:06'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 11:45:27'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 12:01:56'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 12:45:36'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 12:52:42'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 13:15:15'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 13:21:49'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 13:24:12'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 13:54:12'AS datetime) ),
(1,CAST('2017-01-15' AS date),CAST('2017-01-15 13:59:02'AS datetime) ),
(NULL,CAST('2017-01-16' AS date),CAST('2017-01-15 23:24:12'AS datetime) ),
(NULL,CAST('2017-01-15' AS date),CAST('2017-01-15 13:59:02'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 06:05:45'AS datetime) ),
(2,CAST('2017-01-16' AS date),CAST('2017-01-15 12:12:49'AS datetime) ), 
(2,CAST('2017-01-17' AS date),CAST('2017-01-15 06:23:12'AS datetime) ),
(2,CAST('2017-01-16' AS date),CAST('2017-01-15 12:29:15'AS datetime) ),
(2,CAST('2017-01-16' AS date),CAST('2017-01-15 06:41:05'AS datetime) ),
(2,CAST('2017-01-16' AS date),CAST('2017-01-15 12:45:45'AS datetime) ),
(2,CAST('2017-01-18' AS date),CAST('2017-01-15 06:54:15'AS datetime) ),
(2,CAST('2017-01-16' AS date),CAST('2017-01-15 06:59:02'AS datetime) ),
(2,CAST('2017-01-16' AS date),CAST('2017-01-15 08:45:27'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 10:51:52'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 11:14:09'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 11:23:09'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 11:42:27'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 11:52:27'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 12:52:42'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 13:21:49'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 13:24:12'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 13:54:12'AS datetime) ),
(2,CAST('2017-01-15' AS date),CAST('2017-01-15 13:59:02'AS datetime) ),
(NULL,CAST('2017-01-16' AS date),CAST('2017-01-15 23:24:12'AS datetime) ),
(NULL,CAST('2017-01-15' AS date),CAST('2017-01-15 18:23:02'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 06:41:05'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 06:45:15'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 07:12:32'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 07:22:52'AS datetime) ),
(3,CAST('2017-01-17' AS date),CAST('2017-01-15 07:29:19'AS datetime) ),
(3,CAST('2017-01-17' AS date),CAST('2017-01-15 07:45:15'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 08:08:27'AS datetime) ),
(3,CAST('2017-01-17' AS date),CAST('2017-01-15 08:23:12'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 08:41:52'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 08:45:45'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 09:14:02'AS datetime) ),
(3,CAST('2017-01-17' AS date),CAST('2017-01-15 09:23:02'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 09:29:02'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 09:45:02'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 10:15:28'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 10:32:10'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 10:39:24'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 10:46:23'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 10:57:52'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 11:03:09'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 11:24:06'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 11:49:27'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 12:02:56'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 12:12:56'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 12:32:36'AS datetime) ),
(3,CAST('2017-01-18' AS date),CAST('2017-01-15 12:52:42'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 13:15:15'AS datetime) ),
(3,CAST('2017-01-16' AS date),CAST('2017-01-15 13:24:12'AS datetime) ),
(3,CAST('2017-01-15' AS date),CAST('2017-01-15 13:59:02'AS datetime) ),
(NULL,CAST('2017-01-16' AS date),CAST('2017-01-15 12:24:12'AS datetime) ),
(NULL,CAST('2017-01-15' AS date),CAST('2017-01-15 03:56:02'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 06:06:41'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 10:12:23'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 06:45:15'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 07:19:32'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 07:25:19'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 07:11:15'AS datetime) ),
(4,CAST('2017-01-17' AS date),CAST('2017-01-15 08:26:12'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 08:43:52'AS datetime) ),
(4,CAST('2017-01-17' AS date),CAST('2017-01-15 08:49:45'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 09:21:02'AS datetime) ),
(4,CAST('2017-01-17' AS date),CAST('2017-01-15 09:29:02'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 09:45:02'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 10:22:10'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 10:41:24'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 10:46:23'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 10:57:52'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 11:03:09'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 11:42:27'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 12:06:56'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 12:14:56'AS datetime) ),
(4,CAST('2017-01-15' AS date),CAST('2017-01-15 12:36:36'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 13:12:15'AS datetime) ),
(4,CAST('2017-01-16' AS date),CAST('2017-01-15 13:23:12'AS datetime) ),
(NULL,CAST('2017-01-15' AS date),CAST('2017-01-15 05:29:12'AS datetime) ),
(NULL,CAST('2017-01-15' AS date),CAST('2017-01-15 13:25:02'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 14:12:29'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 14:23:41'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 15:14:05'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 15:48:59'AS datetime) ),
(5,CAST('2017-01-17' AS date),CAST('2017-01-15 15:58:17'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 16:18:45'AS datetime) ),
(5,CAST('2017-01-17' AS date),CAST('2017-01-15 16:21:10'AS datetime) ),
(5,CAST('2017-01-17' AS date),CAST('2017-01-15 16:36:00'AS datetime) ),
(5,CAST('2017-01-17' AS date),CAST('2017-01-15 16:51:56'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 17:06:20'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 17:12:23'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 17:18:15'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 17:23:45'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 17:31:23'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 17:42:10'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 17:49:05'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 17:51:42'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 17:57:07'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 18:03:22'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 18:12:14'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 18:23:29'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 18:29:10'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 18:36:52'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 18:41:08'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 19:08:01'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 19:38:01'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 20:15:31'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 21:14:51'AS datetime) ),
(5,CAST('2017-01-16' AS date),CAST('2017-01-15 21:24:22'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 21:48:21'AS datetime) ),
(5,CAST('2017-01-15' AS date),CAST('2017-01-15 21:55:31'AS datetime) ),
(NULL,CAST('2017-01-15' AS date),CAST('2017-01-15 18:19:10'AS datetime) ),
(NULL,CAST('2017-01-16' AS date),CAST('2017-01-15 13:14:12'AS datetime) ),
(NULL,CAST('2017-01-17' AS date),CAST('2017-01-15 14:36:21'AS datetime) ),
(NULL,CAST('2017-01-16' AS date),CAST('2017-01-15 08:02:25'AS datetime) ),
(NULL,CAST('2017-01-16' AS date),CAST('2017-01-15 06:15:36'AS datetime) )
GO

INSERT INTO dbo.Poz_Biletu VALUES   
(1,1,1,67,NULL),(1,2,2,67,'Dzieci powy¿ej 4 lat'),
(2,1,1,19,NULL),
(3,1,2,74,NULL),
(4,1,1,19,'Studenci'),
(5,1,1,90,NULL), (5,2,1,90,'Emeryci'), 
(6,1,2,115,'Studenci'),
(7,1,1,67,NULL),(7,2,1,67,'Dzieci poni¿ej 4 lat'),
(8,1,1,115,NULL),
(9,1,2,67,'Kombatanci'),
(10,1,1,67,NULL),
(11,1,2,41,NULL),(11,2,1,41,'Inwalidzka'),(11,3,1,41,'Dzieci powy¿ej 4 lat'),
(12,1,1,52,'Emeryci'),
(13,1,1,52,NULL),
(14,1,1,2,'Studenci'),
(15,1,1,59,NULL),
(16,1,1,62,NULL),(16,2,1,62,'Dzieci powy¿ej 4 lat'),
(17,1,2,5,'Studenci'),
(18,1,1,42,'Emeryci'),
(19,1,1,53,'Funkcyjna'),
(20,1,2,34,'Studenci'),
(21,1,1,21,NULL),
(22,1,2,124,'Emeryci'),
(23,1,1,42,NULL),
(24,1,1,35,'Studenci'),
(25,1,2,57,NULL),(25,2,1,57,'Dzieci powy¿ej 4 lat'),
(26,1,1,80,'Dzieci powy¿ej 4 lat'),                 
(27,1,2,85,'Emeryci'),
(28,1,1,85,NULL),(28,2,1,85,'Dzieci poni¿ej 4 lat'),
(29,1,1,6,NULL),                 
(30,1,2,6,'Studenci'),                 
(31,1,1,85,'Emeryci'),                 
(32,1,1,7,NULL),(32,2,2,7,'Dzieci powy¿ej 4 lat'),(32,3,1,109,NULL),(32,4,2,109,'Dzieci powy¿ej 4 lat'), 
(33,1,2,140,NULL)
--(,,,,), (,,,,), (,,,,), (,,,,), (,,,,), (,,,,), (,,,,), (,,,,), 
GO

-- -------------------------------------------
-- Usuwanie i tworzenie widoków
-- -------------------------------------------

--widok pokazuj¹cy wszystkie informacje z bazy danych dotycz¹ce sprzedanego biletu

IF OBJECT_ID('BiletInfo','V') IS NOT NULL
	DROP VIEW BiletInfo
GO

CREATE VIEW BiletInfo AS
	SELECT 
		H.id_Biletu,H.id_Poz,H.Data_Podrozy,H.Data_Sprzedazy,H.id_Znizki [Nazwa Znizki],H.Ile_procent,
		H.Liczba_Podroznych,H.Skad,H.Dokad,H.Odleglosc_w_km,H.Numer,H.Wyjechal,H.Z,H.DO,H.Typ,H.Cena_za_1km_KL1,
		H.Cena_za_1km_KL2,H.Kategoria, J.Imie,J.Nazwisko,J.Zatrudniony,J.W_Kasie,J.Na_Dworcu 
		FROM 
		(SELECT * FROM Kasy KY INNER JOIN 
		(SELECT * FROM Kasjer_Sprzedawca  KS INNER JOIN 
		Sprzedawal SP   ON KS.id_K_S = SP.Kasjer 
		)  X  ON  KY.Kasa = X.W_Kasie
		)  J 
		RIGHT JOIN
		(SELECT * FROM Bilet BT INNER JOIN  
		(SELECT * FROM Znizka ZN RIGHT JOIN 
		(SELECT * FROM  Poz_Biletu PBI INNER JOIN  
		(SELECT * FROM Cel_Podrozy CP INNER JOIN 
		(SELECT * FROM Dojade DOJ INNER JOIN 
		(SELECT * FROM Pociag POC INNER JOIN
		(SELECT * FROM Zestaw_Polaczen ZP INNER JOIN
		(SELECT * FROM Typ_Polaczen TP INNER JOIN 
		Polaczenie POL   ON TP.Typ = POL.id_Typ_Pol
		)   A   ON ZP.id_Z_P = A.id_Zes_Pol
		)   B   ON POC.id_Polaczenia = B.id_P
		)   C   ON DOJ.Pociagiem = C.Numer
		)   D   ON CP.id_C_P = D.id_Cel
		)   E   ON PBI.id_Dojade = E.id_D
		)   F   ON ZN.Nazwa = F.id_Znizki
		)   G   ON  BT.id_B = G.id_Biletu
		)   H   ON J.id_S = H.id_Sprzedane 
GO

--procentowy udzia³ ka¿dego z kasjerów w sprzeda¿y biletów 

IF OBJECT_ID('ProcentSprzedanych','V') IS NOT NULL
	DROP VIEW ProcentSprzedanych
GO

CREATE VIEW ProcentSprzedanych AS
	SELECT T1.Imie,T1.Nazwisko,T1.Zatrudniony,T1.[Liczba Biletow],
	ROUND(CAST((T1.[Liczba Biletow]*100) AS float) /T2.[Wszystkie Bilety],2) [ProcentowaSprzedaz]
	FROM 
	(SELECT C.Imie,C.Nazwisko,C.Zatrudniony, COUNT(*)[Liczba Biletow] 
	FROM
	(SELECT B.id_B,A.id_K_S,A.Imie,A.Nazwisko,A.Zatrudniony 
	FROM Bilet B INNER JOIN
	(SELECT K.id_K_S,K.Imie,K.Nazwisko,K.Zatrudniony,S.id_S  
	FROM Kasjer_Sprzedawca K INNER JOIN Sprzedawal S ON S.Kasjer=K.id_K_S
	) A  ON A.id_S= B.id_Sprzedane
	) C   GROUP BY  C.id_K_S, C.Imie,C.Nazwisko,C.Zatrudniony )  T1,
	(SELECT COUNT(id_B) [Wszystkie Bilety]  
	FROM Bilet WHERE id_Sprzedane IS NOT NULL)  T2 
GO 

-- który cel podró¿y najczêœciej wybierali podró¿ni i jaki typ po³¹czeñ 

IF OBJECT_ID('NajwiecejPodroznych','V') IS NOT NULL
	DROP VIEW NajwiecejPodroznych
GO

CREATE VIEW NajwiecejPodroznych AS
	SELECT G.Skad,G.Dokad,G.id_Typ_Pol [Typ Polaczenia] ,SUM(G.Liczba_Podroznych) [Liczba Podroznych] FROM
	(SELECT * FROM Cel_Podrozy CP INNER JOIN
	(SELECT * FROM Polaczenie PL INNER JOIN
	(SELECT * FROM Pociag  PO INNER JOIN
	(SELECT * FROM Dojade DO INNER JOIN 
	(SELECT * FROM Bilet  A LEFT JOIN Poz_Biletu  B ON B.id_Biletu = A.id_B
	)  C  ON  C.id_Dojade = DO.id_D
	)  D  ON  D.Pociagiem = PO.Numer 
	)  E  ON  E.id_Polaczenia = PL.id_P
	)  F  ON  F.id_Cel = CP.id_C_P 
	)  G  GROUP BY G.Skad,G.Dokad,G.id_Typ_Pol 
GO
-- ---------------------------------------------
-- Usuwanie i tworzenie procedur
-- ---------------------------------------------

-- ile biletów procentowo sprzedano bez poœrednictwa kasjera 

IF OBJECT_ID('IleBiletow','P') IS NOT NULL
	DROP PROCEDURE IleBiletow
GO

CREATE PROCEDURE IleBiletow AS
	SELECT B.[Wszystkie Bilety] , A.[Bilety bez Kasjera],
	ROUND(CAST(A.[Bilety bez Kasjera]*100 AS float) /B.[Wszystkie Bilety],2) [%_BezKasjera] 
	FROM 
	(SELECT COUNT(id_B) [Bilety bez Kasjera] FROM Bilet  WHERE id_Sprzedane IS NULL ) A,  
	(SELECT COUNT(id_B) [Wszystkie Bilety]  FROM Bilet)  B 		
GO		
-- ilu podró¿nych procentowo korzysta³o ze zni¿ki lub nie.

IF OBJECT_ID('PodroznyZnizka','P') IS NOT NULL
	DROP PROCEDURE PodroznyZnizka
GO

CREATE PROCEDURE PodroznyZnizka AS
	SELECT A.id_Znizki [Nazwa Znizki], A.[Liczba Podroznych ],
	ROUND(CAST(A.[Liczba Podroznych ] * 100 AS float)/B.[Liczba Podroznych],2) [%Podroznych ]
	FROM
	((SELECT id_Znizki, SUM(Liczba_Podroznych) [Liczba Podroznych ] 
	FROM Poz_Biletu WHERE id_Znizki IS NOT NULL GROUP BY id_Znizki) 
	UNION  
	(SELECT ISNULL(id_Znizki,'BRAK ZNI¯KI'), SUM(Liczba_Podroznych) [Liczba Podroznych] 
	FROM Poz_Biletu WHERE id_Znizki IS  NULL GROUP BY id_Znizki) ) A ,
	(SELECT SUM(Liczba_Podroznych) [Liczba Podroznych]  
	FROM Poz_Biletu) B
GO

--procedura wykazuj¹ca iloœæ sprzedanych biletów w poszczególnych kasach w okresie od dnia do dnia

IF OBJECT_ID('BiletyWKasach','P') IS NOT NULL
	DROP PROCEDURE BiletyWKasach
GO

CREATE PROCEDURE BiletyWKasach (@data AS date,@data2 AS date) AS
	SELECT K.Kasa , (SELECT ISNULL(SUM(C.[Lczba Biletow]),0)  
	FROM
	(SELECT A.[Lczba Biletow],S.W_Kasie [Miejsce Sprzedazy] 
	FROM Sprzedawal S INNER JOIN
	(SELECT COUNT(B.id_B) [Lczba Biletow], B.id_Sprzedane 
	FROM Bilet B WHERE CAST(B.Data_Sprzedazy AS date) BETWEEN @data AND @data2
	GROUP BY B.id_Sprzedane
	)  A  ON A.id_Sprzedane = S.id_S   
	)  C  WHERE C.[Miejsce Sprzedazy] = K.Kasa) [Liczba Biletow] 
	FROM Kasy K
GO
--procedura umo¿liwiaj¹ca podanie wszystkich informacji znajduj¹cych siê na bilecie

IF OBJECT_ID('ZawartoscBiletu','P')IS NOT NULL
	DROP PROCEDURE ZawartoscBiletu
GO

CREATE PROCEDURE ZawartoscBiletu  (@biletNr  AS int) AS
	SELECT 
		H.id_Biletu,H.id_Poz,H.Data_Podrozy,H.Data_Sprzedazy,H.id_Znizki [Nazwa Znizki],H.Ile_procent,
		H.Liczba_Podroznych,H.Skad,H.Dokad,H.Odleglosc_w_km,H.Numer,H.Wyjechal,H.Z,H.DO,H.Typ,H.Cena_za_1km_KL1,
		H.Cena_za_1km_KL2,H.Kategoria, J.Imie,J.Nazwisko,J.Zatrudniony,J.W_Kasie,J.Na_Dworcu 
		FROM 
		(SELECT * FROM Kasy KY INNER JOIN 
		(SELECT * FROM Kasjer_Sprzedawca  KS INNER JOIN 
		Sprzedawal SP   ON KS.id_K_S = SP.Kasjer 
		)  X  ON  KY.Kasa = X.W_Kasie
		)  J 
		RIGHT JOIN
		(SELECT * FROM Bilet BT INNER JOIN  
		(SELECT * FROM Znizka ZN RIGHT JOIN 
		(SELECT * FROM  Poz_Biletu PBI INNER JOIN  
		(SELECT * FROM Cel_Podrozy CP INNER JOIN 
		(SELECT * FROM Dojade DOJ INNER JOIN 
		(SELECT * FROM Pociag POC INNER JOIN
		(SELECT * FROM Zestaw_Polaczen ZP INNER JOIN
		(SELECT * FROM Typ_Polaczen TP INNER JOIN 
		Polaczenie POL   ON TP.Typ = POL.id_Typ_Pol
		)   A   ON ZP.id_Z_P = A.id_Zes_Pol
		)   B   ON POC.id_Polaczenia = B.id_P
		)   C   ON DOJ.Pociagiem = C.Numer
		)   D   ON CP.id_C_P = D.id_Cel
		)   E   ON PBI.id_Dojade = E.id_D
		)   F   ON ZN.Nazwa = F.id_Znizki
		)   G   ON  BT.id_B = G.id_Biletu
		)   H   ON J.id_S = H.id_Sprzedane WHERE H.id_Biletu=@biletNr
GO

-- ----------------------------------------
-- Usuwanie i tworzenie funkcji
-- ----------------------------------------

--wyci¹ga z bazy danych godziny i przypadajace im liczby sprzedanych biletów okreœlonego dnia

IF OBJECT_ID('Godzina','IF') IS NOT NULL
	DROP FUNCTION Godzina
GO

CREATE FUNCTION Godzina (@data AS DATE)
	RETURNS TABLE
	AS
	RETURN
		SELECT 
			[Liczba Biletow] = COUNT(B.id_B),
			[GODZINY] = DATEPART(HH,B.Data_Sprzedazy) 
		FROM Bilet B
		WHERE CAST(B.Data_Sprzedazy AS date)  = @data
		GROUP BY DATEPART(HH,B.Data_Sprzedazy)  
	
GO
-- ---------------------------------------------------
-- wywo³ania procedur widoków i funkcji
-- ---------------------------------------------------

PRINT 'Wszystkie informacje zawarte na bilecie' --do koorzystania z bazy danych
SELECT * FROM BiletInfo H ORDER BY H.id_Biletu

PRINT 'Procentowy udzia³ kasjerów w sprzeda¿y biletów (kupionych w kasach)'
SELECT * FROM ProcentSprzedanych PS ORDER BY PS.[Liczba Biletow] DESC

PRINT 'Cele podró¿y i typ po³¹czenia najczêœciej wybierany przez podró¿nych'
SELECT TOP 5 * FROM NajwiecejPodroznych NP ORDER BY NP.[Liczba Podroznych] DESC

PRINT 'Procentowa sprzeda¿ bez poœrednictwa kasjera (online lub biletomaty)'
EXEC IleBiletow

PRINT 'Procentowy udzia³ podró¿nych w przejazdach "normalnych" i "ulgowych"'
EXEC PodroznyZnizka

PRINT'Liczba biletów sprzedanych w poszczególnych kasach w okresie od dnia do dnia '
EXEC BiletyWKasach '2017-01-15' , '2017-01-15'

DECLARE @NumerBiletu AS int  
SET @NumerBiletu = '32'
PRINT 'Informacja na bilecie nr '+ CAST(@NumerBiletu AS varchar(7)) 
EXEC ZawartoscBiletu @NumerBiletu  --do korzystania z bazy danych

PRINT 'Godziny danego dnia i przypadaj¹ca im liczba sprzedanych biletów'
SELECT'O godzinie '+CAST(GODZINY AS varchar)+' sprzedano '+ cast([Liczba Biletow]AS varchar)
+ ' biletów' [Jednego Dnia]
FROM Godzina('2017-01-15') ORDER BY [Liczba Biletow] DESC

-- ---------------------------------------------
-- Usuniêcie bazy
-- ---------------------------------------------

USE master
GO

IF DB_ID('PKP') IS NOT NULL
	DROP DATABASE PKP
GO	




------------------------------------------------	   

--USE PKP
--GO 

--IF OBJECT_ID('Ingredients','U') IS NOT NULL
--	DROP TABLE Ingredients
--GO
--IF OBJECT_ID('Orders','U') IS NOT NULL
--	DROP TABLE Orders
--GO
--IF OBJECT_ID('Clients','U') IS NOT NULL
--	DROP TABLE Clients
--GO
--IF OBJECT_ID('Courses','U') IS NOT NULL
--	DROP TABLE Courses
--GO
--IF OBJECT_ID('Categories','U') IS NOT NULL
--	DROP TABLE Categories
--GO

------------------------------------------------
