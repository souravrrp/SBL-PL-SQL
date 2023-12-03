select v1.site,
    v1.PRODUCT_CATEGORY,
    v1.catalog_no,    
    v1.qty_onhand,
    v1.qty_saleable,
    v1.qty_revert,
    v1.qty_ber,
    nvl(v2.qty_sold, 0) qty_sold,
    nvl(v3.qty_sent, 0) qty_sent,
    nvl(v4.qty_received, 0) qty_received,
    (v1.qty_onhand - (v1.qty_saleable + v1.qty_revert + v1.qty_ber + decode(v2.qty_sold, null, 0, v2.qty_sold) + 
        decode(v3.qty_sent, null, 0, v3.qty_sent) + decode(v4.qty_received, null, 0, v4.qty_received))) qty_short_over
from (select (select p.product_group 
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
from SBL_INVENTORY_COUNTING_DTS t
where --t.site like '&Shop_Code' and
  t.catalog_no in (select c.product_code 
                    from SBL_PRODUCT_CATEGORY_INFO c 
                    where c.group_no in (select p.group_no 
                                        from SBL_PRODUCT_INFO p)) --where p.product_group like '&Product_Category'))
order by t.site, PRODUCT_CATEGORY, t.catalog_no) v1 

left join 

(select (select p.product_group 
          from SBL_PRODUCT_INFO p
          where p.group_no = (select c.group_no 
            from SBL_PRODUCT_CATEGORY_INFO c
            where c.product_code = sl.product_code)) PRODUCT_CATEGORY,
    sl.product_code,
    sl.shop_code,      
    count(sl.quantity) qty_sold 
from SBL_SALES_TEMP_FOR_INVENTORY sl
--where sl.shop_code like '&Shop_Code'
group by sl.shop_code, sl.product_code) v2
on
v1.site = v2.shop_code and
v1.catalog_no = v2.product_code

left join

(select (select p.product_group 
          from SBL_PRODUCT_INFO p
          where p.group_no = (select c.group_no 
            from SBL_PRODUCT_CATEGORY_INFO c
            where c.product_code = se.product_code)) PRODUCT_CATEGORY,
    se.product_code, 
    se.shop_code, 
    sum(se.quantity) qty_sent 
from SBL_SEND_TEMP_FOR_INVENTORY se
where --se.shop_code like '&Shop_Code' and
se.product_code in (select c.product_code 
                    from SBL_PRODUCT_CATEGORY_INFO c 
                    where c.group_no in (select p.group_no 
                                        from SBL_PRODUCT_INFO p)) --where p.product_group like '&Product_Category'))
group by se.shop_code, se.product_code
order by se.shop_code, PRODUCT_CATEGORY, se.product_code) v3
on
v1.site = v3.shop_code and
v1.catalog_no = v3.product_code

left join

(select (select p.product_group 
          from SBL_PRODUCT_INFO p
          where p.group_no = (select c.group_no 
            from SBL_PRODUCT_CATEGORY_INFO c
            where c.product_code = r.product_code)) PRODUCT_CATEGORY,
    r.product_code,
    r.shop_code,
    sum(r.quantity) qty_received
from SBL_REVERT_ACCOUNT_TBL r
where --r.shop_code like '&Shop_Code' and
r.product_code in (select c.product_code 
                    from SBL_PRODUCT_CATEGORY_INFO c 
                    where c.group_no in (select p.group_no 
                                        from SBL_PRODUCT_INFO p)) --where p.product_group like '&Product_Category'))
group by r.shop_code, r.product_code
order by r.shop_code, PRODUCT_CATEGORY, r.product_code) v4
on
v1.site = v4.shop_code and
v1.catalog_no = v4.product_code
where v1.site like '&Shop_Code' and
v1.PRODUCT_CATEGORY like '&Product_Category'
order by v1.site, v1.PRODUCT_CATEGORY, v1.catalog_no
