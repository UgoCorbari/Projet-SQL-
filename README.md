🔖 Projet SQL
Alta Vista Drones — Système de gestion des commandes clients

📍 Contexte et objectif

Alta Vista Drones est une entreprise spécialisée dans la valorisation audiovisuelle de biens immobiliers à l’aide de drones. Elle propose des prestations telles que :
  Prises de vue aériennes (photo/vidéo)
  Vidéos montées avec habillage graphique
  Présentations orales des agents
  Services de montage express
L’objectif de ce projet est de concevoir une base de données relationnelle permettant de suivre toute l'activité commerciale, du premier contact client jusqu’au paiement de la facture, en incluant la gestion des commandes, prestations, historiques et paiements.

🎯 Portée fonctionnelle

La base de données permet de :
- Enregistrer les clients (nom, coordonnées)
- Gérer un catalogue de prestations (services proposés)
- Enregistrer et suivre les commandes clients, incluant plusieurs prestations par commande
- Générer les factures automatiquement avec calcul des montants HT, TVA et TTC
- Suivre les paiements effectués ou en attente
- Conserver un historique des changements de statut des commandes (utile pour la traçabilité et le SAV)
  
Cette base est conçue de manière modulaire pour accueillir de futures extensions :
  📅 planification de rendez-vous,
  📊 indicateurs de rentabilité.


🧩 Modèle conceptuel — Entités et relations

Entité	Description :

Clients	:Donneurs d’ordre (particuliers ou professionnels), identifiés par un client_id
Prestations :	Services proposés, tarifés à l’unité (prix_unitaire), avec durée estimée
Commandes	: Groupes de prestations commandées par un client, avec un statut et un secteur
Commandes_Prestations	: Table de liaison entre commandes et prestations, avec quantité et remise
Factures	: Générées pour chaque commande, contenant les montants HT, TVA, TTC et le statut_paiement
Paiements	: Associés à une facture, incluant le montant, la date et le mode de règlement
Historique_Commandes :	Journalisation des changements de statut d’une commande (avant/après + horodatage)

🗺️ Diagramme Entité-Relation (ERD)



⚙️ Choix de conception

 - Modèle normalisé : chaque table correspond à une entité métier ou relation logique
 - Intégrité référentielle : assurée via FOREIGN KEY
 - Contraintes CHECK sur les statuts (commandes, factures) pour fiabilité
 - Historique séparé : journalisation indépendante pour audit ou SAV
 - Remises intégrées : dans la table Commandes_Prestations pour flexibilité commerciale

🚀 Optimisations futures: 

Création d’index sur les colonnes utilisées pour les jointures (client_id, commande_id, etc.)
Création de vues SQL pour simplifier les requêtes analytiques (ex : chiffre d’affaires par mois ou par client)
Mise en place de triggers pour recalcul automatique des totaux des factures
Ajout d’un module de notifications (emails automatisés pour factures en retard)
Préparation à une intégration avec une interface front-end (ex : dashboard web)

⛔ Limitations actuelles
Calculs total_ht et total_ttc générés par script, mais pas mis à jour dynamiquement
Aucun suivi de la ressource interne (technicien, pilote de drone…)
Aucun formulaire d’entrée utilisateur (nécessite des scripts manuels pour alimenter la base)
Pas de reporting automatisé ni de gestion de KPI (encore à implémenter)
