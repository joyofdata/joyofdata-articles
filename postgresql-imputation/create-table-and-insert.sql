drop table if exists tbl;
create table tbl (
    t float,
    a int,
    b int,
    v float
);

insert into tbl (t, a, b, v)
values
-- a=10, b=7
(1.0, 10, 7, NULL),
(2.0, 10, 7, NULL),
(3.0, 10, 7, 1),
(3.5, 10, 7, NULL),
(4.0, 10, 7, NULL),
(5.0, 10, 7, 5),
(5.8, 10, 7, NULL),
(6.0, 10, 7, 3),
(6.5, 10, 7, NULL),
-- a=14, b=7
(1.0, 14, 7, NULL),
(2.0, 14, 7, NULL),
(3.0, 14, 7, 10),
(3.5, 14, 7, NULL),
(4.0, 14, 7, NULL),
(5.0, 14, 7, -10),
(5.8, 14, 7, NULL),
(6.0, 14, 7, 5),
(6.5, 14, 7, NULL)
;
