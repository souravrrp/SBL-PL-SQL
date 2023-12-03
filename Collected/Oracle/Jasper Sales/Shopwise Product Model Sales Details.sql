--***** Shopwise Product Model Sales Details 
select s.site,
       l.area_code,
       l.district_code,
       s.order_no,
       s.line_no,
       s.rel_no,
       s.comp_no,
       s.status,
       s.sales_date,
       s.product_code,
       p.product_family,
       p.brand,
       /*(select r.serial_no
          from IFSAPP.CUSTOMER_ORDER_RES_SERIAL_LOV r
         where r.order_no = s.order_no
           and r.line_no = s.line_no
           and r.rel_no = s.rel_no
           and r.part_no = s.product_code) serial_no,
       IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(s.product_code,
                                             (select r.serial_no
                                                from IFSAPP.CUSTOMER_ORDER_RES_SERIAL_LOV r
                                               where r.order_no = s.order_no
                                                 and r.line_no = s.line_no
                                                 and r.rel_no = s.rel_no
                                                 and r.part_no =
                                                     s.product_code)) oem_no,*/
       s.sales_quantity,
       s.unit_nsp,
       s.discount "DISCOUNT(%)",
       s.sales_price,
       s.vat,
       s.amount_rsp/*,
       s.customer_no,
       ifsapp.customer_info_api.Get_Name(s.customer_no) customer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(s.customer_no) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(s.customer_no, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(s.customer_no, 1) customer_address*/
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 inner join IFSAPP.SHOP_DTS_INFO l
    on s.site = l.shop_code
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.product_code = p.product_code
 where s.sales_price != 0
   and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD') /*<= to_date('&TO_DATE', 'YYYY/MM/DD')*/
   /*and substr(s.order_no, 4, 2) = '-R'*/
   and s.status not in ('CashConverted', 'PositiveCashConv')
   /*and p.brand = \*'Singer'*\ \*'Beko'*\ 'Pureit'*/
   and p.product_family /*= 'AIR-CONDITIONER'*/ in
             ('COMPUTER-DESKTOP', 'COMPUTER-LAPTOP'/*, 'COMPUTER-ACCESSORIES'*/)
   /*and s.product_code \*= 'SRSM-SS-HEAD-15CH1'*\ in ('SRSM-ZJ9513-G', 'SRSM-ZJ-A6000-G', 'SRSM-ZJ8500G')*/ /*like '%REF-%'*/
 order by to_number(l.district_code),
          s.order_no,
          s.line_no,
          s.rel_no,
          s.comp_no;
