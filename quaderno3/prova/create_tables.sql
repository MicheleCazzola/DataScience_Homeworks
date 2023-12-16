DROP TABLE TAB1;
DROP TABLE TAB2;
DROP TABLE TAB3;
DROP TABLE TAB4;

--Con hash join
--5e5
CREATE TABLE TAB1(
	id1 integer not null,
	nome VARCHAR(20) not null,
	PRIMARY KEY(id1)
);

--5e4
CREATE TABLE TAB2(
	id2 integer not null,
	annoNascita integer not null,
	PRIMARY KEY(id2)
);

--Con nested loop
--1e5
CREATE TABLE TAB3(
	id3 integer not null,
	nome VARCHAR(20) not null,
	PRIMARY KEY(id3)
);

--5
CREATE TABLE TAB4(
	id4 integer not null,
	annoNascita integer not null,
	PRIMARY KEY(id4)
);