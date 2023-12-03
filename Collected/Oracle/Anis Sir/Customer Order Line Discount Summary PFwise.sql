--***** Customer Order Line Discount Summary
select extract(year from b.invoice_date) "YEAR",
       /*extract(month from b.invoice_date) "PERIOD",*/
       b.sales_channel,
       d.discount_type,
       b.c5 PRODUCT_CODE,
       b.product_family,
       b.brand,
       sum(b.SALES_QUANTITY) TOTAL_SALES_QUANTITY,
       sum(b.SALES_QUANTITY * d.calculation_basis) total_nsp,
       sum(b.SALES_QUANTITY * d.discount_amount) total_discount_amount
  from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
 inner join (select c.*,
                    case
                      when t.c10 in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'WITM') then
                       'WHOLESALE'
                      when t.c10 = 'SCSM' then
                       'CORPORATE'
                      when t.c10 = 'SITM' then
                       'IT CHANNEL'
                      when t.c10 = 'SSAM' then
                       'SMALL APPLIANCE CHANNEL'
                      when t.c10 = 'SOSM' then
                       'ONLINE CHANNEL'
                      when t.c10 in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM') then
                       'STAFF SCRAP & ACQUISITION'
                    /*when t.c10 in (select t.shop_code
                                    from ifsapp.shop_dts_info t
                                   where t.shop_code = t.c10) then
                    'RETAIL'*/
                      else
                      /*'BLANK'*/
                       'RETAIL'
                    end sales_channel,
                    t.c1,
                    t.c2,
                    t.c3,
                    t.c5,
                    t.c10,
                    IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(t.c10,
                                                                                                                      t.c5)) brand,
                    decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
                           'PKG',
                           ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family(t.c10,
                                                                                                                             t.c5)),
                           ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.c10,
                                                                                                                                 t.c5))) product_family,
                    decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
                           'PKG',
                           IFSAPP.SALES_PART_API.Get_Catalog_Group(t.c10,
                                                                   t.c5),
                           IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(t.c10,
                                                                          t.c5)) commodity_group2,
                    case
                      when t.net_curr_amount != 0 then
                       t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                      else
                       IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                          t.item_id,
                                                          T.N2) --t.n2
                    end SALES_QUANTITY,
                    t.net_curr_amount,
                    t.vat_curr_amount,
                    i.invoice_date
               from ifsapp.CUST_INVOICE_ITEM_DISCOUNT c
              inner join ifsapp.INVOICE_ITEM t
                 on c.invoice_id = t.invoice_id
                and c.item_id = t.item_id
              inner join ifsapp.INVOICE_TAB i
                 on t.invoice_id = i.invoice_id
              where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                and t.state = 'Posted'
                and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
                    ('INV', 'PKG')
             /*and c.discount_type \*in
             ('TD', 'TD-CRT') = 'G-10 PERCENT-NO FROST REF'*\ like 'G-AC DISCOUNT OFFER%'*/
             ) b
    on d.order_no = b.c1
   and d.line_no = b.c2
   and d.rel_no = b.c3
   and d.discount_line_no = b.discount_line_no
 where b.invoice_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and d.order_no not in /*exists*/
       (select r.order_no
          from ifsapp.HPNRET_CUSTOMER_ORDER_TAB r
         where r.ORDER_NO = D.ORDER_NO
           and r.CASH_CONV = 'TRUE')
 group by extract(year from b.invoice_date),
          /*extract(month from b.invoice_date),*/
          b.sales_channel,
          d.discount_type,
          b.c5,
          b.product_family,
          b.brand
 order by 1, 2, 3, 5, 6, 4