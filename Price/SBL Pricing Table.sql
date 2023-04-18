/* Formatted on 4/3/2023 9:22:14 AM (QP5 v5.381) */
--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.sales_part_base_price_tab spbpt
 WHERE 1 = 1;


  SELECT *
    FROM ifsapp.sales_price_list_tab splt
   WHERE 1 = 1
ORDER BY splt.rowversion, splt.price_list_no;

SELECT *
  FROM ifsapp.commission_agree_line_tab calt
 WHERE 1 = 1;

SELECT *
  FROM ifsapp.sales_price_list_part_tab splpt
 WHERE 1 = 1
--AND SPLPT.BASE_PRICE_SITE NOT IN ('SCOM','DSCP','BTSC','ABDD','APWH')
;
-------------------------------View---------------------------------------------

SELECT *
  FROM ifsapp.sales_price_list spl
 WHERE 1 = 1;

SELECT *
  FROM ifsapp.sales_part_base_price spbp
 WHERE 1 = 1;


SELECT *
  FROM ifsapp.sales_price_list_part splp
 WHERE 1 = 1;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.sbl_latest_price_list slpl
 WHERE     1 = 1
       AND slpl.price_list_no = NVL ( :p_price_list_no, slpl.price_list_no)
       AND slpl.catalog_no = NVL ( :p_catalog_no, slpl.catalog_no);

SELECT *
  FROM ifsapp.sbl_latest_sales_price slsp
 WHERE 1 = 1 AND slsp.catalog_no = NVL ( :p_catalog_no, slsp.catalog_no);