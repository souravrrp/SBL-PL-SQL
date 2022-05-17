/* Formatted on 4/11/2022 10:38:57 AM (QP5 v5.381) */
SELECT pci.group_no, pi.product_group, pci.product_code
  FROM ifsapp.product_category_info pci, ifsapp.product_info pi
 WHERE 1 = 1 AND pi.group_no = pci.group_no;

--------------------------------------------------------------------------------


SELECT *
  FROM ifsapp.product_category_info pci;

SELECT * FROM ifsapp.product_category_info2;

SELECT *
  FROM ifsapp.product_info pi;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.sbl_product_info spi;

SELECT * FROM ifsapp.sbl_jr_rst_product_group;

SELECT * FROM ifsapp.sbl_itasm_product_info;

SELECT * FROM ifsapp.sbl_jr_product_dtl_info;

SELECT * FROM ifsapp.sbl_jr_pkg_product_info;

SELECT * FROM ifsapp.sbl_product_info_srv;

--------------------------------------------------------------------------------

SELECT * FROM ifsapp.hpnret_attach_products_tab;

SELECT * FROM ifsapp.hpnret_comp_product_code_tab;

SELECT * FROM ifsapp.hpnret_comp_product_family_tab;

SELECT * FROM ifsapp.hpnret_comp_product_tab;


SELECT * FROM ifsapp.hpnret_product_code_tab;

SELECT * FROM ifsapp.hpnret_product_family_tab;

SELECT * FROM ifsapp.hpnret_product_tab;

SELECT * FROM ifsapp.hpnret_singer_product_code_tab;

SELECT * FROM ifsapp.hpnret_singer_product_tab;