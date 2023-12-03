--***** National Sales Returns
select s.*,
       p.product_family,
       p.brand,
       (SELECT H.AREA_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = S.SITE) AREA_CODE,
       (SELECT H.DISTRICT_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = S.SITE) DISTRICT_CODE,
       ifsapp.customer_info_api.Get_Name(s.customer_no) customer_name,
       /*case
         when s.site in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO') then
          (select c.real_ship_date
             from ifsapp.Customer_Order_Line_Tab c
            inner join ifsapp.purchase_order_line_tab p
               on c.demand_order_ref1 = p.order_no
              and c.demand_order_ref2 = p.line_no
              and c.demand_order_ref3 = p.release_no
            where p.demand_order_no = s.ORDER_NO
              and p.demand_release = s.LINE_NO
              and p.demand_sequence_no = s.REL_NO)
         else
          (select c.real_ship_date
             from ifsapp.Customer_Order_Line_Tab c
            where c.order_no = s.ORDER_NO
              and c.line_no = s.LINE_NO
              and c.rel_no = s.REL_NO
              and c.catalog_type in ('INV', 'PKG'))
       end ORG_SALES_DATE,
       (select i.invoice_date
          from IFSAPP.CUSTOMER_ORDER_INV_ITEM i
         where i.order_no = S.ORDER_NO
           and i.line_no = S.LINE_NO
           and i.release_no = S.REL_NO
           and i.series_id = 'CD') ORG_SALES_DATE,*/
       /*(select t.n9
          from INVOICE_ITEM_TAB t
         where t.invoice_id = s.invoice_id
           and t.item_id = s.item_id) rma_no,
       (select t.n10
          from INVOICE_ITEM_TAB t
         where t.invoice_id = s.invoice_id
           and t.item_id = s.item_id) rma_line_no,*/
       ifsapp.return_material_reason_api.Get_Return_Reason_Description(ifsapp.return_material_line_api.Get_Return_Reason_Code((select t.n9
                                                                                                                                from INVOICE_ITEM_TAB t
                                                                                                                               where t.invoice_id =
                                                                                                                                     s.invoice_id
                                                                                                                                 and t.item_id =
                                                                                                                                     s.item_id),
                                                                                                                              (select t.n10
                                                                                                                                 from INVOICE_ITEM_TAB t
                                                                                                                                where t.invoice_id =
                                                                                                                                      s.invoice_id
                                                                                                                                  and t.item_id =
                                                                                                                                      s.item_id))) return_reason
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.product_code = p.product_code
 where s.sales_price != 0
   and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and s.status in ('Returned', 'ReturnCompleted', 'ReturnAfterCashConv')
 order by TO_NUMBER((SELECT H.DISTRICT_CODE
                      FROM IFSAPP.SHOP_DTS_INFO H
                     WHERE H.SHOP_CODE = S.SITE)),
          s.order_no,
          s.line_no,
          s.rel_no
