--***** WS Delivered Product's OEM No
select p.demand_order_no order_no,
       p.demand_release line_no,
       p.demand_sequence_no rel_no,
       s.order_no delivery_order_no,
       s.line_no delivery_line_no,
       s.rel_no delivery_rel_no,
       s.contract delivery_site,
       s.part_no,
       f.product_family,
       f.brand,
       s.serial_no,
       IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(s.part_no, s.serial_no) oem_no,
       /*trunc(s.last_activity_date) delivery_date,*/
       i.invoice_date,
       s.qty_shipped
  from IFSAPP.CUSTOMER_ORDER_RES_SERIAL_LOV s
 inner join IFSAPP.CUSTOMER_ORDER_LINE_TAB l
    on s.order_no = l.order_no
   and s.line_no = l.line_no
   and s.rel_no = l.rel_no
   and s.line_item_no = l.line_item_no
 inner join IFSAPP.PURCHASE_ORDER_LINE_TAB p
    on l.demand_order_ref1 = p.order_no
   and l.demand_order_ref2 = p.line_no
   and l.demand_order_ref3 = p.release_no
 inner join IFSAPP.INVOICE_TAB i
    on p.demand_order_no = i.creators_reference
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO f
    on s.part_no = f.product_code
 where i.invoice_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and p.contract in
       ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SCSM', 'SITM', 'SAPM', 'SHOM')
   and f.product_family in ('COMPUTER-DESKTOP', 'COMPUTER-LAPTOP')
   and s.part_no /*in ('DLCOM-INSP-3670DT-I3',
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
                     'DLCOM-XPS-9365-I5-SLV-W')*/ like 'DLCOM-%'
/*and s.order_no = \*'CLW-R6566'*\ 'SWH-R126545'*/
/*and f.product_family in
('COMPUTER-DESKTOP', 'COMPUTER-LAPTOP', 'COMPUTER-ACCESSORIES')*/
 order by 1, 2, 3
