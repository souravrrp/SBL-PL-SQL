--Collecting Commission Calculation on the basis of Claim ID 
--ie. One week comm claimed amount which is hit in A/C through on CC Voucher
select c.transaction_id,
       c.trans_item_no,
       c.trans_revision_no,
       c.commission_receiver,
       c.site,
       c.entitlement_type,
       c.commission_type,
       c.commission_sales_type,
       c.collection_type,
       c.invoice_amount,
       c.installment_amount,
       c.comm_calc_amount,
       trunc(c.calculated_date) calculated_date,
       c.order_no,
       --c.account_no,
       c.catalog_no,
       c.quantity,
       --c.invoice_id,
       c.receipt_no,
       c.approved_date,
       c.approved_amount,
       c.approved_user,
       c.claim_id,
       c.rowstate,
       c.invoice_no,
       c.note,
       c.reverse_reason--,
       --c.reversed
       /*sum(c.comm_calc_amount) comm_calc_amount,
       sum(c.approved_amount) approved_amount*/
  from ifsapp.commission_value_detail_tab c
 where c.claim_id = '&claim_id' --199202
       /*c.site = '&site'
       and c.approved_date = to_date('&approved_date', 'YYYY/MM/DD')*/
       --c.receipt_no = '&receipt_no'
