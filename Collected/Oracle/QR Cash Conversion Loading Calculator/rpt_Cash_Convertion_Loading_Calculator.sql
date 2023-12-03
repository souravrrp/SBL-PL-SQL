select a.*,
       (a.cc_date + 25) last_date_4_pc_load,
       case
         when a.cc_date < sysdate then
          a.cc_date_balance * 0.04
         else
          0
       end "LOAD_VALUE_4_PC",
       (a.cc_date + 55) last_date_8_pc_load,
       case
         when a.cc_date < sysdate then
          a.cc_date_balance * 0.08
         else
          0
       end "LOAD_VALUE_8_PC",
       (a.cc_date + 85) last_date_12_pc_load,
       case
         when a.cc_date < sysdate then
          a.cc_date_balance * 0.12
         else
          0
       end "LOAD_VALUE_12_PC",
       (a.cc_date + 115) last_date_16_pc_load,
       case
         when a.cc_date < sysdate then
          a.cc_date_balance * 0.16
         else
          0
       end "LOAD_VALUE_16_PC",
       (a.cc_date + 145) last_date_20_pc_load,
       case
         when a.cc_date < sysdate then
          a.cc_date_balance * 0.2
         else
          0
       end "LOAD_VALUE_20_PC",
       (a.cc_date + 175) last_date_24_pc_load,
       case
         when a.cc_date < sysdate then
          a.cc_date_balance * 0.24
         else
          0
       end "LOAD_VALUE_24_PC"
  from (select h.acct_no,
               case
                 when h.acct_no != h.original_acct_no then
                  h.last_variation
                 else
                  h.state
               end state,
               h.bb_no,
               h.actual_sales_date actual_sales_date,
               h.cash_conversion_on_date cc_date,
               to_char(h.hire_cash_price - h.down_payment -
                       nvl((select sum(c.amount) amount
                             from ifsapp.SBL_COLLECTION_INFO c
                            where c.original_acc_no = h.original_acct_no
                              and c.payment_date between h.actual_sales_date and
                                  h.cash_conversion_on_date),
                           0)) cc_date_balance
          from ifsapp.HPNRET_FORM249_ARREARS h
         where h.year = extract(year from(trunc(sysdate, 'mm') - 1))
           and h.period = extract(month from(trunc(sysdate, 'mm') - 1))
           and h.act_out_bal > 0
           and h.acct_no = '&ACCT_NO') a
