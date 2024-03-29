select
    v.shop_code,
    v.product_family,
    v.product_family_description,
    sum(v.qty_onhand) qty_onhand,
    v.age_month
from IFSAPP.sbl_vw_product_aging v
WHERE
  v.shop_code like '&shop_code' AND
  v.product_family like '&product_family' and
  v.part_no like '&part_no'
group by v.shop_code, v.product_family, v.product_family_description, v.age_month
order by v.shop_code, v.product_family, v.age_month
