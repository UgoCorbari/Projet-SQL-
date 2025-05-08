## Création des différentes tables 

CREATE TABLE Clients (
    client_id INTEGER PRIMARY KEY,
    nom TEXT NOT NULL,
    email TEXT,
    téléphone TEXT,
    adresse TEXT
);

CREATE TABLE Prestations (
    prestation_id INTEGER PRIMARY KEY,
    nom TEXT NOT NULL,
    description TEXT,
    prix_unitaire REAL NOT NULL,
    durée_estimee INTEGER
);

CREATE TABLE Commandes (
    commande_id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL,
    date_commande DATE NOT NULL,
    statut TEXT CHECK (statut IN ('en attente', 'en cours', 'terminée')),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

CREATE TABLE Commandes_Prestations (
    commande_id INTEGER,
    prestation_id INTEGER,
    quantité INTEGER NOT NULL DEFAULT 1,
    remise_pourcent REAL DEFAULT 0,
    PRIMARY KEY (commande_id, prestation_id),
    FOREIGN KEY (commande_id) REFERENCES Commandes(commande_id),
    FOREIGN KEY (prestation_id) REFERENCES Prestations(prestation_id)
);

CREATE TABLE Factures (
    facture_id INTEGER PRIMARY KEY,
    commande_id INTEGER NOT NULL,
    date_facture DATE NOT NULL,
    total_ht REAL,
    tva REAL,
    total_ttc REAL,
    statut_paiement TEXT CHECK (statut_paiement IN ('payée', 'en attente', 'en retard')),
    FOREIGN KEY (commande_id) REFERENCES Commandes(commande_id)
);

CREATE TABLE Paiements (
    paiement_id INTEGER PRIMARY KEY,
    facture_id INTEGER NOT NULL,
    date_paiement DATE NOT NULL,
    montant REAL NOT NULL,
    moyen_paiement TEXT,
    FOREIGN KEY (facture_id) REFERENCES Factures(facture_id)
);

CREATE TABLE Historique_Commandes (
    historique_id INTEGER PRIMARY KEY,
    commande_id INTEGER NOT NULL,
    ancien_statut TEXT,
    nouveau_statut TEXT NOT NULL,
    date_changement DATETIME DEFAULT CURRENT_TIMESTAMP,
    modifié_par TEXT,
    FOREIGN KEY (commande_id) REFERENCES Commandes(commande_id)
);
