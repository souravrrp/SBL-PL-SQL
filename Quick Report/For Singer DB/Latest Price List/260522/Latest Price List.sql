/* Formatted on 5/26/2022 3:44:12 PM (QP5 v5.381) */
SELECT t.price_list_no,
       t.catalog_no,
       t.part_desc,
       t.brand,
       t.product_family,
       t.commodity_group2,
       TO_CHAR (t.valid_from_date, 'YYYY/MM/DD')     valid_from_date,
       t.sales_price,
       t.cash_tax_code                               tax_code,
       t.vat_rate,
       t.co_discount,
       t.co_discount_pct,
       t.hp_discount,
       t.hp_discount_pct,
       t.cash_price,
       t.hire_cash_price,
       t.cash_commission,
       t.hp_commission
  FROM ifsapp.sbl_latest_price_list t
 WHERE     t.price_list_no = '&PRICE_LIST_NO'
       AND t.catalog_no LIKE UPPER ('%&CATALOG_NO%')