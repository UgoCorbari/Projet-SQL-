-- Création des différentes tables 

-- Création de la table Clients
CREATE TABLE Clients (
    client_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identifiant unique
    nom TEXT NOT NULL,
    email TEXT,
    téléphone TEXT,
    adresse TEXT
);

-- Table des prestations disponibles
CREATE TABLE Prestations (
    prestation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    description TEXT,
    prix_unitaire NUMERIC(10,2) NOT NULL, -- Meilleure précision monétaire
    durée_estimee INTEGER -- En minutes
);

-- Table des commandes clients (avec colonne secteur ajoutée)
CREATE TABLE Commandes (
    commande_id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,
    date_commande DATE NOT NULL,
    statut TEXT CHECK (statut IN ('en attente', 'en cours', 'terminée')),
    secteur TEXT CHECK (secteur IN ('immobilier', 'concessions', 'Hotels', 'Spa', 'Restaurants', 'Autres')),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

-- Table de liaison entre commandes et prestations
CREATE TABLE Commandes_Prestations (
    commande_id INTEGER,
    prestation_id INTEGER,
    quantité INTEGER NOT NULL DEFAULT 1 CHECK (quantité > 0),
    remise_pourcent NUMERIC(5,2) DEFAULT 0 CHECK (remise_pourcent BETWEEN 0 AND 100),
    PRIMARY KEY (commande_id, prestation_id),
    FOREIGN KEY (commande_id) REFERENCES Commandes(commande_id),
    FOREIGN KEY (prestation_id) REFERENCES Prestations(prestation_id)
);

-- Création de la table Factures
CREATE TABLE Factures (
    facture_id INTEGER PRIMARY KEY AUTOINCREMENT,
    commande_id INTEGER NOT NULL,
    date_facture DATE NOT NULL,
    total_ht NUMERIC(10,2),
    tva NUMERIC(5,2),
    total_ttc NUMERIC(10,2),
    statut_paiement TEXT CHECK (statut_paiement IN ('payée', 'en attente', 'en retard')),
    FOREIGN KEY (commande_id) REFERENCES Commandes(commande_id)
);

-- Création de la table Historique_Commandes
CREATE TABLE Historique_Commandes (
    historique_id INTEGER PRIMARY KEY AUTOINCREMENT,
    commande_id INTEGER NOT NULL,
    ancien_statut TEXT,
    nouveau_statut TEXT NOT NULL,
    date_changement DATETIME DEFAULT CURRENT_TIMESTAMP,
    modifié_par TEXT,
    FOREIGN KEY (commande_id) REFERENCES Commandes(commande_id)
);

-- Création de la table Paiements
CREATE TABLE Paiements (
    paiement_id INTEGER PRIMARY KEY AUTOINCREMENT,
    facture_id INTEGER NOT NULL,
    date_paiement DATE NOT NULL,
    montant NUMERIC(10,2) NOT NULL,
    moyen_paiement TEXT,
    FOREIGN KEY (facture_id) REFERENCES Factures(facture_id)
);
