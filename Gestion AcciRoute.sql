-- Personne (NP : char(9), nom : varchar(35), VilleP : Varchar(50))
-- Voiture (Imma : Char(6), modele : varchar(20), annee : char(4), #NP : char(9))
-- Accident (DateAc : Date, # NP : char(9), dommage : numeric(7 :2), villeAc : varchar(50),#imma : char(6) )
-- Avec :
-- 1. Les types des attributs repr�sentent les domaines syntaxiques.
-- 2. Une personne est propri�taire d�une ou plusieurs voitures.
-- 3. Une personne ne  conduit qu�une voiture dont elle est propri�taire.


-- 1.	Cr�er la base de donn�es AcciRoute.
create database AcciRoute
use AcciRoute

-- 2.	Cr�er la proc�dure CreateAcciRoute qui permet de construire les 
-- tables de donn�es AcciRoute en les supprimant s�ils existent avant leur cr�ation.
create procedure CreateAcciRoute 
as
begin
  if exists (select * from INFORMATION_SCHEMA.TABLES where table_name='Accident')
    drop table Accident
  if exists (select * from INFORMATION_SCHEMA.TABLES where table_name='Voiture')
    drop table Voiture
  if exists (select * from INFORMATION_SCHEMA.TABLES where table_name='Personne')
    drop table Personne
  
  create table Personne (
      NP char(9),
      nom varchar(35),
      VilleP Varchar(50)
      constraint pk_personne primary key(NP)
   )
 
   create table Voiture (
      Imma Char(6),
      modele varchar(20),
      annee char(4),
      NP char(9),
      constraint pk_Voiture primary key(Imma),
      constraint fk_Voiture_personne foreign key(NP) references Personne(NP)
	  )
   create table Accident (
      DateAc Date,
      NP char(9),
      dommage numeric(7,2),
      villeAc varchar(50),
      imma char(6),
      constraint fk_accident_personne foreign key(NP) references Personne(NP),
      constraint fk_accident_voiture foreign key(Imma) references Voiture(Imma),
      constraint pk_accident primary key(DateAc,NP,imma)
      )
end
exec CreateAcciRoute

-- 3.	Cr�er la proc�dure InsertAccident qui permet d�ins�rer les donn�es 
-- dans Accident en v�rifiant l�int�grit� r�f�rentielle.
create procedure InsertAccident(@dateAc date,@NP char(9),@dommage numeric(7,2),@villeAc varchar(50),@imma char(6))
as
begin
   if ((select count(NP)from Personne where NP=@NP)=0)
     begin
	   print 'Ce personne n existe pas'
	   return
	 end
   if ((select count(Imma)from Voiture where Imma=@Imma)=0)
     begin
	   print 'Cette voiture n existe pas'
	   return
	 end
   insert into Accident values(@dateAc,@NP,@dommage,@villeAc,@imma)
end

exec InsertAccident '2021-01-01','123456789',10000,'Marrakech','123456'

-- 4.	Cr�er la proc�dure GetnumProp qui permet de calculer le nombre de propri�taires
-- impliqu�s dans un accident entre deux ann�es donn�es.
create procedure GetnumProp(@anneMin char(4),@anneMax char(4)) 
as 
begin
  select distinct count(NP) from Accident
  where dateAc between @anneMin+'-01-01' and @anneMax+'-12-30'
end

exec GetnumProp '2020-01-01','2021-02-01'
--5.	Cr�er la proc�dure GetProp qui donne le nom et le nas des propri�taires
-- qui ont fait deux accidents dans un intervalle de 4 mois.
create procedure GetProp()
as