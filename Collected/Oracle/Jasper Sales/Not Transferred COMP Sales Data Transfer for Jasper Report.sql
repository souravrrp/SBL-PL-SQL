--***** Not Transferred COMP Sales Data Transfer for Jasper Report
declare
  from_date_ date := to_date('&from_date', 'YYYY/MM/DD');
  to_date_   date := to_date('&to_date', 'YYYY/MM/DD');

begin
  insert into SBL_JR_SALES_DTL_PKG_COMP
    select a.*
      from (select t.invoice_id,
                   t.item_id,
                   t.c10 SITE,
                   t.c1 ORDER_NO,
                   t.c2 LINE_NO,
                   t.c3 REL_NO,
                   L.LINE_ITEM_NO COMP_NO,
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
                      from ifsapp.CUSTOMER_ORDER_LINE c
                     where c.order_no = t.c1
                       and c.line_no = t.c2
                       and c.rel_no = t.c3
                       and c.line_item_no = L.line_item_no) DELIVERY_SITE,
                   L.CATALOG_NO PRODUCT_CODE,
                   L.QTY_INVOICED SALES_QUANTITY,
                   IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(t.c1,
                                                                   t.c2,
                                                                   t.c3,
                                                                   L.LINE_ITEM_NO) SALES_PRICE,
                   ROUND(L.PART_PRICE, 2) UNIT_NSP,
                   t.n5 DISCOUNT,
                   ROUND((L.COST * L.QTY_INVOICED * t.vat_curr_amount) /
                     (select L2.COST
                        from IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
                       WHERE L2.ORDER_NO = t.c1
                         AND L2.LINE_NO = t.c2
                         AND L2.REL_NO = t.c3
                         AND L2.CATALOG_TYPE = 'PKG'),
                     2) VAT,
                   IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(t.c1,
                                                                   t.c2,
                                                                   t.c3,
                                                                   L.LINE_ITEM_NO) +
               ROUND((L.COST * L.QTY_INVOICED * t.vat_curr_amount) /
                     (select L2.COST
                        from IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
                       WHERE L2.ORDER_NO = t.c1
                         AND L2.LINE_NO = t.c2
                         AND L2.REL_NO = t.c3
                         AND L2.CATALOG_TYPE = 'PKG'),
                     2) AMOUNT_RSP,
                   i.pay_term_id,
                   L.FEE_CODE vat_code,
                   i.series_id invoice_series,
                   i.invoice_no,
                   i.voucher_type_ref voucher_type,
                   i.voucher_no_ref voucher_no,
                   ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(t.c1, 1) bb_no,
                   IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', L.FEE_CODE) vat_rate,
                   CASE
                     WHEN SUBSTR(t.c1, 4, 2) = '-H' THEN
                      (select D.LINE_NO
                         from IFSAPP.HPNRET_HP_DTL_TAB D
                        where D.ACCOUNT_NO = t.c1
                          AND D.REF_LINE_NO = t.c2
                          AND D.REF_REL_NO = t.c3
                          AND D.CATALOG_NO = L.CATALOG_NO)
                     ELSE
                      t.c4
                   END ACCT_LINE_NO
              from IFSAPP.CUSTOMER_ORDER_LINE_TAB L
              LEFT JOIN ifsapp.invoice_item_tab t
                on L.ORDER_NO = t.c1
               AND L.LINE_NO = t.c2
               AND L.REL_NO = t.c3
             inner join ifsapp.INVOICE_TAB i
                on t.invoice_id = i.invoice_id
             where L.CATALOG_TYPE = 'KOMP'
               and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
               and t.rowstate = 'Posted'
               and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG') a
     inner join (select t2.invoice_id, t2.item_id
                   from ifsapp.invoice_item_tab t2, ifsapp.INVOICE_TAB i2
                  where t2.invoice_id = i2.invoice_id
                    and t2.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                    and t2.rowstate = 'Posted'
                    and IFSAPP.SALES_PART_API.Get_Catalog_Type(T2.C5) =
                        'PKG'
                    and t2.c10 not in ('BSCP',
                                       'BLSP',
                                       'CLSP',
                                       'CSCP',
                                       'CXSP', --New Service Center
                                       'DSCP',
                                       'JSCP',
                                       'KSCP', --New Service Center
                                       'MSCP', --New Service Center   
                                       'NSCP', --New Service Center
                                       'RPSP', --New Service Center
                                       'RSCP',
                                       'SSCP',
                                       'MS1C',
                                       'MS2C',
                                       'BTSC')
                    and i2.invoice_date between from_date_ and to_date_
                 
                 minus
                 
                 select s.invoice_id, s.item_id
                   from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP s
                  where s.sales_date between from_date_ and to_date_) b
        on a.invoice_id = b.invoice_id
       and a.item_id = b.item_id
     order by a.SITE, a.ORDER_NO, a.SALES_DATE;
  COMMIT;

EXCEPTION
  WHEN no_data_found THEN
    dbms_output.put_line('Not inputed yet!');
  WHEN others THEN
    dbms_output.put_line('Error!');
end;
