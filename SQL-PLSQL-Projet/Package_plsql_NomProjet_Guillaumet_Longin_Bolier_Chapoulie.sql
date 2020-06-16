/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 10g                            */
/* Date de crï¿½ation :  08/05/2020 16:53:26                      */
/*==============================================================*/
SET SERVEROUTPUT ON;

ALTER SESSION SET nls_date_format = 'DD-MM-YYYY';

DROP PACKAGE package_commande;

DROP PACKAGE package_produit;

CREATE OR REPLACE PACKAGE package_commande AS
    PROCEDURE ainserer (
        idsociete   IN   NUMBER,
        idproduit   IN   NUMBER,
        quantite    IN   NUMBER,
        idcompte    IN   NUMBER
    );

    PROCEDURE amodifierf1 (
        idcommande   IN   NUMBER,
        nbday        IN   NUMBER
    );

    PROCEDURE alister;

    PROCEDURE af1;

    PROCEDURE af2;

    PROCEDURE af3;

    PROCEDURE amodifierf2 (
        idcommande      IN   NUMBER,
        idfournisseur   IN   NUMBER
    );

    PROCEDURE asupprimer (
        idcommande IN NUMBER
    );

END package_commande;
/

CREATE OR REPLACE PACKAGE package_produit AS
    PROCEDURE binserer (
        nom           IN   VARCHAR,
        des           IN   VARCHAR,
        prix          IN   NUMBER,
        utilisation   IN   NUMBER
    );

    PROCEDURE bsupprimer (
        identifiant IN NUMBER
    );

    PROCEDURE blister (
        idfournisseur IN NUMBER
    );

    PROCEDURE bmodifierf1 (
        idproduit IN NUMBER
    );

    PROCEDURE bmodifierf2 (
        idproduit   IN   NUMBER,
        newprice    IN   NUMBER
    );

END package_produit;
/
/*==============================================================*/
/*                           PL SQL                             */
/*==============================================================*/

CREATE OR REPLACE PACKAGE BODY package_commande AS 

    -- ajouter une nouvelle occurence A : fonction Ainserer

    PROCEDURE ainserer (
        idsociete   IN   NUMBER,
        idproduit   IN   NUMBER,
        quantite    IN   NUMBER,
        idcompte    IN   NUMBER
    ) IS

        idproduiterror EXCEPTION;
        idsocieteerror EXCEPTION;
        quantiteerror EXCEPTION;
        lastidcommande        NUMBER;
        lastidlignecommande   NUMBER;
        lasttransactionid     NUMBER;
        getfournisseur        NUMBER;
        getmontant            transaction.transaction_montant%TYPE;
        searchingid           NUMBER;
        datecommande          DATE;
        str                   VARCHAR2(50); -- utile pour le regex plus tard selon la description du produit
    BEGIN
        SELECT
            COUNT(produit_id)
        INTO searchingid
        FROM
            produit
        WHERE
            produit_id = idproduit;

        IF searchingid <= 0 THEN
            RAISE idproduiterror;
            SELECT
                COUNT(societe_id)
            INTO searchingid
            FROM
                societe
            WHERE
                societe_id = idproduit;

        ELSE
            IF searchingid <= 0 THEN
                RAISE idsocieteerror;
            ELSE
                IF quantite > 999 OR quantite < 0 THEN
                    RAISE quantiteerror;
                ELSE
            
            --on prend le fournisseur associé au produit demandé
                    SELECT
                        produit_desc
                    INTO str
                    FROM
                        produit
                    WHERE
                        produit_id = idproduit;

                    SELECT
                        fournisseur_id
                    INTO getfournisseur
                    FROM
                        fournisseur
                    WHERE
                        fournisseur_type LIKE ( regexp_substr(str, '(\S*)') )
                        AND ROWNUM = 1;
            --on récupère l'id de la dennière commande et lignecommande

                    SELECT
                        MAX(commande_id)
                    INTO lastidcommande
                    FROM
                        commande;

                    SELECT
                        MAX(lignecommande_id)
                    INTO lastidlignecommande
                    FROM
                        ligne_commande;

                    SELECT
                        MAX(transaction_id)
                    INTO lasttransactionid
                    FROM
                        transaction;
            

            --on caclcule le montant à payer

                    SELECT
                        produit_prix
                    INTO getmontant
                    FROM
                        produit
                    WHERE
                        produit_id = idproduit;

                    getmontant := getmontant * quantite;
                    datecommande := sysdate;
                    INSERT INTO ligne_commande VALUES (
                        lastidlignecommande + 1,
                        idproduit,
                        quantite
                    );

                    dbms_output.put_line('Le panier est créée');
                    INSERT INTO transaction VALUES (
                        lasttransactionid + 1,
                        idcompte,
                        NULL,
                        'ACHAT',
                        getmontant,
                        datecommande,
                        'Carte bancaire'
                    );

                    INSERT INTO commande VALUES (
                        lastidcommande + 1,
                        getfournisseur,
                        lastidlignecommande + 1,
                        idsociete,
                        lasttransactionid + 1,
                        datecommande,
                        datecommande
                    );

                    dbms_output.put_line('Le commande est créée');
                END IF;
            END IF;
        END IF;

    EXCEPTION
        WHEN idproduiterror THEN
            dbms_output.put_line(sqlerrm
                                 || ': l id du produit n existe pas '
                                 || idproduit);
        WHEN idsocieteerror THEN
            dbms_output.put_line(sqlerrm
                                 || ': l id de la societe n existe pas   '
                                 || idsociete);
        WHEN quantiteerror THEN
            dbms_output.put_line(sqlerrm
                                 || ': Quantite error exepted number >0 or < 999  but found '
                                 || quantite);
    END ainserer;

    -- Supprimer une occurrence A : fonction Bsupprimer

    PROCEDURE asupprimer (
        idcommande IN NUMBER
    ) IS
        id_command_not_found EXCEPTION;
        searchingid commande.commande_id%TYPE;
    BEGIN
        SELECT
            COUNT(commande_id)
        INTO searchingid
        FROM
            commande
        WHERE
            commande_id = idcommande;

        IF searchingid <= 0 THEN
            RAISE id_command_not_found;
        ELSE
            DELETE FROM commande
            WHERE
                commande_id = idcommande;

            dbms_output.put_line('delete done');
        END IF;

    EXCEPTION
        WHEN id_command_not_found THEN
            dbms_output.put_line(sqlerrm
                                 || ': id not found in table: '
                                 || idcommande);
    END asupprimer;

    PROCEDURE alister--Fonction permettant de lister toutes les occurences de la table Commande

     IS
        l_rc SYS_REFCURSOR;
    BEGIN
        OPEN l_rc FOR SELECT
                          c.*,
                          l.lignecommande_quantite   AS quantite,
                          p.produit_nom              AS nom_du_produit
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
    END alister; 
    -- Changement de la date livraison d'une commande

    PROCEDURE amodifierf1 (
        idcommande   IN   NUMBER,
        nbday        IN   NUMBER
    ) IS
        id_not_found EXCEPTION;
        nbdayerror EXCEPTION;
        searchingid   commande.commande_id%TYPE;
        beforedate    commande.commande_livraison%TYPE;
    BEGIN
        IF searchingid <= 0 THEN
            RAISE id_not_found;
        ELSE
            IF nbday < 0 OR nbday > 20 THEN
                RAISE nbdayerror;
            ELSE
                SELECT
                    commande_livraison
                INTO beforedate
                FROM
                    commande
                WHERE
                    commande_id = idcommande;

                UPDATE commande
                SET
                    commande_livraison = ( beforedate + nbday )
                WHERE
                    commande_id = idcommande;

            END IF;
        END IF;
    EXCEPTION
        WHEN id_not_found THEN
            dbms_output.put_line(sqlerrm
                                 || ': id not found in table: '
                                 || idcommande);
        WHEN nbdayerror THEN
            dbms_output.put_line(sqlerrm
                                 || 'nbDay need to be > 0 and < 20 but foud : '
                                 || nbday);
    END amodifierf1;
    
    --Changer de fournisseur d'une commande

    PROCEDURE amodifierf2 (
        idcommande      IN   NUMBER,
        idfournisseur   IN   NUMBER
    ) IS

        idf_not_found EXCEPTION;
        idc_not_found EXCEPTION;
        type_error EXCEPTION;
        searchincommandeid      commande.commande_id%TYPE;
        searchinfournisseurid   fournisseur.fournisseur_id%TYPE;
        getfournisseur          fournisseur.fournisseur_id%TYPE;
        getype                  fournisseur.fournisseur_type%TYPE;
        getype2                 fournisseur.fournisseur_type%TYPE;
    BEGIN
        SELECT
            COUNT(commande_id)
        INTO searchincommandeid
        FROM
            commande
        WHERE
            commande_id = idcommande;

        SELECT
            COUNT(fournisseur_id)
        INTO searchinfournisseurid
        FROM
            fournisseur
        WHERE
            fournisseur_id = idfournisseur;

        IF searchincommandeid <= 0 THEN
            RAISE idc_not_found;
        ELSE
            IF searchinfournisseurid <= 0 THEN
                RAISE idf_not_found;
            ELSE 
             --on récupère le type du fournisseur actuel de la commande
                SELECT
                    fournisseur_type
                INTO getype
                FROM
                    fournisseur
                WHERE
                    fournisseur_id = (
                        SELECT
                            fournisseur_id
                        FROM
                            commande
                        WHERE
                            commande_id = idcommande
                    );
            --on vérifie que le nouveau fournisseur possède le même type que l'ancien fournisseur 

                SELECT
                    fournisseur_type
                INTO getype2
                FROM
                    fournisseur
                WHERE
                    fournisseur_id = idfournisseur;

                IF ( getype != getype2 ) THEN
                    RAISE type_error;
                ELSE
                    UPDATE commande
                    SET
                        fournisseur_id = idfournisseur
                    WHERE
                        commande_id = idcommande;

                    dbms_output.put_line(sqlerrm
                                         || ': On change l id du fournisseur par : '
                                         || idfournisseur);
                END IF;

            END IF;
        END IF;

    EXCEPTION
        WHEN idf_not_found THEN
            dbms_output.put_line(sqlerrm
                                 || ': id not found in table: '
                                 || idfournisseur);
        WHEN idc_not_found THEN
            dbms_output.put_line(sqlerrm
                                 || ': id not found in table: '
                                 || idcommande);
        WHEN type_error THEN
            dbms_output.put_line(sqlerrm
                                 || ':Type of founisseur not correspond the type need to be : '
                                 || getype);
    END amodifierf2;
    

--Selection du numero de commande assignée au fournisseur PartyDrink

    PROCEDURE af1 IS
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
    END af1;
    
--Section des fournisseurs assignés à une commande triés par id décroissant

    PROCEDURE af2 IS
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
    END af2;
    
--Section des commandes avec le nombres de fournisseurs qui leurs sont associées

    PROCEDURE af3 IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR SELECT
                        commande.commande_id,
                        COUNT(commande.fournisseur_id)
                    FROM
                        commande
                        INNER JOIN fournisseur ON commande.fournisseur_id = fournisseur.fournisseur_id
                    GROUP BY
                        commande.commande_id;

        dbms_sql.return_result(rc);
    END af3;

END package_commande;
/



--EXEC package_commande.Ainserer(145,1,1,1);
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

CREATE OR REPLACE PACKAGE BODY package_produit AS 

    -- ajouter une nouvelle occurence ï¿½ B : fonction Binserer

    PROCEDURE binserer (
        nom           IN   VARCHAR,
        des           IN   VARCHAR,
        prix          IN   NUMBER,
        utilisation   IN   NUMBER
    ) IS
        utilisation_error EXCEPTION;
        price_lo_error EXCEPTION;
        price_go_error EXCEPTION;
        lastid produit.produit_id%TYPE;
    BEGIN
        IF utilisation <= 0 THEN
            RAISE utilisation_error;
        ELSIF prix <= 0 THEN
            RAISE price_lo_error;
        ELSIF prix >= 5000 THEN
            RAISE price_go_error;
        ELSE
            SELECT
                MAX(produit_id)
            INTO lastid
            FROM
                produit;

            INSERT INTO produit VALUES (
                lastid + 1,
                nom,
                des,
                prix,
                utilisation
            );

            dbms_output.put_line('insert done');
        END IF;
    EXCEPTION
        WHEN utilisation_error THEN
            dbms_output.put_line(sqlerrm
                                 || ': Utilisation error exepted number > 0 but found '
                                 || utilisation);
        WHEN price_lo_error THEN
            dbms_output.put_line(sqlerrm
                                 || ': Prix error exepted number > 0 but found '
                                 || prix);
        WHEN price_go_error THEN
            dbms_output.put_line(sqlerrm
                                 || ': Prix error exepted number < 5000 but found '
                                 || prix);
    END binserer;

    -- Supprimer une occurrence ï¿½ B : fonction Bsupprimer

    PROCEDURE bsupprimer (
        identifiant IN NUMBER
    ) IS
        id_not_found EXCEPTION;
        searchingid produit.produit_id%TYPE;
    BEGIN
        SELECT
            COUNT(produit_id)
        INTO searchingid
        FROM
            produit
        WHERE
            produit_id = identifiant;

        IF searchingid <= 0 THEN
            RAISE id_not_found;
        ELSE
            DELETE FROM produit
            WHERE
                produit_id = identifiant;

            dbms_output.put_line('delete done');
        END IF;

    EXCEPTION
        WHEN id_not_found THEN
            dbms_output.put_line(sqlerrm
                                 || ': id not found in table: '
                                 || identifiant);
    END bsupprimer;
    
    -- Lister toutes les occurrences de B pour une occurrence de A donnée: fonction Blister

    PROCEDURE blister (
        idfournisseur IN NUMBER
    ) IS
        id_not_found EXCEPTION;
        searchingid   livrer.fournisseur_id%TYPE;
        rc            SYS_REFCURSOR;
    BEGIN
        SELECT
            COUNT(fournisseur_id)
        INTO searchingid
        FROM
            livrer
        WHERE
            fournisseur_id = idfournisseur;

        IF searchingid <= 0 THEN
            RAISE id_not_found;
        ELSE
            OPEN rc FOR SELECT
                            *
                        FROM
                            produit
                        WHERE
                            produit_id IN (
                                SELECT
                                    produit_id
                                FROM
                                    livrer
                                WHERE
                                    fournisseur_id = idfournisseur
                            );

            dbms_sql.return_result(rc);
        END IF;

    EXCEPTION
        WHEN id_not_found THEN
            dbms_output.put_line(sqlerrm
                                 || ': id not found in table: '
                                 || idfournisseur);
    END blister;
        
    -- Décrémente produit_utilisation

    PROCEDURE bmodifierf1 (
        idproduit IN NUMBER
    ) IS
        id_not_found EXCEPTION;
        searchingid    produit.produit_id%TYPE;
        currentusage   produit.produit_utilisation%TYPE;
    BEGIN
        IF searchingid <= 0 THEN
            RAISE id_not_found;
        ELSE
            SELECT
                produit_utilisation
            INTO currentusage
            FROM
                produit
            WHERE
                produit_id = idproduit;

            UPDATE produit
            SET
                produit_utilisation = ( currentusage - 1 )
            WHERE
                produit_id = idproduit;

        END IF;
    EXCEPTION
        WHEN id_not_found THEN
            dbms_output.put_line(sqlerrm
                                 || ': id not found in table: '
                                 || idproduit);
    END bmodifierf1;
    
    --Update le prix du produit

    PROCEDURE bmodifierf2 (
        idproduit   IN   NUMBER,
        newprice    IN   NUMBER
    ) IS
        id_not_found EXCEPTION;
        searchingid produit.produit_id%TYPE;
    BEGIN
        IF searchingid <= 0 THEN
            RAISE id_not_found;
        ELSE
            UPDATE produit
            SET
                produit_prix = newprice
            WHERE
                produit_id = idproduit;

        END IF;
    EXCEPTION
        WHEN id_not_found THEN
            dbms_output.put_line(sqlerrm
                                 || ': id not found in table: '
                                 || idproduit);
    END bmodifierf2;

END package_produit;
/

--EXEC package_produit.Binserer('bierre', 'brevage', 10, 10);
--EXEC package_produit.Bsupprimer(5);
--EXEC package_produit.Blister(1);
--EXEC package_produit.BmodifierF1(1);
--EXEC package_produit.BmodifierF2(1, 500);
--EXEC package_commande.Ainserer(145,1,1,1);


/*==============================================================*/
/* TRIGGER                                                      */
/*==============================================================*/ 

--Modification du comptecb lors d'une vente ou d'un achat

CREATE OR REPLACE TRIGGER tr_comptesolde AFTER
    UPDATE OR INSERT OR DELETE ON transaction
    FOR EACH ROW
DECLARE
    tr_montant NUMBER := 0;
BEGIN
    IF inserting THEN
        IF :new.transaction_operation = 'VENTE' THEN
            tr_montant := + :new.transaction_montant;
        ELSE
            tr_montant := -:new.transaction_montant;
        END IF;

        UPDATE comptecb
        SET
            comptecb_solde = comptecb_solde + tr_montant
        WHERE
            comptecb_id = :new.comptecb_id;

    ELSE
        raise_application_error(-20000, 'Update not allowed');
    END IF;
END;
/

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