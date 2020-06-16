/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 10g                            */
/* Date de crï¿½ation :  08/05/2020 16:53:26                      */
/*==============================================================*/

SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';
--Crï¿½ation des packages
DROP PACKAGE package_commande;
DROP PACKAGE package_produit;

CREATE or replace PACKAGE package_commande as 
    PROCEDURE Ainserer (idsociete in number, idproduit in number, quantite in number, idcompte in number);
    PROCEDURE AmodifierF1(idCommande in number, nbDay in number);
    PROCEDURE Alister;
    PROCEDURE AF1;
    PROCEDURE AF2;
    PROCEDURE AF3;
    PROCEDURE AmodifierF2(idCommande in number, idFournisseur in number);
    PROCEDURE Asupprimer (idCommande in number);
END package_commande;
/
CREATE or replace PACKAGE package_produit as 
   PROCEDURE Binserer (nom in varchar, des in varchar, prix in number, utilisation in number);
   PROCEDURE Bsupprimer (identifiant in number);
   PROCEDURE Blister(idFournisseur in number);
   PROCEDURE BmodifierF1(idProduit in number);
   PROCEDURE BmodifierF2(idProduit in number, newPrice in number);
END package_produit;
/

alter table COMMANDE
   drop constraint FK_COMMANDE_APPLIQUER_TRANSACT;

alter table COMMANDE
   drop constraint FK_COMMANDE_CONTENIR_LIGNE_CO;

alter table COMMANDE
   drop constraint FK_COMMANDE_EFFECTUER_SOCIETE;

alter table COMMANDE
   drop constraint FK_COMMANDE_ENVOYER_FOURNISS;

alter table COMPTECB
   drop constraint FK_COMPTECB_POSSEDER_SOCIETE;

alter table CONCERNER
   drop constraint FK_CONCERNE_CONCERNER_TRANSACT;

alter table CONCERNER
   drop constraint FK_CONCERNE_CONCERNER_PRODUIT;

alter table EMPLOYE
   drop constraint FK_EMPLOYE_EMPLOYER_SOCIETE;

alter table LIGNE_COMMANDE
   drop constraint FK_LIGNE_CO_COMPOSER__PRODUIT;

alter table LIVRER
   drop constraint FK_LIVRER_LIVRER_FOURNISS;

alter table LIVRER
   drop constraint FK_LIVRER_LIVRER2_PRODUIT;

alter table STOCK
   drop constraint FK_STOCK_CONTENIR__PRODUIT;

alter table STOCK
   drop constraint FK_STOCK_STOCKER_SOCIETE;

alter table TRANSACTION
   drop constraint FK_TRANSACT_FACTURER_CLIENT;

alter table TRANSACTION
   drop constraint FK_TRANSACT_METTRE_A__COMPTECB;

drop table CLIENT cascade constraints;

drop index CONTENIR_FK;

drop index APPLIQUER_FK;

drop index ENVOYER_FK;

drop index EFFECTUER_FK;

drop table COMMANDE cascade constraints;

drop index POSSEDER_FK;

drop table COMPTECB cascade constraints;

drop index CONCERNER2_FK;

drop index CONCERNER_FK;

drop table CONCERNER cascade constraints;

drop index EMPLOYER_FK;

drop table EMPLOYE cascade constraints;

drop table FOURNISSEUR cascade constraints;

drop index COMPOSER_DE_FK;

drop table LIGNE_COMMANDE cascade constraints;

drop index LIVRER2_FK;

drop index LIVRER_FK;

drop table LIVRER cascade constraints;

drop table PRODUIT cascade constraints;

drop table SOCIETE cascade constraints;

drop index CONTENIR_DES_FK;

drop index STOCKER_FK;

drop table STOCK cascade constraints;

drop index METTRE_A_JOUR_FK;

drop index FACTURER_FK;

drop table TRANSACTION cascade constraints;

/*==============================================================*/
/* Table : CLIENT                                               */
/*==============================================================*/
create table CLIENT  (
   CLIENT_ID            NUMBER(5)                       not null,
   CLIENT_NOM           VARCHAR2(50),
   CLIENT_PRENOM        VARCHAR2(50),
   constraint PK_CLIENT primary key (CLIENT_ID)
);

/*==============================================================*/
/* Table : COMMANDE                                             */
/*==============================================================*/
create table COMMANDE  (
   COMMANDE_ID          NUMBER(5)                       not null,
   FOURNISSEUR_ID       NUMBER(5)                       not null,
   LIGNECOMMANDE_ID     NUMBER(5),
   SOCIETE_ID           NUMBER(5)                       not null,
   TRANSACTION_ID       NUMBER(5),
   COMMANDE_DATE        DATE                            not null,
   COMMANDE_LIVRAISON   DATE,
   constraint PK_COMMANDE primary key (COMMANDE_ID)
);

/*==============================================================*/
/* Index : EFFECTUER_FK                                         */
/*==============================================================*/
create index EFFECTUER_FK on COMMANDE (
   SOCIETE_ID ASC
);

/*==============================================================*/
/* Index : ENVOYER_FK                                           */
/*==============================================================*/
create index ENVOYER_FK on COMMANDE (
   FOURNISSEUR_ID ASC
);

/*==============================================================*/
/* Index : APPLIQUER_FK                                         */
/*==============================================================*/
create index APPLIQUER_FK on COMMANDE (
   TRANSACTION_ID ASC
);

/*==============================================================*/
/* Index : CONTENIR_FK                                          */
/*==============================================================*/
create index CONTENIR_FK on COMMANDE (
   LIGNECOMMANDE_ID ASC
);

/*==============================================================*/
/* Table : COMPTECB                                             */
/*==============================================================*/
create table COMPTECB  (
   COMPTECB_ID          NUMBER(5)                       not null,
   SOCIETE_ID           NUMBER(5)                       not null,
   COMPTE_AGENCE        VARCHAR2(50)                    not null,
   COMPTECB_SOLDE       NUMBER(9,2)                     not null
      constraint CKC_COMPTECB_SOLDE_COMPTECB check (COMPTECB_SOLDE >= 0),
   constraint PK_COMPTECB primary key (COMPTECB_ID)
);

/*==============================================================*/
/* Index : POSSEDER_FK                                          */
/*==============================================================*/
create index POSSEDER_FK on COMPTECB (
   SOCIETE_ID ASC
);

/*==============================================================*/
/* Table : CONCERNER                                            */
/*==============================================================*/
create table CONCERNER  (
   TRANSACTION_ID       NUMBER(5)                       not null,
   PRODUIT_ID           NUMBER(8)                       not null,
   constraint PK_CONCERNER primary key (TRANSACTION_ID, PRODUIT_ID)
);

/*==============================================================*/
/* Index : CONCERNER_FK                                         */
/*==============================================================*/
create index CONCERNER_FK on CONCERNER (
   TRANSACTION_ID ASC
);

/*==============================================================*/
/* Index : CONCERNER2_FK                                        */
/*==============================================================*/
create index CONCERNER2_FK on CONCERNER (
   PRODUIT_ID ASC
);

/*==============================================================*/
/* Table : EMPLOYE                                              */
/*==============================================================*/
create table EMPLOYE  (
   EMPLOYE_ID           NUMBER(5)                       not null,
   SOCIETE_ID           NUMBER(5)                       not null,
   EMPLOYE_NOM          VARCHAR2(50)                    not null,
   EMPLOYE_PRENOM       VARCHAR2(50)                    not null,
   EMPLOYE_TYPE         VARCHAR2(50)                    not null,
   EMPLOYE_ADRESSE      VARCHAR2(50)                    not null,
   EMPLOYE_SALAIRE      NUMBER(8,2)                     not null
      constraint CKC_EMPLOYE_SALAIRE_EMPLOYE check (EMPLOYE_SALAIRE between 0 and 50000),
   EMPLOYE_TELEPHONE    VARCHAR2(10)                    not null,
   EMPLOYE_AGE          NUMBER(2)                      
      constraint CKC_EMPLOYE_AGE_EMPLOYE check (EMPLOYE_AGE is null or (EMPLOYE_AGE >= 0)),
   EMPLOYE_SEXE         VARCHAR2(50),
   EMPLOYE_DATEEMB      DATE,
   PHOTO                BLOB,
   constraint PK_EMPLOYE primary key (EMPLOYE_ID)
);

/*==============================================================*/
/* Index : EMPLOYER_FK                                          */
/*==============================================================*/
create index EMPLOYER_FK on EMPLOYE (
   SOCIETE_ID ASC
);

/*==============================================================*/
/* Table : FOURNISSEUR                                          */
/*==============================================================*/
create table FOURNISSEUR  (
   FOURNISSEUR_ID       NUMBER(5)                       not null,
   FOURNISSEUR_NOM      VARCHAR2(50)                    not null,
   FOURNISSEUR_TYPE     VARCHAR2(20)                    not null
      constraint CKC_FOURNISSEUR_TYPE_FOURNISS check (FOURNISSEUR_TYPE in ('Boisson','Nourriture')),
   FOURNISSEUR_TELEPHONE VARCHAR2(10),
   FOURNISSEUR_ADRESSE  VARCHAR2(50)                    not null,
   constraint PK_FOURNISSEUR primary key (FOURNISSEUR_ID)
);

/*==============================================================*/
/* Table : LIGNE_COMMANDE                                       */
/*==============================================================*/
create table LIGNE_COMMANDE  (
   LIGNECOMMANDE_ID     NUMBER(5)                       not null,
   PRODUIT_ID           NUMBER(8),
   LIGNECOMMANDE_QUANTITE NUMBER(5)                      default 1 not null
      constraint CKC_LIGNECOMMANDE_QUA_LIGNE_CO check (LIGNECOMMANDE_QUANTITE between 0 and 999),
   constraint PK_LIGNE_COMMANDE primary key (LIGNECOMMANDE_ID)
);

/*==============================================================*/
/* Index : COMPOSER_DE_FK                                       */
/*==============================================================*/
create index COMPOSER_DE_FK on LIGNE_COMMANDE (
   PRODUIT_ID ASC
);

/*==============================================================*/
/* Table : LIVRER                                               */
/*==============================================================*/
create table LIVRER  (
   FOURNISSEUR_ID       NUMBER(5)                       not null,
   PRODUIT_ID           NUMBER(8)                       not null,
   constraint PK_LIVRER primary key (FOURNISSEUR_ID, PRODUIT_ID)
);

/*==============================================================*/
/* Index : LIVRER_FK                                            */
/*==============================================================*/
create index LIVRER_FK on LIVRER (
   FOURNISSEUR_ID ASC
);

/*==============================================================*/
/* Index : LIVRER2_FK                                           */
/*==============================================================*/
create index LIVRER2_FK on LIVRER (
   PRODUIT_ID ASC
);

/*==============================================================*/
/* Table : PRODUIT                                              */
/*==============================================================*/
create table PRODUIT  (
   PRODUIT_ID           NUMBER(8)                       not null,
   PRODUIT_NOM          VARCHAR2(100)                   not null,
   PRODUIT_DESC         VARCHAR2(100)                   not null,
   PRODUIT_PRIX         NUMBER(8,2)                     not null
      constraint CKC_PRODUIT_PRIX_PRODUIT check (PRODUIT_PRIX between 0 and 5000),
   PRODUIT_UTILISATION  NUMBER(3)                       not null
      constraint CKC_PRODUIT_UTILISATI_PRODUIT check (PRODUIT_UTILISATION >= 0 and PRODUIT_UTILISATION in (1,2,3,4,5,6,7,8,9,10)),
   constraint PK_PRODUIT primary key (PRODUIT_ID)
);

/*==============================================================*/
/* Table : SOCIETE                                              */
/*==============================================================*/
create table SOCIETE  (
   SOCIETE_ID           NUMBER(5)                       not null,
   SOCIETE_NOM          VARCHAR2(50)                    not null,
   SOCIETE_ADRESSE      VARCHAR2(50)                    not null,
   SOCIETE_DATECREATION DATE                            not null,
   SOCIETE_TELEPHONE    VARCHAR2(10),
   constraint PK_SOCIETE primary key (SOCIETE_ID)
);

/*==============================================================*/
/* Table : STOCK                                                */
/*==============================================================*/
create table STOCK  (
   STOCK_ID             NUMBER(5)                       not null,
   SOCIETE_ID           NUMBER(5)                       not null,
   PRODUIT_ID           NUMBER(8),
   STOCK_QUANTITE       NUMBER(5)                       not null
      constraint CKC_STOCK_QUANTITE_STOCK check (STOCK_QUANTITE between 0 and 500),
   constraint PK_STOCK primary key (STOCK_ID)
);

/*==============================================================*/
/* Index : STOCKER_FK                                           */
/*==============================================================*/
create index STOCKER_FK on STOCK (
   SOCIETE_ID ASC
);

/*==============================================================*/
/* Index : CONTENIR_DES_FK                                      */
/*==============================================================*/
create index CONTENIR_DES_FK on STOCK (
   PRODUIT_ID ASC
);

/*==============================================================*/
/* Table : TRANSACTION                                          */
/*==============================================================*/
create table TRANSACTION  (
   TRANSACTION_ID       NUMBER(5)                       not null,
   COMPTECB_ID          NUMBER(5),
   CLIENT_ID            NUMBER(5),
   TRANSACTION_OPERATION VARCHAR2(50)                    not null
      constraint CKC_TRANSACTION_OPERA_TRANSACT check (TRANSACTION_OPERATION in ('ACHAT','VENTE')),
   TRANSACTION_MONTANT  NUMBER(8,2)                     not null
      constraint CKC_TRANSACTION_MONTA_TRANSACT check (TRANSACTION_MONTANT >= 0),
   TRANSACTION_DATE     DATE                            not null,
   TRANSACTION_TYPE     VARCHAR2(50)                    not null,
   constraint PK_TRANSACTION primary key (TRANSACTION_ID)
);

/*==============================================================*/
/* Index : FACTURER_FK                                          */
/*==============================================================*/
create index FACTURER_FK on TRANSACTION (
   CLIENT_ID ASC
);

/*==============================================================*/
/* Index : METTRE_A_JOUR_FK                                     */
/*==============================================================*/
create index METTRE_A_JOUR_FK on TRANSACTION (
   COMPTECB_ID ASC
);

alter table COMMANDE
   add constraint FK_COMMANDE_APPLIQUER_TRANSACT foreign key (TRANSACTION_ID)
      references TRANSACTION (TRANSACTION_ID)
            ON DELETE CASCADE;


alter table COMMANDE
   add constraint FK_COMMANDE_CONTENIR_LIGNE_CO foreign key (LIGNECOMMANDE_ID)
      references LIGNE_COMMANDE (LIGNECOMMANDE_ID)
      on delete cascade;

alter table COMMANDE
   add constraint FK_COMMANDE_EFFECTUER_SOCIETE foreign key (SOCIETE_ID)
      references SOCIETE (SOCIETE_ID);

alter table COMMANDE
   add constraint FK_COMMANDE_ENVOYER_FOURNISS foreign key (FOURNISSEUR_ID)
      references FOURNISSEUR (FOURNISSEUR_ID)
            ON DELETE CASCADE;


alter table COMPTECB
   add constraint FK_COMPTECB_POSSEDER_SOCIETE foreign key (SOCIETE_ID)
      references SOCIETE (SOCIETE_ID);

alter table CONCERNER
   add constraint FK_CONCERNE_CONCERNER_TRANSACT foreign key (TRANSACTION_ID)
      references TRANSACTION (TRANSACTION_ID)
            ON DELETE CASCADE;


alter table CONCERNER
   add constraint FK_CONCERNE_CONCERNER_PRODUIT foreign key (PRODUIT_ID)
      references PRODUIT (PRODUIT_ID)
            ON DELETE CASCADE;


alter table EMPLOYE
   add constraint FK_EMPLOYE_EMPLOYER_SOCIETE foreign key (SOCIETE_ID)
      references SOCIETE (SOCIETE_ID);

alter table LIGNE_COMMANDE
   add constraint FK_LIGNE_CO_COMPOSER__PRODUIT foreign key (PRODUIT_ID)
      references PRODUIT (PRODUIT_ID)
      ON DELETE CASCADE;

alter table LIVRER
   add constraint FK_LIVRER_LIVRER_FOURNISS foreign key (FOURNISSEUR_ID)
      references FOURNISSEUR (FOURNISSEUR_ID)
            ON DELETE CASCADE;


alter table LIVRER
   add constraint FK_LIVRER_LIVRER2_PRODUIT foreign key (PRODUIT_ID)
      references PRODUIT (PRODUIT_ID)
            ON DELETE CASCADE;


alter table STOCK
   add constraint FK_STOCK_CONTENIR__PRODUIT foreign key (PRODUIT_ID)
      references PRODUIT (PRODUIT_ID)
            ON DELETE CASCADE;


alter table STOCK
   add constraint FK_STOCK_STOCKER_SOCIETE foreign key (SOCIETE_ID)
      references SOCIETE (SOCIETE_ID);

alter table TRANSACTION
   add constraint FK_TRANSACT_FACTURER_CLIENT foreign key (CLIENT_ID)
      references CLIENT (CLIENT_ID)
            ON DELETE CASCADE;


alter table TRANSACTION
   add constraint FK_TRANSACT_METTRE_A__COMPTECB foreign key (COMPTECB_ID)
      references COMPTECB (COMPTECB_ID)
            ON DELETE CASCADE;




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
insert into employe values(8,145,'Laurendeau','Yohann','Agent de sï¿½curitï¿½','Nice',2100.0,'7777',21,'H','27/09/2019',null);
insert into employe values(9,145,'Washington','Komuro','Agent de sï¿½curitï¿½','Carros',2150.0,'8888',23,'H','18/09/2019',null);
insert into employe values(10,145,'Boban','Bobi','Animateur','Grasse',2100.0,'9999',22,'H','12/08/2019',null);
insert into employe values(11,145,'Pelle','Sarah','Secrï¿½taire','Nice',2300.0,'1010',25,'F','14/08/2019',null);
insert into employe values(12,145,'Spears','Britney','Hotesse','Nice',2500.0,'11110',25,'F','17/08/2019',null);
insert into employe values(13,145,'Hanna','Ri','Hotesse','Nice',2700.0,'12120',28,'F','23/08/2019',null);
insert into employe values(14,145,'Jenner','Caitlyn','Hotesse','Carros',2600.0,'13130',32,'F','02/09/2019',null);
insert into employe values(15,145,'Bras','Gros','Agent de sï¿½curitï¿½','Nice',2100.0,'14140',26,'H','05/10/2019',null);
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

insert into produit values (1,'Bouteille de Absolut','Alcool-Vodka',15.5,5);
insert into produit values (2,'Bouteille de Poliakov','Alcool-Vodka',11.5,5);
insert into produit values (3,'Bouteille de GreyGoose','Alcool-Vodka',35.5,5);
insert into produit values (4,'Bouteille de Smirnoff','Alcool-Vodka',12.97,5);
insert into produit values (5,'Bouteille de Jï¿½germeister','Alcool',20.0,5);
insert into produit values (6,'Bouteille de Ballantines','Alcool-Whisky',57.0,5);
insert into produit values (7,'Bouteille de Jack Daniels','Alcool-Whisky',28.53,5);
insert into produit values (8,'Bouteille de Captain Morgan','Alcool-Rhum',12.98,5);
insert into produit values (9,'Bouteille de Havana Club','Alcool-Rhum',22.08,5);
insert into produit values (10,'Bouteille de Bacardi','Alcool-Rhum',15.30,5);
insert into produit values (11,'Bouteille de Leffe','Alcool-Biere Blonde',2.58,5);
insert into produit values (12,'Bouteille de Leffe','Alcool-Biere Ambree',1.50,5);
insert into produit values (13,'Bouteille de Guiness','Alcool-Biere Brune',3.43,5);
insert into produit values (14,'Bouteille de Martini','Alcool-Coktail',7.52,5);
insert into produit values (15,'Bouteille de Gin tonic','Alcool-Coktail',8.20,5);
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

/*==============================================================*/
/* TRIGGER                                                      */
/*==============================================================*/ 

--Modification du comptecb lors d'une vente ou d'un achat

 create or replace trigger tr_compteSolde
    after update or insert or delete on transaction for each row
 declare
 tr_montant number:=0;
 begin
	if inserting then	
		if :new.transaction_operation='VENTE' then
			tr_montant:=+:new.transaction_montant;
		else
			tr_montant:=-:new.transaction_montant;
		end if;
		update comptecb set comptecb_solde=comptecb_solde+ tr_montant 
		where comptecb_id=:new.comptecb_id ;
	else 
		raise_application_error(-20000, 'Update not allowed');
	end if;
   EXCEPTION 
	WHEN OTHERS THEN                      
	raise;
   end;

DROP TRIGGER clientcommande;

CREATE OR REPLACE TRIGGER clientcommande AFTER
    INSERT OR UPDATE ON transaction
    FOR EACH ROW
DECLARE
    idproduit   produit.produit_id%TYPE;
    util        NUMBER;
    stockqte    NUMBER;
BEGIN
    IF ( :new.client_id != NULL ) THEN
        SELECT
            produit_id
        INTO idproduit
        FROM
            ligne_commande
        WHERE
            lignecommande_id = (
                SELECT
                    commande_id
                FROM
                    commande
                WHERE
                    transaction_id = :new.transaction_id
            );

        SELECT
            produit_utilisation
        INTO util
        FROM
            produit
        WHERE
            produit_id = idproduit;

        package_produit.bmodifierf1(idproduit);
        IF ( util - 1 = 0 OR util < 0 ) THEN
            SELECT
                stock_quantite
            INTO stockqte
            FROM
                stock
            WHERE
                produit_id = idproduit;

            IF ( stockqte - 1 > 0 ) THEN
                UPDATE stock
                SET
                    stock_quantite = ( stockqte - 1 );

            ELSE
                IF ( stockqte - 1 <= 0 ) THEN
                    DELETE FROM stock
                    WHERE
                        produit_id = idproduit;

                END IF;
            END IF;

        END IF;

    END IF;
END;
/
/*==============================================================*/
/* MISE A JOUR TABLE                                            */
/*==============================================================*/
--Augmentation du salaire de l'employe au poste de DJ 
UPDATE employe
SET employe_salaire = employe_salaire * 1.10
WHERE employe_type = 'DJ';


--Augmentation de la quantite du stock numero 1600
UPDATE stock
SET stock_quantite = stock_quantite + 10
WHERE stock_id = 1600;

--Modification du nom du fournisseur sur la commande numero 101
Update fournisseur
Set fournisseur.fournisseur_nom ='Snacky'
Where fournisseur.fournisseur_id = (SELECT fournisseur_id from commande where commande.commande_id = 101);

--Modification du prix du produit se trouvant dans le stock 666
Update produit 
Set produit.produit_prix = 20.95
Where produit.produit_id = (SELECT produit_id from stock where stock.stock_id = 666);

--Augmentation du compte bancaire lors d'une transaction du client numero 5
Update comptecb
Set comptecb.comptecb_solde =  comptecb.comptecb_solde + 23.69
where comptecb.comptecb_id = (select comptecb_id from transaction 
where transaction.transaction_montant = 23.69 and transaction.client_id 
= (select client_id from client where client_id = 5));

--Augmentation de la quantite d'une ligne de commande dans la commande 101 effectuï¿½e par la societe 145
Update ligne_commande
Set ligne_commande.lignecommande_quantite = 6
where ligne_commande.lignecommande_id = (select lignecommande_id from commande
where commande.commande_id = 101 and commande.societe_id
=(select societe_id from societe where societe_id = 145));

/*==============================================================*/
/* DELETE TABLES                                                */
/*==============================================================*/

--Suppression de l'employe numero 2 
delete from employe
where employe_id = 2;

--Suppression de la commande numero 104
delete from commande
where commande_id = 104;

--Suppression du stock contenant le produit numero 5
delete from
(select * from stock
where produit_id in (select produit_id from produit where produit_id = 5));

--Suppression de la commande contenant la ligne de commande numero 6666
delete from 
(select * from commande
where lignecommande_id in (select lignecommande_id from ligne_commande where lignecommande_id = 6666));


--Suppression de la commande contenant la ligne de commande numero 8888 contenant le produit numero 8
delete from
(select * from commande
where lignecommande_id in (select lignecommande_id from ligne_commande 
where lignecommande_id = 8888 and produit_id in (select produit_id from produit where produit_id = 8)));

--Suppression de la commande associï¿½e a la transaction de la societï¿½ 145
delete from
(select * from commande
where commande_date='19/08/2019' and transaction_id in (select transaction_id from transaction
where societe_id in (select societe_id from societe where
societe_id = 145)));

/*==============================================================*/
/* CONSULTATION DES TABLES BASIQUE                              */
/*==============================================================*/ 

--Selection de l'employï¿½ avec le nom : Gangsta
select employe_id from employe
where employe_nom = 'Gangsta';

--Selection de toutes les bouteilles
select produit_id from produit
where produit_nom LIKE 'Bouteille%';

--Selection des commande entre le 01 Novembre et le 31 Dï¿½cembre 2019
select commande_id from commande
where commande_date between '01/11/2019' and '31/12/2019';

--Selection des produits ayant un id inf ï¿½ 10 et triï¿½es par leurs prix
select produit_id,produit_prix from produit
where produit_id <10
order by produit_prix;

--Selection tous les id des stocks supï¿½rieurs ï¿½ 1000 regroupï¿½ par id de stock et rangï¿½s par la quantitï¿½ du stock
select stock_id,MIN(stock_quantite) from stock
where stock_id > 1000
group by stock_id
order by MIN(stock_quantite);

/*==============================================================*/
/* CONSULTATION DES TABLES AVEC 2 TABLES                        */
/*==============================================================*/ 

--Selection de tous les stocks contenant un produit
select stock.stock_id as Stock_contenant_au_moins_un_produit from stock
inner join produit on stock.produit_id=produit.produit_id;

--Selection des produits qui sont dans une commande
select produit.produit_id from produit
inner join ligne_commande on ligne_commande.produit_id = produit.produit_id;

--Selection des produits qui sont dans une commande groupï¿½s par identifiants unique
select produit.produit_id from produit
inner join ligne_commande on ligne_commande.produit_id = produit.produit_id
group by ligne_commande.produit_id;

--Selection des produit ne figurant dans aucune commande (jointure externe)
select produit.produit_id from produit
left join ligne_commande on ligne_commande.produit_id = produit.produit_id
where ligne_commande.produit_id is null;

--Selection des produits ne figurant dans aucune commande triï¿½ par leur prix dï¿½croissants
select produit.produit_id,produit.produit_prix from produit
left join ligne_commande on ligne_commande.produit_id = produit.produit_id
where ligne_commande.produit_id is null
order by produit.produit_prix DESC;

/*==============================================================*/
/* CONSULTATION DES TABLES AVEC 3 TABLES                        */
/*==============================================================*/ 

--Selection d'un produit contenu dans un stock et inclu dans une commande
select stock.produit_id from stock
inner join produit on stock.produit_id = produit.produit_id
inner join ligne_commande on stock.produit_id = ligne_commande.produit_id;

--Selection d'une transaction mettant à jour le compte cp de la société 145
select transaction.transaction_id from transaction
inner join comptecb on transaction.comptecb_id = comptecb.comptecb_id
inner join societe on societe.societe_id = comptecb.societe_id
where societe.societe_id = 145;

--Selection de tous les produits contenus dans un stocks mais ne figurants dans aucune commande :
select produit.produit_id from produit
left join stock on stock.produit_id = produit.produit_id
left join ligne_commande on ligne_commande.produit_id = produit.produit_id
where ligne_commande.produit_id is null;

--Selection des employés de notre société qui comporte un compte bancaire et affiche le nombre d'identifiants dont ils disposent :
select employe.employe_nom,count(employe.employe_id) from employe
inner join societe on societe.societe_id = employe.societe_id
inner join comptecb on comptecb.societe_id = societe.societe_id
GROUP BY employe.employe_nom;

--Selection des clients ayant effectué une transaction qui a fini le compte 1 trié par ordere décroissant :
select client.client_id from client
inner join transaction on transaction.client_id = client.client_id
inner join comptecb on comptecb.comptecb_id = transaction.comptecb_id
where comptecb.comptecb_id = 1
order by client.client_id DESC;



/*==============================================================*/
/*                           PL SQL                             */
/*==============================================================*/ 


CREATE or replace PACKAGE BODY package_commande AS 

    -- ajouter une nouvelle occurence A : fonction Ainserer
    PROCEDURE Ainserer (idsociete in number, idproduit in number, quantite in number, idcompte in number) IS

        idProduitError EXCEPTION;
        idSocieteError EXCEPTION;
        quantiteError EXCEPTION;
        lastidCommande number;
        lastidligneCommande number;
        lastTransactionid number;
        getFournisseur number;
        getmontant transaction.transaction_montant%TYPE;
        searchingID number;
        dateCommande DATE;
        STR VARCHAR2(50); -- utile pour le regex plus tard selon la description du produit

        BEGIN
            select count(produit_id) into searchingID from PRODUIT where produit_id = idproduit; 
            if searchingID <= 0 then
                raise idProduitError;
            select count(societe_id) into searchingID from SOCIETE where societe_id = idproduit; 
            else if searchingID <= 0 then
                raise idSocieteError;
            else if quantite > 999 OR quantite < 0 then
                raise quantiteError;
           
         
            else
            
            --on prend le fournisseur associé au produit demandé
            select produit_desc into str from produit where produit_id = idproduit;
            Select fournisseur_id into getFournisseur  from fournisseur where fournisseur_type LIKE(REGEXP_SUBSTR (str,'(\S*)'))AND ROWNUM = 1;
            --on récupère l'id de la dennière commande et lignecommande
            select max(commande_id) into lastidCommande from COMMANDE;
            select max(lignecommande_id) into lastidligneCommande from ligne_commande;
            select max(transaction_id) into lastTransactionid from transaction;
            

            --on caclcule le montant à payer
            select produit_prix into getmontant from produit where produit_id = idproduit;
            getmontant:= getmontant * quantite;
            dateCommande := SYSDATE;



                INSERT INTO ligne_commande VALUES (lastidligneCommande + 1, idproduit, quantite);
                DBMS_OUTPUT.PUT_LINE('Le panier est créée'); 
                
                INSERT INTO transaction VALUES(lastTransactionid+1,idcompte,null, 'VENTE',getmontant,dateCommande,'Carte bancaire');

                INSERT INTO commande VALUES (lastidCommande + 1, getFournisseur, lastidligneCommande + 1, idsociete,lastTransactionid+1,dateCommande,dateCommande);
                DBMS_OUTPUT.PUT_LINE('Le commande est créée'); 
             end if;
            end if;
            end if;
            
            EXCEPTION
                when idProduitError then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': l id du produit n existe pas ' || idproduit); 
                when idSocieteError then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': l id de la societe n existe pas   ' || idsociete);     
                when quantiteError then
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': Quantite error exepted number >0 or < 999  but found ' || quantite);   
        END Ainserer;

    -- Supprimer une occurrence A : fonction Bsupprimer
    PROCEDURE Asupprimer(idCommande in number) is
        id_Command_not_found EXCEPTION;
        searchingID commande.commande_id%TYPE;
        
        
        BEGIN
        select count(commande_id) into searchingID from commande where commande_id = idCommande; 
            if searchingID <= 0 then
                raise id_Command_not_found;               
            else
                delete from commande where commande_id = idCommande;
                DBMS_OUTPUT.PUT_LINE('delete done');
            end if;
            
            EXCEPTION
                when id_Command_not_found then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': id not found in table: ' || idCommande); 
        END Asupprimer;
        
                
      PROCEDURE Alister--Fonction permettant de lister toutes les occurences de la table Commande
      is
      l_rc  SYS_REFCURSOR;
    BEGIN
    OPEN l_rc
       FOR SELECT
            c.*,
            l.lignecommande_quantite as quantite,
            p.produit_nom as nom_du_produit
        FROM
            commande         c,
            ligne_commande   l,
            produit          p
        WHERE
            c.lignecommande_id = l.lignecommande_id
            AND l.produit_id = p.produit_id
        ORDER BY
            commande_id;
        dbms_sql.return_result(l_rc);
    END Alister; 
    -- Changement de la date livraison d'une commande
    PROCEDURE AmodifierF1(idCommande in number, nbDay in number) is
        id_not_found EXCEPTION;  
        nbDayError EXCEPTION;
        searchingID commande.commande_id%TYPE;
        beforedate commande.commande_livraison%TYPE;
        
        BEGIN
            
            if searchingID <= 0 then
                raise id_not_found;
            else if nbDay < 0 OR nbDay > 20 then
                raise nbDayError;
            else
                select commande_livraison into beforedate from commande where commande_id = idCommande; 
                UPDATE commande SET commande_livraison = (beforedate + nbDay) WHERE commande_id = idCommande;
            end if;
            end if;
            
            EXCEPTION
                when id_not_found then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': id not found in table: ' || idCommande); 
                when nbDayError then
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || 'nbDay need to be > 0 and < 20 but foud : ' || nbDay); 
  
    END AmodifierF1;
    
    --Changer de fournisseur d'une commande
    PROCEDURE AmodifierF2(idCommande in number, idFournisseur in number) is
        idF_not_found EXCEPTION;
        idC_not_found EXCEPTION;    
        type_error EXCEPTION;
        searchinCommandeID commande.commande_id%TYPE;
        searchinFournisseurID fournisseur.fournisseur_id%TYPE;
        getFournisseur fournisseur.fournisseur_id%TYPE;
        getype fournisseur.fournisseur_type%TYPE;
        getype2 fournisseur.fournisseur_type%TYPE;

        
        BEGIN
            select count(commande_id) into searchinCommandeID from Commande where commande_id = idCommande; 
            select count(fournisseur_id) into searchinFournisseurID from Fournisseur where fournisseur_id = idFournisseur;
           
            
            if searchinCommandeID <= 0 then
                raise idC_not_found;
            else if
                searchinFournisseurID <= 0 then
                raise idF_not_found;
            else 
             --on récupère le type du fournisseur actuel de la commande
            select fournisseur_type into getype from fournisseur where fournisseur_id = (select fournisseur_id from commande where commande_id = idCommande);
            --on vérifie que le nouveau fournisseur possède le même type que l'ancien fournisseur 
            select fournisseur_type into getype2 from fournisseur where fournisseur_id = idfournisseur;

            if(getype != getype2)then
               raise type_error;
            else 
                 UPDATE commande SET fournisseur_id = idfournisseur WHERE commande_id = idCommande;
                  DBMS_OUTPUT.PUT_LINE(SQLERRM || ': On change l id du fournisseur par : ' || idFournisseur);
            end if;
            end if;
            end if;
            
            EXCEPTION
                when idF_not_found then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': id not found in table: ' || idFournisseur);
                when idC_not_found then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': id not found in table: ' || idCommande);
                 when type_error then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ':Type of founisseur not correspond the type need to be : ' || getype); 
  
    END AmodifierF2;
    

--Selection du numero de commande assignée au fournisseur PartyDrink
     PROCEDURE AF1 IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR SELECT
                        commande.commande_id,
                        commande.fournisseur_id
                    FROM
                        commande
                        INNER JOIN fournisseur ON fournisseur.fournisseur_id = commande.fournisseur_id
                    WHERE
                        fournisseur.fournisseur_nom = 'PartyDrink';

        dbms_sql.return_result(rc);
    END AF1;
    
--Section des fournisseurs assignés à une commande triés par id décroissant
      PROCEDURE  AF2 IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR SELECT
                        fournisseur.fournisseur_id
                    FROM
                        fournisseur
                        INNER JOIN commande ON commande.fournisseur_id = fournisseur.fournisseur_id
                    ORDER BY
                        fournisseur.fournisseur_id DESC;

        dbms_sql.return_result(rc);
    END AF2;
    
--Section des commandes avec le nombres de fournisseurs qui leurs sont associées
      PROCEDURE  AF3 IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR SELECT
                        commande.commande_id,COUNT(commande.fournisseur_id)
                    FROM
                        commande
                        INNER JOIN fournisseur ON commande.fournisseur_id = fournisseur.fournisseur_id
                    GROUP BY
                        commande.commande_id;
        dbms_sql.return_result(rc);
    END AF3;
  



        
END package_commande;
/

EXEC package_commande.Ainserer(145,1,1,1);
--EXEC package_commande.Asupprimer(78);

/*
SELECT  package_commande.Alister() FROM DUAL;
EXEC package_commande.AF1();
EXEC package_commande.AF2();
EXEC package_commande.AF3();
EXEC package_commande.Alister();
EXEC package_commande.AmodifierF1(113,2);-- augmente de 2 jours la date de livraison de la commande 113 
EXEC package_commande.AmodifierF2(113,5);-- Change le fournisseur de la commande (il faut que le nouveau fournisseur ait le même type)
*/



/* PARTIE B*/
/* LA TABLE 'B' CORRESPOND A LA TABLE PRODUIT*/

/*
- modifier des informations sur de B : fonction BmodifierF1, BmodifierF2 (texte
requï¿½tes correspondantes plus haut);
- lister toutes les occurrences de B pour une occurrence de A donnï¿½e: fonction Blister*/

CREATE or replace PACKAGE BODY package_produit AS 

    -- ajouter une nouvelle occurence ï¿½ B : fonction Binserer
    PROCEDURE Binserer (nom in varchar, des in varchar, prix in number, utilisation in number) IS
        utilisation_error EXCEPTION;
        price_lo_error EXCEPTION;
        price_go_error EXCEPTION;
        lastId produit.produit_id%TYPE;
    
        BEGIN
            if utilisation <= 0 then 
                raise utilisation_error;
            elsif prix <= 0 then
                raise price_lo_error;            
            elsif  prix >= 5000 then 
                raise price_go_error;
            else
                select max(produit_id) into lastId from PRODUIT;
                INSERT INTO produit VALUES (lastId + 1, nom, des, prix, utilisation);
                DBMS_OUTPUT.PUT_LINE('insert done'); 
            end if;
            
            EXCEPTION
                when utilisation_error then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': Utilisation error exepted number > 0 but found ' || utilisation);    
                when price_lo_error then
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': Prix error exepted number > 0 but found ' || prix);   
                when price_go_error then
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': Prix error exepted number < 5000 but found ' || prix);
    END Binserer;

    -- Supprimer une occurrence ï¿½ B : fonction Bsupprimer
    PROCEDURE Bsupprimer(identifiant in number) is
        id_not_found EXCEPTION;
        searchingID produit.produit_id%TYPE;
        
        BEGIN
            select count(produit_id) into searchingID from PRODUIT where produit_id = identifiant; 
            if searchingID <= 0 then
                raise id_not_found;
            else
                delete from produit where produit_id = identifiant;
                DBMS_OUTPUT.PUT_LINE('delete done');
            end if;
            
            EXCEPTION
                when id_not_found then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': id not found in table: ' || identifiant); 
    END Bsupprimer;
    
    -- Lister toutes les occurrences de B pour une occurrence de A donnée: fonction Blister
    PROCEDURE Blister(idFournisseur in number) is
        id_not_found EXCEPTION;        
        searchingID livrer.FOURNISSEUR_ID%TYPE;
        rc sys_refcursor;
         
        BEGIN
            select count(FOURNISSEUR_ID) into searchingID from LIVRER where FOURNISSEUR_ID = idFournisseur; 
            if searchingID <= 0 then
                raise id_not_found;
            else
                open rc for select * from produit where produit_id in (select produit_id from LIVRER where fournisseur_id = idFournisseur);
                dbms_sql.return_result(rc);
            end if;
            
            EXCEPTION
                when id_not_found then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': id not found in table: ' || idFournisseur); 
    END Blister;
        
    -- Décrémente produit_utilisation
    PROCEDURE BmodifierF1(idProduit in number) is
        id_not_found EXCEPTION;        
        searchingID produit.produit_id%TYPE;
        currentUsage produit.produit_utilisation%TYPE;
        
        BEGIN
            
            if searchingID <= 0 then
                raise id_not_found;
            else
                select produit_utilisation into currentUsage from PRODUIT where produit_id = idProduit; 
                UPDATE produit SET produit_utilisation = (currentUsage - 1) WHERE produit_id = idProduit;
            end if;
            
            EXCEPTION
                when id_not_found then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': id not found in table: ' || idProduit); 
  
    END BmodifierF1;
    
    --Update le prix du produit
    PROCEDURE BmodifierF2(idProduit in number, newPrice in number) is
        id_not_found EXCEPTION;        
        searchingID produit.produit_id%TYPE;
        
        BEGIN
            
            if searchingID <= 0 then
                raise id_not_found;
            else
                UPDATE produit SET produit_prix = newPrice WHERE produit_id = idProduit;
            end if;
            
            EXCEPTION
                when id_not_found then 
                    DBMS_OUTPUT.PUT_LINE(SQLERRM || ': id not found in table: ' || idProduit); 
  
    END BmodifierF2;
        
   
END package_produit;
/

--EXEC package_produit.Binserer('bierre', 'brevage', 10, 10);
--EXEC package_produit.Bsupprimer(5);
--EXEC package_produit.Blister(1);
--EXEC package_produit.BmodifierF1(1);
--EXEC package_produit.BmodifierF2(1, 500);
--EXEC package_commande.Ainserer(145,1,1,1);



