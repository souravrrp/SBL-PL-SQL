--***** National Computer Sales Details
select s.site,
       (SELECT H.AREA_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = S.SITE) AREA_CODE,
       (SELECT H.DISTRICT_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = S.SITE) DISTRICT_CODE,
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
           and r.line_item_no = s.comp_no
           and r.part_no = s.product_code) serial_no,
       IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(s.product_code,
                                             (select r.serial_no
                                                from IFSAPP.CUSTOMER_ORDER_RES_SERIAL_LOV r
                                               where r.order_no = s.order_no
                                                 and r.line_no = s.line_no
                                                 and r.rel_no = s.rel_no
                                                 and r.line_item_no =
                                                     s.comp_no
                                                 and r.part_no =
                                                     s.product_code)) oem_no,*/
       s.sales_quantity,
       s.unit_nsp,
       s.discount "DISCOUNT(%)",
       s.sales_price,
       s.vat,
       s.amount_rsp,
       s.customer_no,
       ifsapp.customer_info_api.Get_Name(s.customer_no) customer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(s.customer_no) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(s.customer_no, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(s.customer_no, 1) customer_address
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.product_code = p.product_code
 where s.sales_price != 0
   and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and s.status not in ('CashConverted', 'PositiveCashConv')
   /*and substr(s.order_no, 4, 2) = '-R'*/
   and p.product_family /*in
       ('COMPUTER-DESKTOP', 'COMPUTER-LAPTOP'\*, 'COMPUTER-ACCESSORIES'*\)*/ = 'TV-PANEL'
   /*and s.product_code \*in ('PTWTP-PUREIT-CLASSIC-BLUE',
                                 'PTWTP-PUREIT-CLASSIC-MARO',
                                'PTWTP-PUREIT-ULTIMA-418',
                                'PTWTP-PUREIT-ULTIMA-MAR-RO-UV',
                                'PTWTP-PUREIT-ULTIMA-RO-UV',
                                'PTWTP-PUREIT-CLASIC-RO-MF')*\
       like 'DLCOM-%'*/ /*'SGTV-%'*/ /*'%REF-%'*/
   /*and p.brand \*in ('Dell', 'Hp')*\ = 'Beko'*/
/*and s.order_no = 'AKH-H3336'*/ /*'AKH-R6747'*/ /*'ABD-H12374'*/ /*'ABD-R16799'*/ /*'DRR-H2228'*/
 order by s.sales_date,
          to_number((SELECT H.DISTRICT_CODE
                      FROM IFSAPP.SHOP_DTS_INFO H
                     WHERE H.SHOP_CODE = S.SITE)),
          s.order_no,
          s.line_no,
          s.rel_no,
          s.comp_no;

/*('DLCOM-INSP-3670DT-I3',
'DLCOM-INSP-3670DT-I5',
'DLCOM-INSP-AIO-3277-I3',
'DLCOM-INSP-3476-I3-BLK',
'DLCOM-INSP-3476-I5-BLK',
'DLCOM-INSP-3567-I3-BLK',
'DLCOM-INSP-3573-PQC-BLK-W',
'DLCOM-INSP-3576-I3-BLK',
'DLCOM-INSP-3576-I3-BLK-W',
'DLCOM-INSP-3576-I3-BLU',
'DLCOM-INSP-3576-I3-FOG',
'DLCOM-INSP-3576-I5-BLK',
'DLCOM-INSP-3576-I5-FOG',
'DLCOM-INSP-3580-I3-BLK-W',
'DLCOM-INSP-3580-I3-SLV-W',
'DLCOM-INSP-3580-I5-BLK-W',
'DLCOM-INSP-3580-I5-SLV-W',
'DLCOM-INSP-3580-I7-G-SL-W',
'DLCOM-INSP-3581-I3-BLK-W',
'DLCOM-INSP-3581-I3-SLV-W',
'DLCOM-INSP-3582-PQC-BLK-W',
'DLCOM-INSP-3582-PQC-SLV-W',
'DLCOM-INSP-5480-I5-RW',
'DLCOM-INSP-5480-I5-SLV',
'DLCOM-INSP-5482-I5-GRY-W',
'DLCOM-INSP-5482-I5-SLV-W',
'DLCOM-INSP-5570-I3-SLV-W',
'DLCOM-INSP-5570-I5-BLK',
'DLCOM-INSP-5570-I5-G-SL-W',
'DLCOM-INSP-5570-I5-GR-BLK',
'DLCOM-INSP-5570-I5-GR-SLV',
'DLCOM-INSP-5570-I5-SLV',
'DLCOM-INSP-5570-I5-SLV-W',
'DLCOM-INSP-5584-I5-G-SL-W',
'DLCOM-INSP-5584-I7-G-SL-W',
'DLCOM-XPS-9365-I5-SLV-W')*/
