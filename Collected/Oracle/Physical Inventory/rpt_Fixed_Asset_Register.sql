select 
    --*
    f.shop_code,
    (select p.product_group from PRODUCT_INFO p where p.group_no = 
      (select c.group_no from PRODUCT_CATEGORY_INFO c where c.product_code = f.product_code)) PRODUCT_CATEGORY,
    f.product_code,
    f.serial_no,
    f.date_of_installation,
    decode(f.drop_from_246, 1, 'Yes', 2, 'No') drop_from_246,
    f.date_of_drop,
    f.remarks
from SBL_FIXED_ASSET_REGISTER_TAB f
where 
  f.shop_code like '&shop_code' --and
  --f.product_code like '&product_code'
order by f.shop_code, PRODUCT_CATEGORY
