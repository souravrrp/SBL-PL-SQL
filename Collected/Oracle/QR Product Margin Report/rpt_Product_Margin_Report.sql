select p.YEAR,
       p.PERIOD,
       p.part_no,
       p.brand,
       p.product_family,
       p.total_month_end_stock,
       p.current_stock,
       to_char(p.price_date, 'YYYY/MM/DD') price_date,
       p.sale_price,
       p.discount,
       p.discounted_sale_price,
       p.VAT_RATE,
       p.VAT,
       p.GM,
       p.GMP "GM(%)"
  from ifsapp.SBL_PRODUCT_MARGIN p
 where p.year = '&year_i'
   and p.period = '&period'
   and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Code('SCOM',
                                                                                                         p.part_no)) like
       '&brand'
   and IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM',
                                                                                                             p.part_no)) like
       '&product_family'
   and p.part_no like '&part_no'
