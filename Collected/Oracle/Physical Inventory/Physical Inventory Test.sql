(select (select p.product_group 
          from SBL_PRODUCT_INFO p
          where p.group_no = (select c.group_no 
            from SBL_PRODUCT_CATEGORY_INFO c
            where c.product_code = t.catalog_no)) PRODUCT_CATEGORY,
    t.catalog_no,
    t.site,
    t.qty_onhand,
    t.qty_saleable,
    t.qty_revert,
    t.qty_ber
    --sl.quantity qty_sale
from SBL_INVENTORY_COUNTING_DTS t--,
  --SBL_SALES_TEMP_FOR_INVENTORY sl
where --t.site = sl.shop_code and
  --t.catalog_no = sl.product_code and
  t.site like '&Shop_Code' and
  t.catalog_no in (select c.product_code 
                    from SBL_PRODUCT_CATEGORY_INFO c 
                    where c.group_no in (select p.group_no 
                                        from SBL_PRODUCT_INFO p where p.product_group like '&Product_Category'))
order by t.site, PRODUCT_CATEGORY, t.catalog_no) v1

(select (select p.product_group 
          from SBL_PRODUCT_INFO p
          where p.group_no = (select c.group_no 
            from SBL_PRODUCT_CATEGORY_INFO c
            where c.product_code = sl.product_code)) PRODUCT_CATEGORY,
    sl.product_code,
    sl.shop_code,     
    sum(sl.quantity) qty_sold 
from SBL_SALES_TEMP_FOR_INVENTORY sl
where sl.shop_code like '&Shop_Code' and
sl.product_code in (select c.product_code 
                    from SBL_PRODUCT_CATEGORY_INFO c 
                    where c.group_no in (select p.group_no 
                                        from SBL_PRODUCT_INFO p where p.product_group like '&Product_Category'))
group by sl.shop_code, sl.product_code
order by sl.shop_code, PRODUCT_CATEGORY, sl.product_code) v2

(select (select p.product_group 
          from SBL_PRODUCT_INFO p
          where p.group_no = (select c.group_no 
            from SBL_PRODUCT_CATEGORY_INFO c
            where c.product_code = se.product_code)) PRODUCT_CATEGORY,
    se.product_code, 
    se.shop_code, 
    sum(se.quantity) qty_sale 
from SBL_SEND_TEMP_FOR_INVENTORY se
where se.shop_code like '&Shop_Code' and
se.product_code in (select c.product_code 
                    from SBL_PRODUCT_CATEGORY_INFO c 
                    where c.group_no in (select p.group_no 
                                        from SBL_PRODUCT_INFO p where p.product_group like '&Product_Category'))
group by se.shop_code, se.product_code
order by se.shop_code, PRODUCT_CATEGORY, se.product_code) v3


(select (select p.product_group 
          from SBL_PRODUCT_INFO p
          where p.group_no = (select c.group_no 
            from SBL_PRODUCT_CATEGORY_INFO c
            where c.product_code = r.product_code)) PRODUCT_CATEGORY,
    r.product_code,
    r.shop_code,
    sum(r.quantity) qty_receive
from SBL_REVERT_ACCOUNT_TBL r
where r.shop_code like '&Shop_Code' and
r.product_code in (select c.product_code 
                    from SBL_PRODUCT_CATEGORY_INFO c 
                    where c.group_no in (select p.group_no 
                                        from SBL_PRODUCT_INFO p where p.product_group like '&Product_Category'))
group by r.shop_code, r.product_code
order by r.shop_code, PRODUCT_CATEGORY, r.product_code) v4
