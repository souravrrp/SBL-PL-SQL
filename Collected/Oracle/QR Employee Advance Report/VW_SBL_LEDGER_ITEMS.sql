create or replace view sbl_ledger_items as
select
      l.company,
      l.identity,
      SUBSTRB(Supplier_Info_API.Get_Name(l.identity),1,100) emp_name,
      SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) party_type,
      l.code_a Account_Head,
      l.code_b Contact,
      l.ledger_item_series_id,
      i.notes,
      i.invoice_date ledger_date,
      i.voucher_type_ref voucher_type,
      i.voucher_no_ref voucher_no,
      case when (l.full_curr_amount < 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Supplier') or
        (l.full_curr_amount >= 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Customer') then abs(l.full_curr_amount)
          else 0
            end Debit,
      case when (l.full_curr_amount >= 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Supplier') or
        (l.full_curr_amount < 0 and SUBSTRB(Party_Type_API.Decode(l.party_type),1,200) = 'Customer') then abs(l.full_curr_amount)
        else 0
          end Credit
  from
    ledger_item_tab l,
    invoice_Tab i
  where
    l.company = i.company and
    l.invoice_id = i.invoice_id and
    l.identity = i.identity and
    i.rowstate != 'Cancelled' and
    i.invoice_date >= to_date('2015/1/1', 'YYYY/MM/DD');
