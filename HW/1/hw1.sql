DROP TABLE IF EXISTS Person2Content;
DROP TABLE IF EXISTS Persons;
DROP TABLE IF EXISTS Films;

CREATE TABLE Persons(
id INT NOT NULL ,
fio TEXT NOT NULL,
PRIMARY KEY(id)
);


CREATE TABLE Films(
title TEXT NOT NULL,
id INT NOT NULL ,
country TEXT NOT NULL,
box_office INT NOT NULL,
release_year TIMESTAMP NOT NULL,
PRIMARY KEY(id)
);

INSERT INTO Films VALUES('Film1',1, 'Country1',1234567, '2018/12/31');
INSERT INTO Films VALUES('Film2',2, 'Country1',6786234,'2017/11/30');
INSERT INTO Films VALUES('Film3',3, 'Country2',98763527,'2016/10/29');
INSERT INTO Films VALUES('Film4',4, 'Country3',9635276,'2015/11/28');
INSERT INTO Films VALUES('Film5',5, 'Country2',2478626,'2014/12/30');

INSERT INTO Persons VALUES(1, 'Person_Produser');
INSERT INTO Persons VALUES(2, 'Person_Actor');


CREATE TABLE Person2Content(
person_id INT NOT NULL,
film_id INT NOT NULL,
persontype TEXT NOT NULL,
FOREIGN KEY (person_id) REFERENCES Persons(id),
FOREIGN KEY (film_id) REFERENCES Films(id)
);

INSERT INTO Person2Content VALUES(2,3, 'Actor');
INSERT INTO Person2Content VALUES(2,4, 'Actor');
INSERT INTO Person2Content VALUES(1,3, 'Producer');


