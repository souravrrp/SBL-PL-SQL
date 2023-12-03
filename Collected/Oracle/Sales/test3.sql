--*****Select Data from Sales Analysis Report using result key + NSP & Tax
select r.result_key as result_key,
       r.S4 as shop_code,
       r.S8 as product_name,
       r.S9 as product_code,
       r.S10 as account_no,
       to_char(to_date(r.s1, 'yyyy-mm-dd'), 'yyyy-mm-dd') as sale_date,
       r.S15 as sales_type,
       r.N1 as total_sales,
       r.N2 as quantity,
       r.N2 / abs(r.N2),
       Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,
                                                    c.line_no,
                                                    c.rel_no,
                                                    c.line_item_no) *
       (r.N2 / abs(r.N2)) tax_amount,
       customer_order_line_api.Get_Sale_Price_Total(c.order_no,
                                                    c.LINE_NO,
                                                    c.REL_NO,
                                                    c.LINE_ITEM_NO) *
       (r.N2 / abs(r.N2)) NSP
  from ifsapp.info_services_rpt r,
       (Select d.order_no,
               max(d.line_no) line_no,
               max(d.rel_no) rel_no,
               max(d.line_item_no) line_item_no,
               d.catalog_no
          from customer_order_line d
         group by d.order_no, d.catalog_no) c
 where
--r.RESULT_KEY = 3166488 and
 r.result_key = (select max(a.RESULT_KEY)
                   from IFSAPP.ARCHIVE a
                  where a.REPORT_TITLE = 'Sales Analysis Report'
                    and a.owner = 'IFSAPP')
 and r.S10 = c.ORDER_NO(+)
 and r.s9 = c.CATALOG_NO(+) --AND
--r.s9 like '%REF%'
--r.S4 = 'LXPB' AND
--r.s1 is null AND 
--R.N2>1 and
--r.S10 = 'BHB-H1474' and 
--c.order_no = 'KMR-H1068'

--***** End Sales Data Transfer  

--*****Result Key wise total data
  select *
    from ifsapp.info_services_rpt r
   where --r.result_key = 3000519
   r.result_key = (select max(a.RESULT_KEY)
                     from IFSAPP.ARCHIVE a
                    where a.REPORT_TITLE = 'Sales Analysis Report'
                      and a.owner = 'IFSAPP')
  
  --******No. of rows in a result key
    select r.result_key,
           (to_char(to_date(r.s1, 'YYYY/MM/DD'), 'YYYY-MM-DD')) as sale_report_date,
           count(*) as input_sales
      from ifsapp.info_services_rpt r
     where --r.result_key = 3000519
     r.result_key = (select max(a.RESULT_KEY)
                       from IFSAPP.ARCHIVE a
                      where a.REPORT_TITLE = 'Sales Analysis Report'
                        and a.owner = 'IFSAPP') --AND
    --r.s1 is not null
     group by r.result_key,
              r.s1
              
              --Distinct Sale date in a result key
                select distinct (to_char(to_date(r.s1, 'YYYY/MM/DD'),
                                         'YYYY-MM-DD')) as sale_date
                  from ifsapp.info_services_rpt r
                 where r.s1 is not null
                   and r.result_key = 2974040 /*(select max(a.RESULT_KEY) 
                                      from IFSAPP.ARCHIVE a where a.REPORT_TITLE='Sales Analysis Report')*/
                
                --Status in the Customer Order Line
                  Select *
                          from customer_order_line d
                         where
                        --d.state = 'Invoiced/Closed' and 
                        --d.rel_no=1 and
                        --d.contract = 'DGNB' AND
                         d.order_no = 'CMP-H775' --AND
                        --d.real_ship_date between to_date('2014/1/1','YYYY/MM/DD') and to_date('2014/1/31','YYYY/MM/DD')
                        
                          select to_char(trunc(d.wanted_delivery_date),
                                         'YYYY/MM/DD')
                            from customer_order_line d
                                 
                                  select Customer_Order_Line_API.Get_Total_Tax_Amount(c.order_no,
                                                                                      c.line_no,
                                                                                      c.rel_no,
                                                                                      c.line_item_no) tax_amount,
                                         customer_order_line_api.Get_Sale_Price_Total(c.order_no,
                                                                                      c.LINE_NO,
                                                                                      c.REL_NO,
                                                                                      c.LINE_ITEM_NO) NSP,
                                         CUSTOMER_ORDER_LINE_API.Get_Real_Ship_Date(c.order_no,
                                                                                    c.LINE_NO,
                                                                                    c.REL_NO,
                                                                                    c.LINE_ITEM_NO) Real_Ship_Date,
                                         CUSTOMER_ORDER_LINE_API.Get_Wanted_Delivery_Date(c.order_no,
                                                                                          c.LINE_NO,
                                                                                          c.REL_NO,
                                                                                          c.LINE_ITEM_NO) Wanted_Delivery_Date
                                    from customer_order_line c
                                   where c.order_no = 'DGN-R11775' --'DMK-H2389'
                                  
                                  --Return Information
                                    select *
                                            from hpnret_sales_ret_line_tab sr
                                           where sr.order_no = 'DGN-R11775'
                                          
                                            Select *
                                                    from Customer_Order_Tab C
                                                   WHERE C.ORDER_NO =
                                                         'DMK-H2389'
                                                  
                                                  --No. of Hire Accounts
                                                    Select count(*)
                                                            from HPNRET_HP_HEAD_TAB h
                                                           where
                                                          --d.state = 'Invoiced/Closed' and 
                                                          --d.rel_no=1 and
                                                           h.contract =
                                                           'DGNB'
                                                       AND
                                                          --h.account_no= 'DGN-H4218' AND
                                                           h.original_sales_date between
                                                           to_date('2014/1/1',
                                                                   'YYYY/MM/DD') and
                                                           to_date('2014/2/1',
                                                                   'YYYY/MM/DD')
