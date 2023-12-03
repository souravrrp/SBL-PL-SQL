--******Product Data Transfer

--*****INV type Product Data Transfer
select count(*) from SBL_JR_PRODUCT_DTL_INFO;

/*
delete from SBL_JR_PRODUCT_DTL_INFO;
commit;
*/
/*
truncate table SBL_JR_PRODUCT_DTL_INFO;
*/

/*
begin
  insert into SBL_JR_PRODUCT_DTL_INFO
    select I.part_no PRODUCT_CODE,
           I.description PRODUCT_DESC,
           I.part_product_code BRAND_CODE,
           IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(I.part_product_code) BRAND,
           I.part_product_family PRODUCT_FAMILY_CODE,
           ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(I.part_product_family) PRODUCT_FAMILY,
           I.second_commodity COMMODITY_GROUP2_CODE,
           IFSAPP.COMMODITY_GROUP_API.Get_Description(I.second_commodity) COMMODITY_GROUP2,
           'INV' PRODUCT_TYPE
      from IFSAPP.INVENTORY_PART I
     where I.contract = 'SCOM'
       and ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                             i.part_no) !=
           'RBOOK'
       AND ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                           i.part_no) !=
           'RAW'
       AND ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', i.part_no) not like
           'S-%'
     ORDER BY 1;
  commit;
end;
*/

--******PKG type Product Data Transfer
select count(*) from SBL_JR_PKG_PRODUCT_INFO;

/*
delete from SBL_JR_PKG_PRODUCT_INFO;
commit;
*/
/*
truncate table SBL_JR_PKG_PRODUCT_INFO;
*/

/*
begin
  insert into SBL_JR_PKG_PRODUCT_INFO
    select S.catalog_no PRODUCT_CODE,
           S.catalog_desc PRODUCT_DESC,
           '' BRAND_CODE,
           '' BRAND,
           S.part_product_family PRODUCT_FAMILY_CODE,
           ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(S.part_product_family) PRODUCT_FAMILY,
           S.catalog_group COMMODITY_GROUP2_CODE, -- SG_CODE
           IFSAPP.SALES_GROUP_API.Get_Description(S.catalog_group) COMMODITY_GROUP2, -- SALES_GROUP
           S.catalog_type_db PRODUCT_TYPE
      from IFSAPP.SALES_PART S
     WHERE S.contract = 'SCOM'
       AND S.catalog_type_db = 'PKG'
     ORDER BY 1;
  commit;
end;
*/
