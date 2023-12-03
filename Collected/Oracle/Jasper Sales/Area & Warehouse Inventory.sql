--*****Shop Inventory
select s.area_code,
       /*s.district_code,
       i.contract,*/
       i.part_no,
       p.product_family,
       i.qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 inner join IFSAPP.SHOP_DTS_INFO s
    on i.contract = s.shop_code
 where i.qty_onhand > 0
   and $X{IN, p.product_family, PRODUCT_FAMILY}
   and $X{IN, i.part_no, PART_NO}

union all

--*****Warehouse Inventory
select i.contract, i.part_no, p.product_family, i.qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 inner join IFSAPP.WARE_HOUSE_INFO w
    on i.contract = w.ware_house_name
 where i.qty_onhand > 0
   and $X{IN, p.product_family, PRODUCT_FAMILY}
   and $X{IN, i.part_no, PART_NO};

--
select s.area_code "SITE", i.part_no, p.product_family, i.qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 inner join IFSAPP.SHOP_DTS_INFO s
    on i.contract = s.shop_code
 where i.qty_onhand > 0
   and $X{IN, p.product_family, PRODUCT_FAMILY}
   and $X{IN, i.part_no, PART_NO}
union all
select i.contract "SITE", i.part_no, p.product_family, i.qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 inner join IFSAPP.WARE_HOUSE_INFO w
    on i.contract = w.ware_house_name
 where i.qty_onhand > 0
   and $X{IN, p.product_family, PRODUCT_FAMILY}
   and $X{IN, i.part_no, PART_NO};
