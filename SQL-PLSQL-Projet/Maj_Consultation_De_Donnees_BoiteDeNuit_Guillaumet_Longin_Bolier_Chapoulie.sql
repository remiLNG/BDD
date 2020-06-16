/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 10g                            */
/* Date de crï¿½ation :  08/05/2020 16:53:26                      */
/*==============================================================*/

SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';
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
