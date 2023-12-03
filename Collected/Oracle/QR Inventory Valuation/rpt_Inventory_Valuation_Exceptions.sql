--***** Inventory Valuation Exceptions
select i.contract,
       i.part_no,
       i.description,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(i.part_product_code) brand,
       IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(i.part_product_family) product_family,
       i.inventory_valuation_method,
       i.negative_on_hand,
       i.create_date
  from IFSAPP.INVENTORY_PART i
 where i.inventory_valuation_method_db != 'AV'
