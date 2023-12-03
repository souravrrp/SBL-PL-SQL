--Purchase Receive No Part
select R.order_no,
       R.line_no,
       R.release_no,
       R.receipt_no,
       R.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(R.vendor_no) vendor_name,
       R.contract,
       '' brand,
       IFSAPP.PURCHASE_ORDER_LINE_NOPART_API.Get_Stat_Grp(R.order_no,
                                                          R.line_no,
                                                          R.release_no) purch_grp,
       /*IFSAPP.PURCHASE_PART_GROUP_API.Get_Description(IFSAPP.PURCHASE_ORDER_LINE_NOPART_API.Get_Stat_Grp(R.order_no,
                                                                                                         R.line_no,
                                                                                                         R.release_no)) purch_grp_desc,*/
       R.part_no,
       R.description,
       R.qty_arrived,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                         R.line_no,
                                                         R.release_no) Buy_Unit_Price,
       (IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                          R.line_no,
                                                          R.release_no) *
       R.qty_arrived) Total_Price,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Fbuy_Unit_Price(R.order_no,
                                                          R.line_no,
                                                          R.release_no) Fbuy_Unit_Price,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Currency_Rate(R.order_no,
                                                        R.line_no,
                                                        R.release_no) Currency_Rate,
       to_char(R.arrival_date, 'YYYY/MM/DD') arrival_date,
       IFSAPP.PURCHASE_ORDER_API.Get_Lc_No(R.order_no) LC_NO,
       R.grn_no,
       R.shipment_id,
       R.state
  from IFSAPP.PURCHASE_RECEIPT_NEW R
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     R.vendor_no,
                                                     'Supplier') = '0'
   and trunc(R.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and R.state != 'Cancelled'
   /*and substr(R.order_no, 1, 2) like 'L-%'*/ --For Local PO
   and R.part_no is null
   and R.contract = 'SFRF' /*'SACF' 'SAVF'*/
   /*and IFSAPP.PURCHASE_ORDER_LINE_NOPART_API.Get_Stat_Grp(R.order_no,
                                                          R.line_no,
                                                          R.release_no) in
       ('FADHES',
        'FCLOTH',
        'FFOAM',
        'FNAPIN',
        'FOTHER',
        'FPACKM',
        'FREXIN',
        'FWOOD')*/ --Furniture Raw Materials
   /*and substr(R.vendor_no, 1, 5) like 'XLBD-%'
   and R.vendor_no != 'XLBD-IFS'*/
 order by 1, 2, 3, 4
