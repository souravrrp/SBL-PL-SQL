/* Formatted on 4/3/2022 2:13:48 PM (QP5 v5.381) */
  SELECT *
    FROM ifsapp.hpnret_rule
   WHERE 1 = 1
ORDER BY rule_no;

SELECT * FROM ifsapp.hpnret_rule_template;

SELECT * FROM ifsapp.hpnret_rule_link;

  SELECT *
    FROM ifsapp.sales_price_list_tab
   WHERE 1 = 1
ORDER BY rowversion, PRICE_LIST_NO;

SELECT *
  FROM ifsapp.commission_agree_line_tab calt;

SELECT *
  FROM ifsapp.sales_price_list_part_tab splpt;

SELECT * FROM ifsapp.sales_price_list;

SELECT * FROM ifsapp.sales_part_base_price;


SELECT *
  FROM ifsapp.sbl_discount_promotion sdp;


SELECT *
  FROM ifsapp.sales_price_list_part splp
 WHERE 1 = 1 AND PERCENTAGE_OFFSET > 0;


SELECT *
  FROM ifsapp.sbl_latest_price_list slpl
 WHERE ROWNUM < 3;