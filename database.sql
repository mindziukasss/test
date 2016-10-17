CREATE TABLE customers (
  id bigserial primary key,
  name varchar(20) NOT NULL,
  surname varchar(20)  NOT NULL,
  age integer,
  code integer
);