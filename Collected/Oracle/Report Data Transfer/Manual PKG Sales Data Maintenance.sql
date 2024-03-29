--***** Manual PKG Sales Data Maintenance
--***** PKG Sales Accounts Delete
/*
delete from IFSAPP.SBL_JR_SALES_DTL_PKG p
 where p.sales_date = to_date('&sales_date', 'YYYY/MM/DD');
commit;
*/

--***** PKG Sales Accounts Insert
/*
begin
  insert into IFSAPP.SBL_JR_SALES_DTL_PKG
    select t.invoice_id,
           t.item_id,
           t.c10 SITE,
           t.c1 ORDER_NO,
           t.c2 LINE_NO,
           t.c3 REL_NO,
           '0' COMP_NO,
           case
             when t.net_curr_amount = 0 then
              ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t.invoice_id,
                                                   t.item_id,
                                                   t.c1)
             else
              ifsapp.get_sbl_account_status(t.c1,
                                            t.c2,
                                            t.c3,
                                            t.c5,
                                            t.net_curr_amount,
                                            i.invoice_date)
           end status,
           i.invoice_date SALES_DATE,
           t.identity CUSTOMER_NO,
           (select c.vendor_no
              from ifsapp.CUSTOMER_ORDER_LINE_TAB c
             where c.order_no = t.c1
               and c.line_no = t.c2
               and c.rel_no = t.c3
               and c.catalog_no = t.c5) DELIVERY_SITE,
           t.c5 PRODUCT_CODE,
           case
             when t.net_curr_amount != 0 then
              (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
             else
              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                 t.item_id,
                                                 T.N2)
           end SALES_QUANTITY,
           t.net_curr_amount SALES_PRICE,
           case
             when t.net_curr_amount != 0 then
              (select l.base_sale_unit_price
                 from CUSTOMER_ORDER_LINE l
                where l.order_no = t.c1
                  and l.line_no = t.c2
                  and l.rel_no = t.c3
                  and l.catalog_no = t.c5) *
              (t.net_curr_amount / abs(t.net_curr_amount))
             else
              (select l.base_sale_unit_price
                 from CUSTOMER_ORDER_LINE l
                where l.order_no = t.c1
                  and l.line_no = t.c2
                  and l.rel_no = t.c3
                  and l.catalog_no = t.c5)
           end UNIT_NSP,
           t.n5 DISCOUNT,
           t.vat_curr_amount VAT,
           t.net_curr_amount + t.vat_curr_amount AMOUNT_RSP,
           i.pay_term_id
      from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
     where t.invoice_id = i.invoice_id
       and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
       and t.rowstate = 'Posted'
       and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG'
       and t.c10 not in ('BSCP',
                         'BLSP',
                         'CLSP',
                         'CSCP',
                         'CXSP', --New Service Center
                         'DSCP',
                         'MSCP', --New Service Center
                         'JSCP',
                         'RPSP', --New Service Center
                         'RSCP',
                         'SSCP',
                         'MS1C',
                         'MS2C',
                         'BTSC')
       and i.invoice_date = to_date('&sales_date', 'YYYY/MM/DD')
       --and t.net_curr_amount != 0
     order by t.c10, t.c1, i.invoice_date;

  COMMIT;
EXCEPTION
  WHEN no_data_found THEN
    dbms_output.put_line('Not inputed yet!');
  WHEN others THEN
    dbms_output.put_line('Error!');
  
end;
*/
