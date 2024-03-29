CREATE OR REPLACE VIEW SBL_PHYSICAL_INVENTORY_STATUS AS
select v1.site,
       v1.PRODUCT_CATEGORY,
       v1.catalog_no,
       nvl(v1.qty_onhand, 0) qty_onhand,
       nvl(v1.qty_in_transit, 0) qty_in_transit,
       nvl(v1.qty_saleable, 0) qty_saleable,
       nvl(v1.qty_co_return, 0) qty_co_return,
       nvl(v5.qty_revert, 0) qty_revert,
       nvl(v1.qty_ber, 0) qty_ber,
       nvl(v1.qty_under_service, 0) qty_under_service,
       nvl(v1.qty_defective, 0) qty_defective,
       nvl(v2.qty_sold, 0) qty_sold,
       nvl(v3.qty_sent, 0) qty_sent,
       nvl(v4.qty_received, 0) qty_received,
       ((decode(v1.qty_saleable, null, 0, v1.qty_saleable) +
       (decode(v1.qty_co_return, null, 0, v1.qty_co_return) +
       decode(v5.qty_revert, null, 0, v5.qty_revert) +
       decode(v1.qty_ber, null, 0, v1.qty_ber) +
       decode(v2.qty_sold, null, 0, v2.qty_sold) +
       decode(v3.qty_sent, null, 0, v3.qty_sent) +
       decode(v1.qty_under_service, null, 0, v1.qty_under_service)) +
       decode(v1.qty_defective, null, 0, v1.qty_defective)) -
       (decode(v1.qty_onhand, null, 0, v1.qty_onhand) +
       decode(v1.qty_in_transit, null, 0, v1.qty_in_transit)+
       decode(v4.qty_received, null, 0, v4.qty_received))) qty_short_over,
       v1.remarks,
       v1.settlement_deadline,
       v1.approver_comment
  from (select (select p.product_group
                  from IFSAPP.SBL_PRODUCT_INFO p
                 where p.group_no =
                       (select c.group_no
                          from IFSAPP.PRODUCT_CATEGORY_INFO c
                         where c.product_code = t.catalog_no)) PRODUCT_CATEGORY,
               t.catalog_no,
               t.site,
               t.qty_onhand,
               t.qty_in_transit,
               t.qty_saleable,
               t.qty_co_return,
               t.qty_revert,
               t.qty_ber,
               t.qty_under_service,
               t.qty_defective,
               t.remark_saleable remarks,
               t.settlement_deadline,
               t.approver_comment
          from IFSAPP.SBL_INVENTORY_COUNTING_DTS t
         where t.catalog_no in
               (select c.product_code
                  from IFSAPP.PRODUCT_CATEGORY_INFO c
                 where c.group_no in (select p.group_no from IFSAPP.SBL_PRODUCT_INFO p))
         order by t.site, PRODUCT_CATEGORY, t.catalog_no) v1

  LEFT JOIN

 (select (select p.product_group
            from IFSAPP.SBL_PRODUCT_INFO p
           where p.group_no =
                 (select c.group_no
                    from IFSAPP.PRODUCT_CATEGORY_INFO c
                   where c.product_code = sl.product_code)) PRODUCT_CATEGORY,
         sl.product_code,
         sl.shop_code,
         sum(sl.quantity) qty_sold
    from SBL_SALES_TEMP_FOR_INVENTORY sl
   group by sl.shop_code, sl.product_code) v2
    on v1.site = v2.shop_code
   and v1.catalog_no = v2.product_code

  LEFT JOIN

 (select (select p.product_group
            from IFSAPP.SBL_PRODUCT_INFO p
           where p.group_no =
                 (select c.group_no
                    from IFSAPP.PRODUCT_CATEGORY_INFO c
                   where c.product_code = se.product_code)) PRODUCT_CATEGORY,
         se.product_code,
         se.shop_code,
         sum(se.quantity) qty_sent
    from SBL_SEND_TEMP_FOR_INVENTORY se
   where se.product_code in
         (select c.product_code
            from IFSAPP.PRODUCT_CATEGORY_INFO c
           where c.group_no in (select p.group_no from IFSAPP.SBL_PRODUCT_INFO p))
   group by se.shop_code, se.product_code
   order by se.shop_code, PRODUCT_CATEGORY, se.product_code) v3
    on v1.site = v3.shop_code
   and v1.catalog_no = v3.product_code

  LEFT JOIN

 (select (select p.product_group
            from IFSAPP.SBL_PRODUCT_INFO p
           where p.group_no =
                 (select c.group_no
                    from IFSAPP.PRODUCT_CATEGORY_INFO c
                   where c.product_code = rc.product_code)) PRODUCT_CATEGORY,
         rc.product_code,
         rc.shop_code,
         sum(rc.quantity) qty_received
    from REC_AFTER_CUT_OFF_TBL rc
   where rc.product_code in
         (select c.product_code
            from IFSAPP.PRODUCT_CATEGORY_INFO c
           where c.group_no in (select p.group_no from IFSAPP.SBL_PRODUCT_INFO p))
   group by rc.shop_code, rc.product_code
   order by rc.shop_code, PRODUCT_CATEGORY, rc.product_code) v4
    on v1.site = v4.shop_code
   and v1.catalog_no = v4.product_code

  LEFT JOIN

 (select (select p.product_group
            from IFSAPP.SBL_PRODUCT_INFO p
           where p.group_no =
                 (select c.group_no
                    from IFSAPP.PRODUCT_CATEGORY_INFO c
                   where c.product_code = r.product_code)) PRODUCT_CATEGORY,
         r.shop_code,
         r.product_code,
         sum(r.quantity) qty_revert
    from SBL_REVERT_ACCOUNT_TBL r
   where r.product_code in
         (select c.product_code
            from IFSAPP.PRODUCT_CATEGORY_INFO c
           where c.group_no in (select p.group_no from IFSAPP.SBL_PRODUCT_INFO p))
   group by r.shop_code, r.product_code
   order by r.shop_code, PRODUCT_CATEGORY, r.product_code) v5

    on v1.site = v5.shop_code
   and v1.catalog_no = v5.product_code

 order by v1.site, v1.PRODUCT_CATEGORY, v1.catalog_no;
