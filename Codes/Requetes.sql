-- ####################################################
-- # Exemples de Requêtes sur la base de donnée       #
-- ####################################################

--  Liste de tous les clients avec leur nombre de commandes
SELECT 
    c.client_id,
    c.nom,
    COUNT(cmd.commande_id) AS nombre_commandes
FROM Clients c
LEFT JOIN Commandes cmd ON c.client_id = cmd.client_id
GROUP BY c.client_id;

-- Détail des prestations commandées par client
SELECT 
    cl.nom AS client,
    p.nom AS prestation,
    cp.quantité,
    p.prix_unitaire,
    cp.remise_pourcent,
    (p.prix_unitaire * cp.quantité * (1 - cp.remise_pourcent / 100.0)) AS total_net
FROM Clients cl
JOIN Commandes c ON cl.client_id = c.client_id
JOIN Commandes_Prestations cp ON c.commande_id = cp.commande_id
JOIN Prestations p ON cp.prestation_id = p.prestation_id
ORDER BY cl.nom;


-- Historique des changements de statut des commandes
SELECT 
    hc.commande_id,
    hc.ancien_statut,
    hc.nouveau_statut,
    hc.date_changement,
    hc.modifié_par
FROM Historique_Commandes hc
ORDER BY hc.date_changement DESC;

--  Prestation la plus vendue (en quantité)
SELECT 
    p.nom,
    SUM(cp.quantité) AS quantite_totale
FROM Commandes_Prestations cp
JOIN Prestations p ON cp.prestation_id = p.prestation_id
GROUP BY p.prestation_id
ORDER BY quantite_totale DESC
LIMIT 1;


