/* Formatted on 2/26/2023 3:04:02 PM (QP5 v5.381) */
--CREATE SEQUENCE ifsapp.item_cost_upld_seq START WITH 1;
--DROP SEQUENCE ifsapp.item_cost_upld_seq;

CREATE TABLE ifsapp.sbl_fin_item_cost_upld
(
    cost_upld_id     INTEGER,
    creation_date    DATE,
    part_no          VARCHAR2 (50) NOT NULL,
    item_cost        NUMBER NOT NULL,
    start_date       DATE,
    end_date         DATE,
    remarks          VARCHAR2 (100),
    flag             VARCHAR2 (3),
    CONSTRAINT cost_upld_pk PRIMARY KEY (cost_upld_id)
);

--DROP TABLE ifsapp.sbl_fin_item_cost_upld;

CREATE TABLE ifsapp.sbl_fin_item_cost
(
    cost_id          INTEGER,
    creation_date    DATE,
    part_no          VARCHAR2 (50) NOT NULL,
    item_cost        NUMBER NOT NULL,
    start_date       DATE,
    end_date         DATE,
    remarks          VARCHAR2 (100),
    CONSTRAINT item_cost_pk PRIMARY KEY (cost_id)
);

--drop table ifsapp.sbl_fin_item_cost;
