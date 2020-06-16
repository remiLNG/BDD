/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 10g                            */
/* Date de cr�ation :  08/05/2020 16:53:26                      */
/*==============================================================*/

SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';
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
   drop constraint FK_COMMANDE_ENVOYER_FOURNISS;

alter table COMMANDE
   drop constraint FK_COMMANDE_PASSER_SOCIETE;

alter table COMPTECB
   drop constraint FK_COMPTECB_POSSEDER_SOCIETE;

alter table CONCERNER
   drop constraint FK_CONCERNE_CONCERNER_TRANSACT;

alter table CONCERNER
   drop constraint FK_CONCERNE_CONCERNER_PRODUIT;

alter table EMPLOYE
   drop constraint FK_EMPLOYE_EMPLOYER_SOCIETE;

alter table LIGNE_COMMANDE
   drop constraint FK_LIGNE_CO_COMPOSER_PRODUIT;

alter table LIVRER
   drop constraint FK_LIVRER_LIVRER_FOURNISS;

alter table LIVRER
   drop constraint FK_LIVRER_LIVRER2_PRODUIT;

alter table STOCK
   drop constraint FK_STOCK_GERER_SOCIETE;

alter table STOCK
   drop constraint FK_STOCK_STOCKER_PRODUIT;

alter table TRANSACTION
   drop constraint FK_TRANSACT_EFFECTUER_CLIENT;

alter table TRANSACTION
   drop constraint FK_TRANSACT_METTRE_A__COMPTECB;

drop table CLIENT cascade constraints;

drop index CONTENIR_FK;

drop index APPLIQUER_FK;

drop index ENVOYER_FK;

drop index PASSER_FK;

drop table COMMANDE cascade constraints;

drop index POSSEDER_FK;

drop table COMPTECB cascade constraints;

drop index CONCERNER2_FK;

drop index CONCERNER_FK;

drop table CONCERNER cascade constraints;

drop index EMPLOYER_FK;

drop table EMPLOYE cascade constraints;

drop table FOURNISSEUR cascade constraints;

drop index COMPOSER_FK;

drop table LIGNE_COMMANDE cascade constraints;

drop index LIVRER2_FK;

drop index LIVRER_FK;

drop table LIVRER cascade constraints;

drop table PRODUIT cascade constraints;

drop table SOCIETE cascade constraints;

drop index STOCKER_FK;

drop index GERER_FK;

drop table STOCK cascade constraints;

drop index METTRE_A_JOUR_FK;

drop index EFFECTUER_FK;

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
/* Index : PASSER_FK                                            */
/*==============================================================*/
create index PASSER_FK on COMMANDE (
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
/* Index : COMPOSER_FK                                          */
/*==============================================================*/
create index COMPOSER_FK on LIGNE_COMMANDE (
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
/* Index : GERER_FK                                             */
/*==============================================================*/
create index GERER_FK on STOCK (
   SOCIETE_ID ASC
);

/*==============================================================*/
/* Index : STOCKER_FK                                           */
/*==============================================================*/
create index STOCKER_FK on STOCK (
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
/* Index : EFFECTUER_FK                                         */
/*==============================================================*/
create index EFFECTUER_FK on TRANSACTION (
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
   add constraint FK_COMMANDE_ENVOYER_FOURNISS foreign key (FOURNISSEUR_ID)
      references FOURNISSEUR (FOURNISSEUR_ID)
       ON DELETE CASCADE;

alter table COMMANDE
   add constraint FK_COMMANDE_PASSER_SOCIETE foreign key (SOCIETE_ID)
      references SOCIETE (SOCIETE_ID);

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
   add constraint FK_LIGNE_CO_COMPOSER_PRODUIT foreign key (PRODUIT_ID)
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
   add constraint FK_STOCK_GERER_SOCIETE foreign key (SOCIETE_ID)
      references SOCIETE (SOCIETE_ID)
      ON DELETE CASCADE;

alter table STOCK
   add constraint FK_STOCK_STOCKER_PRODUIT foreign key (PRODUIT_ID)
      references PRODUIT (PRODUIT_ID);

alter table TRANSACTION
   add constraint FK_TRANSACT_EFFECTUER_CLIENT foreign key (CLIENT_ID)
      references CLIENT (CLIENT_ID)
      ON DELETE CASCADE;

alter table TRANSACTION
   add constraint FK_TRANSACT_METTRE_A__COMPTECB foreign key (COMPTECB_ID)
      references COMPTECB (COMPTECB_ID)
       ON DELETE CASCADE;