select p.catalog_no,
       IFSAPP.SALES_PART_API.Get_Catalog_Desc('SCOM', p.catalog_no) catalog_desc,
       to_char(p.valid_from_date_1, 'YYYY/MM/DD') valid_from_date_1,
       p.sale_price_1,
       p.hp_sale_price_1,
       p.discount,
       to_char(p.valid_from_date_2, 'YYYY/MM/DD') valid_from_date_2,
       p.sale_price_2,
       p.hp_sale_price_2,
       to_char(p.valid_from_date_3, 'YYYY/MM/DD') valid_from_date_3,
       p.sale_price_3,
       p.hp_sale_price_3,
       to_char(p.valid_from_date_4, 'YYYY/MM/DD') valid_from_date_4,
       p.sale_price_4,
       p.hp_sale_price_4
  from ifsapp.SBL_LATEST_SALES_PRICE p
 where p.catalog_no like '&catalog_no'
