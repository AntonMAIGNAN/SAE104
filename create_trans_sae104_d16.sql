drop schema if exists transmusicales cascade;
create schema transmusicales ;
set schema 'transmusicales';

CREATE TABLE _annee (
	an					NUMERIC(4) 	PRIMARY KEY
);

CREATE TABLE _edition (
	nom_edition			VARCHAR(20) PRIMARY KEY,
	annee_edition		NUMERIC(4)	NOT NULL,
	
	CONSTRAINT edition_fk_Annee FOREIGN KEY (annee_edition)
		REFERENCES _annee
);

CREATE TABLE _pays (
	nom_p				VARCHAR(20)	PRIMARY KEY
);

CREATE TABLE _ville (
	nom_v 				VARCHAR(20)	PRIMARY KEY,
	se_situe			VARCHAR(20)	NOT NULL,

	CONSTRAINT ville_fk_pays FOREIGN KEY (se_situe)
		REFERENCES _pays
);

CREATE TABLE _lieu (
	id_lieu				VARCHAR(20)	PRIMARY KEY,
	nom_lieu			VARCHAR(20)	NOT NULL,
	accesPMR			BOOLEAN		NOT NULL,
	capacite_max		INT			NOT NULL,
	type_lieu			VARCHAR(20)	NOT NULL,
	dans				VARCHAR(20)	NOT NULL,

	CONSTRAINT lieu_fk_ville FOREIGN KEY (dans)
		REFERENCES _ville(nom_v)
);

CREATE TABLE _groupe_artiste (
	id_groupe_artiste	VARCHAR(20)		PRIMARY KEY,
	nom_groupe_artiste 	VARCHAR(20)		NOT NULL,
	site_web			VARCHAR(2083)	NOT NULL,
	debut				NUMERIC(4)		NOT NULL,
	sortie_discographie	NUMERIC(4)		NOT NULL,
	a_pour_origine		VARCHAR(20)		NOT NULL,
	
	CONSTRAINT groupe_artiste_fk1_Annee FOREIGN KEY (debut)
		REFERENCES _annee,
	CONSTRAINT groupe_artiste_fk2_Annee FOREIGN KEY (sortie_discographie)
		REFERENCES _annee,
	CONSTRAINT Groupe_Ariste_fk_Pays FOREIGN KEY (a_pour_origine)
		REFERENCES _pays
);
	
CREATE TABLE _type_musique (
	type_m 				VARCHAR(20) PRIMARY KEY
);

CREATE TABLE _type_principal (
	id_groupe_artiste_r1	VARCHAR(20),
	type_m_r1				VARCHAR(20),
	
	CONSTRAINT type_principal_pk PRIMARY KEY (id_groupe_artiste_r1,type_m_r1),
	
	CONSTRAINT type_principal_fk_groupe_artiste FOREIGN KEY (id_groupe_artiste_r1)
		REFERENCES _groupe_artiste(id_groupe_artiste),
	CONSTRAINT type_principal_fk_type_musique FOREIGN KEY (type_m_r1)
		REFERENCES _type_musique(type_m)
);

CREATE TABLE _type_ponctuel (
	id_groupe_artiste_r2	VARCHAR(20),
	type_m_r2				VARCHAR(20),
	
	CONSTRAINT type_ponctuel_pk PRIMARY KEY (id_groupe_artiste_r2,type_m_r2),
	
	CONSTRAINT type_ponctuel_fk_groupe_artiste FOREIGN KEY (id_groupe_artiste_r2)
		REFERENCES _groupe_artiste(id_groupe_artiste),
	CONSTRAINT type_ponctuel_fk_type_musique FOREIGN KEY (type_m_r2)
		REFERENCES _type_musique(type_m)
);

CREATE TABLE _formation (
	libelle_formation	VARCHAR(20)	PRIMARY KEY
);

CREATE TABLE _a_pour (
	id_groupe_artiste_r		VARCHAR(20),
	libelle_formation_r		VARCHAR(20),
	
	CONSTRAINT a_pour_pk PRIMARY KEY (id_groupe_artiste_r,libelle_formation_r),
	
	CONSTRAINT a_pour_fk_groupe_artiste FOREIGN KEY (id_groupe_artiste_r)
		REFERENCES _groupe_artiste(id_groupe_artiste),
	CONSTRAINT a_pour_fk_formation FOREIGN KEY (libelle_formation_r)
		REFERENCES _formation(libelle_formation)
);


CREATE TABLE _concert (
	no_concert			VARCHAR(20) PRIMARY KEY,
	titre				VARCHAR(20) NOT NULL,
	resume				VARCHAR(20) NOT NULL,
	duree				INT 		NOT NULL,
	tarif				FLOAT 		NOT NULL,
	est_de				VARCHAR(20)	NOT NULL,
	se_deroule			VARCHAR(20) NOT NULL,
	
	CONSTRAINT concert_fk_type_musique FOREIGN KEY (est_de)
		REFERENCES _type_musique(type_m),
	CONSTRAINT concert_fk_edition FOREIGN KEY (se_deroule)
		REFERENCES _edition(nom_edition)
);

CREATE TABLE _representation (
	numero_representation 	VARCHAR(5) 	PRIMARY KEY,
	heure					CHAR(5)		NOT NULL,
	date_representation		CHAR(10)	NOT NULL,
	a_lieu_dans				VARCHAR(20)	NOT NULL,
	correspond_a			VARCHAR(20)	NOT NULL,
	jouee_par				VARCHAR(20)	NOT NULL,
	
	CONSTRAINT representation_fk_lieu FOREIGN KEY (a_lieu_dans)
		REFERENCES _lieu(id_lieu),
	CONSTRAINT representation_fk_concert FOREIGN KEY (correspond_a)
		REFERENCES _concert(no_concert),
	CONSTRAINT representation_fk_groupe_artiste FOREIGN KEY (jouee_par)
		REFERENCES _groupe_artiste(id_groupe_artiste)
);

commit;


