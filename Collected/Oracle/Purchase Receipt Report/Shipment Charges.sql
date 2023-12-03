--***** Shipment Charges
select c.shipment_id,
       d.order_no,
       IFSAPP.PURCHASE_ORDER_API.Get_Lc_No(d.order_no) LC_NO,
       /*c.contract,*/
       d.arrival_date,
       trunc(s.shipment_date) shipment_date,
       s.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(s.vendor_no) vendor_name,
       c.charge_group,
       IFSAPP.PURCHASE_CHARGE_GROUP_API.Get_Description(c.charge_group) GRP_DESC,
       c.charge_type,
       IFSAPP.PURCHASE_CHARGE_TYPE_API.Get_Description(c.contract,
                                                       c.charge_type) type_desc,
       c.charge_by_supplier,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(c.charge_by_supplier) charge_supplier,
       /*s.total_quantity,*/
       c.charge_price_curr charge_amt,
       /*c.currency_code,
       c.curr_rate,*/
       s.bl_no,
       s.bl_date,
       s.cinv_no,
       s.cinv_date,
       s.note file_no,
       s.state
  from IFSAPP.PURINV_CHARGE_ENTRY c
 inner join IFSAPP.PURINV_SHIPMENTS s
    on c.shipment_id = s.shipment_id
 inner join (select r.shipment_id,
                    r.order_no,
                    trunc(r.arrival_date) arrival_date
               from IFSAPP.PURCHASE_RECEIPT_NEW r
              where r.shipment_id is not null
                and trunc(r.arrival_date) between
                    to_date('&from_date', 'YYYY/MM/DD') and
                    to_date('&to_date', 'YYYY/MM/DD')
              group by r.shipment_id, r.order_no, trunc(r.arrival_date)) d
    on c.shipment_id = d.shipment_id
   and s.shipment_id = d.shipment_id
 where s.state != 'Cancelled' /*'PartiallyReceived'*/ /*'Confirmed'*/ /*'Authorized'*/ /*'Planned'*/
   and trunc(s.shipment_date) between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   /*and c.shipment_id = 2233*/
   /*and c.charge_group = 'FW_AGENT'*/
   /*and c.charge_type = 'FREIGHT'*/
 order by c.shipment_id, c.charge_group, c.charge_type