--Products received in the shops
select pr.order_no,
       pol.line_no,
       pol.release_no,
       pr.receipt_no,
       pr.grn_no GRN_NO,
       trunc(pr.arrival_date) arrival_date,
       trunc(po.order_date) Order_Date,
       trunc(pol.planned_receipt_date) Planned_Receipt_Date,
       (select c.order_no
          from IFSAPP.CUSTOMER_ORDER_TAB c
         where c.customer_po_no = po.order_no) REF_CO_NO, --Order_Reference_Number
       pol.part_no Product_Code,
       pol.description Product_Description,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             pol.part_no)) product_family,       
       po.vendor_no Origin,
       pol.contract Receiving_Location,
       pol.buy_qty_due Quantity_Ordered,
       pr.qty_arrived Quantity_Received,
       pr.receipt_reference,
       po.rowstate Status       
  from purchase_order_tab      po,
       purchase_order_line_tab pol,
       purchase_receipt_tab    pr
 where po.order_no = pol.order_no
   and pol.order_no = pr.order_no
   and pol.line_no = pr.line_no
   and pol.release_no = pr.release_no
   and trunc(pr.arrival_date) between to_date('&form_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and pr.rowstate != 'Cancelled'
   and pol.contract not in ('BSCP', --Service Sites 
                            'BLSP',
                            'CLSP', --New Service Center
                            'CSCP',
                            'DSCP',
                            'JSCP',
                            'RSCP',
                            'SSCP',
                            'MS1C',
                            'MS2C',
                            'BTSC',
                            'JWSS', --Wholesale Sites
                            'SAOS',
                            'SWSS',
                            'WSMO',
                            'DWWH', --Wholesale Office
                            'SAPM', --Corporate, Employee, & Scrap Sites
                            'SCSM',
                            'SESM',
                            'SHOM',
                            'SISM',
                            'SFSM',
                            'DITF', --Trade Fair
                            'SCOM',
                            'APWH',
                            'BBWH',
                            'BWHW',
                            'CMWH',
                            'CTGW',
                            'KWHW',
                            'MYWH',
                            'RWHW',
                            'SPWH',
                            'SWHW',
                            'SYWH',
                            'TWHW') --Warehouse
 order by pr.arrival_date, po.order_no, pol.line_no, pol.release_no, pol.part_no
