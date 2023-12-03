select
    t.contract,
    t.part_no,
    IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(t.part_product_code) Brand,
    IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(t.part_product_family) product_family,
    IFSAPP.COMMODITY_GROUP_API.Get_Description(t.second_commodity) commodity_group
from IFSAPP.INVENTORY_PART t
where 
  t.contract like 'SCOM' and
  t.second_commodity != 'RBOOK' and
  t.second_commodity not like 'S-%'
