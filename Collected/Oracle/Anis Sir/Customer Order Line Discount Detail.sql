--***** Customer Order Line Discount Detail
select b.c10 "SITE",
       b.sales_channel,
       b.AREA_CODE,
       b.DISTRICT_CODE,
       d.order_no,
       d.line_no,
       d.rel_no,
       d.line_item_no,
       d.discount_type,
       b.c5 PRODUCT_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(b.c10,
                                                                                                         b.c5)) brand,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(b.C5),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family(b.c10,
                                                                                                                b.c5)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(b.c10,
                                                                                                                    b.c5))) product_family,
       b.SALES_QUANTITY,
       d.calculation_basis unit_nsp,
       d.discount_amount,
       (b.SALES_QUANTITY * d.calculation_basis) nsp,
       (b.SALES_QUANTITY * d.discount_amount) total_discount_amount,
       b.net_curr_amount SALES_PRICE,
       b.vat_curr_amount VAT,
       d.remarks,
       b.invoice_id,
       b.item_id,
       b.invoice_date
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
                    (SELECT H.AREA_CODE
                       FROM IFSAPP.SHOP_DTS_INFO H
                      WHERE H.SHOP_CODE = t.c10) AREA_CODE,
                    (SELECT H.DISTRICT_CODE
                       FROM IFSAPP.SHOP_DTS_INFO H
                      WHERE H.SHOP_CODE = t.c10) DISTRICT_CODE,                    
                    t.c1,
                    t.c2,
                    t.c3,
                    t.c5,
                    t.c10,
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
                   /*and ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(t.c1, 1) =
                   'SP-27'*/
                /*and t.c5 \*like '%TV-%'*\ = 'SRSM-ZJ9513-G'*/
                /*and c.discount_type \*in ('TD', 'TD-CRT', 'TD-REF')*\
                    = \*'G-COUPLE OFFER-2019'*\
                    \*'G' 'CR-MASTERCARD DISCOUNT'*\ 'TD-SM-2020'*/ /*like 'G-ICC WC-2019'*/
             ) b
    on d.order_no = b.c1
   and d.line_no = b.c2
   and d.rel_no = b.c3
   and d.discount_line_no = b.discount_line_no
 where b.invoice_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
      /*and b.c10 = 'NTRB'*/
   and d.order_no not in /*exists*/
       (select r.order_no
          from ifsapp.HPNRET_CUSTOMER_ORDER_TAB r
         where r.ORDER_NO = D.ORDER_NO
           and r.CASH_CONV = 'TRUE')
 /*order by to_number((SELECT H.DISTRICT_CODE
                      FROM IFSAPP.SHOP_DTS_INFO H
                     WHERE H.SHOP_CODE = b.c10)),
          d.order_no,
          d.line_no,
          d.rel_no,
          d.line_item_no,
          d.discount_type*/ /*1,2,3,4,5*/