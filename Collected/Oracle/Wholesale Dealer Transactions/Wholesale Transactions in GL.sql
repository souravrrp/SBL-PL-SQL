--Wholesale Sales in GL
select l.*
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB l
 inner join (select t.invoice_id,
                    t.c10              "SITE",
                    t.c1               ORDER_NO,
                    t.identity,
                    i.voucher_no_ref,
                    i.voucher_type_ref,
                    i.voucher_date_ref,
                    i.c1,
                    i.pay_term_id
               from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
              where t.invoice_id = i.invoice_id
                and t.net_curr_amount > 0
                and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                and t.rowstate = 'Posted'
                and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
                    ('INV', 'PKG')
                and t.identity like '&CustomerID'
              group by t.invoice_id,
                       t.c10,
                       t.c1,
                       t.identity,
                       i.voucher_no_ref,
                       i.voucher_type_ref,
                       i.voucher_date_ref,
                       i.c1,
                       i.pay_term_id) s
    on l.voucher_type = s.voucher_type_ref
   and l.voucher_no = s.voucher_no_ref
   and l.party_type_id = s.identity
 order by 8;

--Wholesale Cash Collections in GL
select l.*, b.payer_identity
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB l
 inner join (select m.payer_identity,
                    p.voucher_type_ref,
                    p.voucher_no_ref,
                    p.voucher_date_ref,
                    p.rowstate
               from ifsapp.mixed_payment_lump_sum_tab m
              inner join ifsapp.MIXED_PAYMENT_TAB p
                 on m.mixed_payment_id = p.mixed_payment_id
              where m.payer_identity like '&CustomerID'
                and p.rowstate != 'Cancelled') b
    on l.voucher_type = b.voucher_type_ref
   and l.voucher_no = b.voucher_no_ref
 order by 8;

--Wholesale Check Collections in GL
select l.*
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB l
 inner join ifsapp.CHECK_LEDGER_ITEM c
    on l.voucher_type = c.voucher_type
   and l.voucher_no = c.voucher_no
   and l.party_type_id = c.identity
 where c.state != 'Cancelled'
   and c.identity like '&CustomerID'
 order by 8;

--Voucher Types & Reference Series Types of Wholesale Dealers in GL 
select t.voucher_type,
       IFSAPP.VOUCHER_TYPE_API.Get_Description('SBL', T.VOUCHER_TYPE) VOUCHER_Description,
       t.reference_serie,
       IFSAPP.INVOICE_SERIES_API.Get_Description('SBL', T.REFERENCE_SERIE) SERIES_Description /*, t.party_type_id,*/
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB t
 where t.party_type_id like 'W000%' /*'W0001671-2'*/
 group by t.voucher_type, t.reference_serie /*, t.party_type_id,*/
 order by /*t.voucher_type,*/ t.reference_serie;

----Voucher Types & Accounts of Wholesale Dealers in GL 
select t.voucher_type,
       IFSAPP.VOUCHER_TYPE_API.Get_Description('SBL', T.VOUCHER_TYPE) VOUCHER_Description,
       t.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', T.ACCOUNT) ACCOUNT_Description, /*,t.party_type_id,*/
       IFSAPP.ACCOUNT_TYPE_API.Get_Description('SBL', IFSAPP.ACCOUNT_API.Get_Accnt_Type('SBL', T.ACCOUNT)) ACCOUNT_Type,
       IFSAPP.ACCOUNT_GROUP_API.Get_Description('SBL', IFSAPP.ACCOUNT_API.Get_Accnt_Group('SBL', T.ACCOUNT)) ACCOUNT_Group,
       IFSAPP.ACCOUNT_API.Get_Logical_Account_Type('SBL', T.ACCOUNT) Logical_ACCOUNT_Type
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB t
 where t.party_type_id like 'W000%' /*'W0001671-2'*/
 group by t.voucher_type, t.account /*,t.party_type_id,*/
 order by t.voucher_type/*, t.account*/;