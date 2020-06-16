/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 10g                            */
/* Date de cr�ation :  08/05/2020 16:53:26                      */
/*==============================================================*/

SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';
/*==============================================================*/
/* INSERTION DES VALEURS DANS  LES TABLES                       */
/*==============================================================*/ 

/* Insertion des valeurs dans la table societe                  */

insert into societe values(145,'ShrekxyDance','Nice','10/08/2019','3630');

/* Insertion des valeurs dans la table employe                  */

insert into employe values(1,145,'Montana','Tony','Responsable','Havana',5000.00,'0640',30,'H','10/08/2019',null);
insert into employe values(2,145,'Miranda','Serge','Barman','Sophia-Antipolis',3000.0,'2222',32,'H','10/08/2019',null);
insert into employe values(3,145,'Mopolo','Gabriel','Barman','Nice',2550.0,'3333',26,'H','20/09/2019',null);
insert into employe values(4,145,'Chapoulie','Dorian','Agent de nettoyage','Nice',1650.0,'3333',21,'H','25/08/2019',null);
insert into employe values(5,145,'Guillaumet','Leo','Agent de nettoyage','Nice',1500.0,'4444',21,'H','05/12/2019',null);
insert into employe values(6,145,'Bolier','Raphael','Serveur','Nice',2100.6,'5555',21,'H','10/09/2019',null);
insert into employe values(7,145,'Longin','Remi','Serveur','Nice',2100.0,'6666',21,'H','22/09/2019',null);
insert into employe values(8,145,'Laurendeau','Yohann','Agent de s�curit�','Nice',2100.0,'7777',21,'H','27/09/2019',null);
insert into employe values(9,145,'Washington','Komuro','Agent de s�curit�','Carros',2150.0,'8888',23,'H','18/09/2019',null);
insert into employe values(10,145,'Boban','Bobi','Animateur','Grasse',2100.0,'9999',22,'H','12/08/2019',null);
insert into employe values(11,145,'Pelle','Sarah','Secr�taire','Nice',2300.0,'1010',25,'F','14/08/2019',null);
insert into employe values(12,145,'Spears','Britney','Hotesse','Nice',2500.0,'11110',25,'F','17/08/2019',null);
insert into employe values(13,145,'Hanna','Ri','Hotesse','Nice',2700.0,'12120',28,'F','23/08/2019',null);
insert into employe values(14,145,'Jenner','Caitlyn','Hotesse','Carros',2600.0,'13130',32,'F','02/09/2019',null);
insert into employe values(15,145,'Bras','Gros','Agent de s�curit�','Nice',2100.0,'14140',26,'H','05/10/2019',null);
insert into employe values(16,145,'Gangsta','Arouf','DJ','Nice',3200.0,'15150',32,'H','12/08/2019',null);

/* Insertion des valeurs dans la table comptecb                  */

insert into comptecb values (001,145,'BNP Paribas',34489.51);

/* Insertion des valeurs dans la table fournisseur               */

insert into fournisseur values (1,'MiamExpress','Nourriture','1111','Nice');
insert into fournisseur values(2,'UberBiere','Boisson','2222','Nice');
insert into fournisseur values(3,'SpeedyBoisson','Boisson','3333','Antibes');
insert into fournisseur values(4,'DistriBoisson','Boisson','4444','Carros');
insert into fournisseur values(5,'EasySnack','Nourriture','5555','Grasse');
insert into fournisseur values(6,'PartyDrink','Boisson','6666','Nice');
insert into fournisseur values(7,'DriveSnack','Nourriture','7777','Nice');
insert into fournisseur values(8,'DrinkTransport','Boisson','8888','Antibes');
insert into fournisseur values(9,'EthyloFrance','Boisson','9999','Cannes');
insert into fournisseur values(10,'FranceBoisson','Boisson','1010','Lyon');
insert into fournisseur values(11,'AperoTruck','Nourriture','1011','Marseille');

/* Insertion des valeurs dans la table client             */

insert into client values (1,'Blanc','Michel');
insert into client values (2,'Blanc','Laurent');
insert into client values (3,'Gilou','Sergent');
insert into client values (4,'Boudboule','Dovi');
insert into client values (5,'Cadillac','Johnny');
insert into client values (6,'Fabre','Nans');
insert into client values (7,'Fabre','Didier');
insert into client values (8,'Laurendeau','Jean-Jacques');
insert into client values (9,'Bogoss','Kevin');
insert into client values (10,'Pitt','Brad');
insert into client values (11,'Gibson','Mel');
insert into client values (12,'LePoivrot','Thierry');
insert into client values (13,'Bar','Lenny');
insert into client values (14,'Colique','Al');
insert into client values (15,'Gumble','Barney');
insert into client values (16,'Jackson','Michael');
insert into client values (17,'Shakur','Tupac');


/* Insertion des valeurs dans la table produit           */

insert into produit values (1,'Bouteille de Absolut','Bouteille Alcool-Vodka',15.5,5);
insert into produit values (2,'Bouteille de Poliakov','Bouteille Alcool-Vodka',11.5,5);
insert into produit values (3,'Bouteille de GreyGoose','Bouteille Alcool-Vodka',35.5,5);
insert into produit values (4,'Bouteille de Smirnoff','Bouteille Alcool-Vodka',12.97,5);
insert into produit values (5,'Bouteille de J�germeister','Bouteille Alcool',20.0,5);
insert into produit values (6,'Bouteille de Ballantines','Bouteille Alcool-Whisky',57.0,5);
insert into produit values (7,'Bouteille de Jack Daniels','Bouteille Alcool-Whisky',28.53,5);
insert into produit values (8,'Bouteille de Captain Morgan','Bouteille Alcool-Rhum',12.98,5);
insert into produit values (9,'Bouteille de Havana Club','Bouteille Alcool-Rhum',22.08,5);
insert into produit values (10,'Bouteille de Bacardi','Bouteille Alcool-Rhum',15.30,5);
insert into produit values (11,'Bouteille de Leffe','Bouteille Alcool-Biere Blonde',2.58,5);
insert into produit values (12,'Bouteille de Leffe','Bouteille Alcool-Biere Ambree',1.50,5);
insert into produit values (13,'Bouteille de Guiness','Bouteille Alcool-Biere Brune',3.43,5);
insert into produit values (14,'Bouteille de Martini','Bouteille Alcool-Coktail',7.52,5);
insert into produit values (15,'Bouteille de Gin tonic','Bouteille Alcool-Coktail',8.20,5);
insert into produit values (16,'Cannette de Coca Cola','Soda',1.71,5);
insert into produit values (17,'Packet de Cacahuetes','Nourriture',2.5,5);
insert into produit values (18,'Packet Olives','Nourriture',2.5,5);

/* Insertion des valeurs dans la table stock          */

insert into stock values (111,145,1,5);
insert into stock values (222,145,2,4);
insert into stock values (333,145,3,4);
insert into stock values (444,145,4,7);
insert into stock values (555,145,5,5);
insert into stock values (666,145,6,6);
insert into stock values (777,145,7,5);
insert into stock values (888,145,8,6);
insert into stock values (999,145,9,9);
insert into stock values (1000,145,10,5);
insert into stock values (1100,145,11,40);
insert into stock values (1200,145,12,32);
insert into stock values (1300,145,13,25);
insert into stock values (1400,145,14,4);
insert into stock values (1500,145,15,3);
insert into stock values (1600,145,16,30);
insert into stock values (1700,145,17,17);
insert into stock values (1800,145,18,12);

/* Insertion des valeurs dans la table transaction           */

insert into transaction values (01,001,1,'VENTE',95.52,'28/08/2019','Carte bancaire');
insert into transaction values (02,001,2,'VENTE',10.20,'25/08/2019','Liquide');
insert into transaction values (03,001,3,'VENTE',55.30,'15/08/2019','Carte bancaire');
insert into transaction values (04,001,4,'VENTE',23.69,'15/08/2019','Liquide');
insert into transaction values (05,001,5,'VENTE',2.58,'15/08/2019','Liquide');
insert into transaction values (06,001,6,'VENTE',34.22,'17/08/2019','Carte bancaire');
insert into transaction values (07,001,null,'ACHAT',88.25,'10/08/2019','Carte bancaire');
insert into transaction values (08,001,null,'ACHAT',56.70,'17/08/2019','Carte bancaire');
insert into transaction values (09,001,null,'ACHAT',15.05,'19/08/2019','Carte bancaire');
insert into transaction values (010,001,null,'ACHAT',42.85,'25/08/2019','Carte bancaire');
insert into transaction values (011,001,null,'ACHAT',68.80,'15/09/2019','Carte bancaire');
insert into transaction values (012,001,null,'ACHAT',14.18,'08/10/2019','Carte bancaire');
insert into transaction values (013,001,null,'ACHAT',39.45,'05/11/2019','Carte bancaire');
insert into transaction values (014,001,null,'ACHAT',29.90,'28/11/2019','Carte bancaire');
insert into transaction values (015,001,null,'ACHAT',72.00,'10/12/2019','Carte bancaire');
insert into transaction values (016,001,null,'ACHAT',42.10,'20/12/2019','Carte bancaire');
insert into transaction values (017,001,null,'ACHAT',110.80,'05/01/2020','Carte bancaire');

/* Insertion des valeurs dans la table commande           */

insert into ligne_commande values (1111,1,2);
insert into ligne_commande values (2222,2,4);
insert into ligne_commande values (3333,5,3);
insert into ligne_commande values (4444,7,5);
insert into ligne_commande values (5555,11,32);
insert into ligne_commande values (6666,15,2);
insert into ligne_commande values (7777,16,30);
insert into ligne_commande values (8888,8,3);
insert into ligne_commande values (9999,17,20);
insert into ligne_commande values (1010,12,30);
insert into ligne_commande values (1011,13,30);
insert into ligne_commande values (1012,13,30);
insert into ligne_commande values (1013,13,10);


/* Insertion des valeurs dans la table commande           */

insert into commande values (101,1,1111,145,07,'10/08/2019','15/08/2019');
insert into commande values (102,2,2222,145,08,'17/08/2019','23/08/2019');
insert into commande values (103,3,3333,145,09,'19/08/2019','24/08/2019');
insert into commande values (104,4,4444,145,010,'25/08/2019','03/09/2019');
insert into commande values (105,5,5555,145,011,'15/09/2019','28/09/2019');
insert into commande values (106,6,6666,145,012,'08/10/2019','17/10/2019');
insert into commande values (107,7,7777,145,013,'05/11/2019','12/11/2019');
insert into commande values (108,8,8888,145,014,'28/11/2019','05/12/2019');
insert into commande values (109,9,9999,145,015,'10/12/2019','16/12/2019');
insert into commande values (110,10,1010,145,016,'20/12/2019','27/12/2019');
insert into commande values (111,11,1011,145,017,'05/01/2020','12/01/2020');
