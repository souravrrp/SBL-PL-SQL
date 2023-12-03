select b.dealer_id, b.dealer_name, sum(b.balance_amt) balance_amt
  from (select g.party_type_id dealer_id, --***** Wholesale Dealerwise Balance (Posted Vouchers)
               IFSAPP.CUSTOMER_INFO_API.Get_Name(g.party_type_id) dealer_name,
               /*nvl(sum(g.debet_amount), 0) debit_amount,
               nvl(sum(g.credit_amount), 0) credit_amount,*/
               (nvl(sum(g.debet_amount), 0) - nvl(sum(g.credit_amount), 0)) balance_amt
          from ifsapp.GEN_LED_VOUCHER_ROW_TAB g
         where g.account in ('10070010',
                             '10070020',
                             '10070030',
                             '10070040',
                             '20020012'/*,
                             '20020024'*/)
           and g.voucher_type in ('N', 'F', 'B', 'I', 'U', 'G', 'K', 'CB')
           and g.reference_serie in (/*'SDDLRS',*/
                                     'CD',
                                     'CR',
                                     'WSADV',
                                     'SI',
                                     'CF',
                                     'CI',
                                     'EX',
                                     'TRADV',
                                     'WSADVRF',
                                     'CUPOA')
           and g.voucher_date <= to_date('&As_On_Date', 'YYYY/MM/DD')
           and g.party_type_id like '&dealer_id' /*'W000%'*/ /*in ('W0001434-2', 'W0001548-2', 'W0001641-2', 'W0001671-2')*/ 
         group by g.party_type_id

        union
        
        --***** Wholesale Dealerwise Balance (Non Posted Vouchers)
        select v.party_type_id dealer_id,
               IFSAPP.CUSTOMER_INFO_API.Get_Name(v.party_type_id) dealer_name,
               /*nvl(sum(v.debet_amount), 0) debit_amount,
               nvl(sum(v.credit_amount), 0) credit_amount,*/
               (nvl(sum(v.debet_amount), 0) - nvl(sum(v.credit_amount), 0)) balance_amt
          from ifsapp.VOUCHER_ROW_TAB v
         where v.account in ('10070010',
                             '10070020',
                             '10070030',
                             '10070040',
                             '20020012'/*,
                             '20020024'*/)
           and v.voucher_type in ('N', 'F', 'B', 'I', 'U', 'G', 'K', 'CB')
           and v.reference_serie in (/*'SDDLRS',*/
                                     'CD',
                                     'CR',
                                     'WSADV',
                                     'SI',
                                     'CF',
                                     'CI',
                                     'EX',
                                     'TRADV',
                                     'WSADVRF',
                                     'CUPOA')
           and v.voucher_date <= to_date('&As_On_Date', 'YYYY/MM/DD')
           and v.party_type_id like '&dealer_id' /*'W000%'*/ /*in ('W0001434-2', 'W0001548-2', 'W0001641-2', 'W0001671-2')*/
         group by v.party_type_id) b
         where b.dealer_id = 'IT000001-1'
 group by b.dealer_id, b.dealer_name
 order by 1;
