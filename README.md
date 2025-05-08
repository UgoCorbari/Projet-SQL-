# Projet-SQL-

Alta Vista Drones — Système de gestion des commandes clients

📍 Contexte et objectif

Alta Vista Drones est une entreprise spécialisée dans la production audiovisuelle par drone, principalement à destination du secteur immobilier. Les services incluent des prises de vue aériennes, le montage vidéo, les visites virtuelles et autres prestations de valorisation de biens.

Ce projet a pour but de concevoir une base de données relationnelle qui facilite le suivi complet de l'activité commerciale, depuis l'acquisition du client jusqu’au paiement de la facture, en passant par la commande et la production.

🎯 Portée fonctionnelle

La base permet de :

Enregistrer les informations des clients ;
Gérer un catalogue de prestations proposées ;
Suivre les commandes de clients, incluant plusieurs prestations ;
Générer des factures, calculer les montants HT/TTC et suivre les paiements ;
Conserver un historique des changements de statuts des commandes pour traçabilité.
Cette base est pensée pour permettre une extension future vers des modules comme la planification de rendez-vous, la gestion des équipes ou l’analyse de rentabilité par prestation.

🧩 Modèle conceptuel — entités et relations

Les entités sont :

Clients : personnes ou entreprises commandant des prestations, identifiées par un client_id.
Prestations : catalogue des services disponibles (ex : vidéo 4K, montage express...), chacun avec un prix_unitaire et une durée_estimee.
Commandes : regroupent les demandes d’un client à une date donnée, avec un statut (en attente, en cours, terminée).
Commandes_Prestations : table associative entre commandes et prestations, avec la quantité et une éventuelle remise.
Factures : liées aux commandes, elles récapitulent le total HT, la TVA et le total TTC, avec un suivi du paiement.
Paiements : associés à une facture, ils précisent le montant, la date et le moyen de paiement.
Historique_Commandes : journalisation des changements de statut d’une commande (utile pour la gestion de projet ou le SAV).

🗺️ Diagramme Entité-Relation

erDiagram
    Clients ||--o{ Commandes : passe
    Commandes ||--|{ Commandes_Prestations : contient
    Prestations ||--|{ Commandes_Prestations : est_dans
    Commandes ||--|| Factures : genere
    Factures ||--o{ Paiements : reglee_par
    Commandes ||--o{ Historique_Commandes : historise
    
⚙️ Choix de conception

Tables bien normalisées : Chaque entité ou relation a sa propre table, garantissant un modèle de données clair et extensible.
Clés étrangères et contraintes :
Intégrité référentielle assurée via FOREIGN KEY.
Contraintes CHECK sur les statuts pour éviter les erreurs de saisie.
Table d’historique séparée : Meilleure traçabilité des processus internes, utile pour l’amélioration continue et la transparence vis-à-vis du client.
Flexibilité : La table de liaison Commandes_Prestations autorise plusieurs prestations par commande et permet d’appliquer des remises.

🚀 Optimisations possibles

Création d'index sur les champs de recherche fréquente (ex : client_id, commande_id, statut_paiement).
Mise en place future de vues SQL pour simplifier les rapports financiers (total mensuel par client, top prestations…).
Possibilité d’ajouter des triggers pour mettre à jour automatiquement les montants des factures à chaque ajout de prestation.

⛔ Limitations actuelles

Calculs des totaux (total_ht, total_ttc) à faire manuellement ou via une requête externe, non automatisés.
Aucun suivi des utilisateurs internes (collaborateurs, techniciens drone).
Pas encore d’interface front-end pour utiliser la base via une application.
Aucun système de notification automatique pour les paiements en retard.
