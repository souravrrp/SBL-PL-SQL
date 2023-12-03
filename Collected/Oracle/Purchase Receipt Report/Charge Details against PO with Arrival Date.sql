--Purchase Charge Details with Arrival Date
select p.arrival_date,
       IFSAPP.PURCHASE_ORDER_API.Get_Lc_No(g.order_no) LC_NO,
       g.*
  from (select R.order_no, max(trunc(r.arrival_date)) arrival_date
          from IFSAPP.PURCHASE_RECEIPT_NEW R
         where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                             R.vendor_no,
                                                             'Supplier') = '0'
           and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM',
                                                                 R.part_no) !=
               'RBOOK'
              /*and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                  R.part_no) !=
                  'RAW'
              and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM',
                                                                 R.part_no) not like
                  'S-%'*/
           and trunc(R.arrival_date) between
               to_date('&from_date', 'YYYY/MM/DD') and
               to_date('&to_date', 'YYYY/MM/DD')
           and R.state != 'Cancelled'
           and R.vendor_no not in
               ('XLBD-SACF', 'XLBD-SRAV', 'XLBD-SRFR', 'XLBD-IAL')
         group by r.order_no) p
 inner join (select c.order_no,
                    c.sequence_no,
                    c.shipment_id,
                    c.contract,
                    c.charge_type,
                    c.description,
                    IFSAPP.PURCHASE_CHARGE_TYPE_API.Get_Charge_Group(c.contract,
                                                                     c.charge_type) charge_group,
                    c.charge_by_supplier,
                    IFSAPP.SUPPLIER_INFO_API.Get_Name(c.charge_by_supplier) charge_supplier,
                    c.creation_method,
                    c.fcharge_amount,
                    c.currency_rate,
                    c.charge_amount
               from IFSAPP.PURCHASE_ORDER_CHARGE c
              /*where IFSAPP.PURCHASE_CHARGE_TYPE_API.Get_Charge_Group(c.contract,
                                                                     c.charge_type) =
                    'CUSTOM'*/) g
    on p.order_no = g.order_no
/*where p.order_no = 'F-216132'*/
 order by 1, 2, 3