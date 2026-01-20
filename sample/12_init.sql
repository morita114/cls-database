create database test;
use test;

create table fish (
     fishId INT PRIMARY KEY,
     number VARCHAR(10),
     name VARCHAR(10),
     gender VARCHAR(1)
);

insert into fish(fishId, number, name, gender) values (0, "F1_3", "NA", "F");
insert into fish(fishId, number, name, gender) values (0, "F1_5", "NA", "M");
