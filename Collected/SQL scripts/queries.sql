select * from sbl_vat_customer;
select * from sbl_vat_supplier;

select * from all_tables where table_name LIKE '%LINE%';
select* from all_tables where table_name LIKE '%UNIT%';

SELECT * FROM QUALITATIVE_MEASUREMENT_TAB; --EMPTY
SELECT * FROM MEASUREMENT_PARAMETER_TAB; --EMPTY

SELECT * FROM CURRENCY_TYPE_TAB;
SELECT * FROM CURRENCY_CODE; --CUR_CODE, CUR_DESC
SELECT * FROM CURRENCY_CODE_LOV;
--SELECT * FROM SDO_UNITS_OF_MEASURE; 
SELECT * FROM ISO_UNIT_TAB; --UNIT_CODE, UNIT_DESCRIPTION

select ''CUR_ID,
       c.CURRENCY_CODE,
       c.DESCRIPTION,
       ''CUR_ORIGIN_CODE,
       ''CUR_SYMBOL
FROM CURRENCY_CODE c;
      


       
SELECT ''MSR_UNIT_ID,u.UNIT_CODE, u.DESCRIPTION FROM ISO_UNIT_TAB u;


select table_name, column_name from all_tab_columns c where c.table_name like '%CURRENCY%' AND COLUMN_NAME LIKE '%CUR%' ORDER BY COLUMN_NAME;/*='CURRENCY_CODE';*/ /*IN('CURRENCY_CODE','DISTRICT_CODE') ORDER BY COLUMN_NAME

