 -- Passer en mode CSV et afficher les entêtes
.mode csv
.headers on

-- Importation des données depuis des fichiers CSV (adapté pour SQLite)

.import Codes/clients.csv Clients
.import Codes/Prestations.csv Prestations
.import Codes/commandes.csv Commandes
.import Codes/commandes_prestations.csv Commandes_Prestations

-- Générer les factures à partir des données existantes
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

-- Historique des commandes (ajuste selon la structure de ta table)
INSERT INTO Historique_Commandes (commande_id, ancien_statut, nouveau_statut)
SELECT 1, 'en attente', 'en cours'
UNION
SELECT 2, 'en cours', 'terminée';

-- Insertion des paiements (uniquement pour les factures payées)
INSERT INTO Paiements (facture_id, date_paiement, montant, moyen_paiement)
SELECT 
    f.facture_id,
    DATE(f.date_facture, '+10 days') AS date_paiement,
    f.total_ttc,
    'virement'
FROM Factures f
WHERE f.statut_paiement = 'payée';

