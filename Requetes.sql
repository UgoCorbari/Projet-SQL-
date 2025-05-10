-- 1) Insertion des données 

-- Insérer les données dans Clients à partir du CSV
COPY Clients (client_id, nom, email, téléphone, adresse)
FROM '/Users/ugocorbari/Desktop/clients.csv' DELIMITER ',' CSV HEADER;

-- Insérer les données dans Prestations à partir du CSV
COPY Prestations (prestation_id, nom, description, prix_unitaire, durée_estimee)
FROM '/Users/ugocorbari/Desktop/Prestations.csv' DELIMITER ',' CSV HEADER;

-- Insérer les données dans Commandes à partir du CSV
COPY Commandes (commande_id, client_id, date_commande, statut, secteur)
FROM '/Users/ugocorbari/Desktop/commandes.csv' DELIMITER ',' CSV HEADER;

-- Insérer les données dans Commandes_Prestations à partir du CSV
COPY Commandes_Prestations (commande_id, prestation_id, quantité, remise_pourcent)
FROM '/Users/ugocorbari/Desktop/commandes_prestations.csv' DELIMITER ',' CSV HEADER;

-- Insérer les données pour la table facture à partir des données des autres bases 
INSERT INTO Factures (commande_id, date_facture, total_ht, tva, total_ttc, statut_paiement) 
SELECT 
    c.commande_id,
    c.date_commande AS date_facture,
    SUM(p.prix_unitaire * cp.quantité * (1 - cp.remise_pourcent / 100.0)) AS total_ht,
    20.0 AS tva, 
    SUM(p.prix_unitaire * cp.quantité * (1 - cp.remise_pourcent / 100.0)) * 1.20 AS total_ttc, 
    'en attente' AS statut_paiement
FROM Commandes c
JOIN Commandes_Prestations cp ON c.commande_id = cp.commande_id
JOIN Prestations p ON cp.prestation_id = p.prestation_id
GROUP BY c.commande_id;

-- Insertion dans l'historique des commandes
INSERT INTO Historique_Commandes (commande_id, date_commande, ancien_statut, nouveau_statut) VALUES
(1, (SELECT date_commande FROM Commandes WHERE commande_id = 1), 'en attente', 'en cours'),
(2, (SELECT date_commande FROM Commandes WHERE commande_id = 2), 'en cours', 'terminée');

-- Insertion des paiements
INSERT INTO Paiements (facture_id, date_paiement, montant, moyen_paiement)
SELECT 
    f.facture_id,
    DATE(f.date_facture, '+10 days') AS date_paiement, -- Ajouter 10 jours à la date de la facture
    f.total_ttc,
    'virement'
FROM Factures f
WHERE f.statut_paiement = 'payée';
