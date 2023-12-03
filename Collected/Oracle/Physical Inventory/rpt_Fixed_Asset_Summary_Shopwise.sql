select 
    --*
    f.shop_code,
    (select p.product_group from PRODUCT_INFO p where p.group_no = 
      (select c.group_no from PRODUCT_CATEGORY_INFO c where c.product_code = f.product_code)) PRODUCT_CATEGORY,
    f.product_code,
    count(f.product_code) quantity
from SBL_FIXED_ASSET_REGISTER_TAB f
where 
  f.shop_code like '&shop_code' --and
  --f.product_code like '&product_code'
group by f.shop_code, f.product_code
order by f.shop_code, PRODUCT_CATEGORY
