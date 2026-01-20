CREATE DATABASE sample;
USE sample;

CREATE SEQUENCE emp_seq
  AS INT
  START WITH 1001
  INCREMENT BY 1
  MINVALUE 1001
  MAXVALUE 9999
  NOCYCLE
  CACHE 10;

CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  name VARCHAR(50)
);

INSERT INTO employee (emp_id, name)
VALUES (NEXT VALUE FOR emp_seq, 'Tanaka'),
       (NEXT VALUE FOR emp_seq, 'Sato');