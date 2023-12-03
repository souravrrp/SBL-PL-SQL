create or replace view sbl_vw_prime_cash
as
  select 
      m.CONTRACT SITE_CODE,
      trunc(m.ROWVERSION) APPROVAL_DT, 
      m.ACCOUNT_CODE,
      b.DESCRIPTION NAME, 
      d.AMOUNT 
  from 
    HPNRET_ADV_PAY_DTL_TAB d,
    HPNRET_ADV_PAY_TAB m,
    HPNRET_ADV_BASIC_TAB b
  where 
    m.SERIES_NO=d.SERIES_NO and 
    m.ACCOUNT_CODE=b.ACCOUNT_CODE and 
    m.ACCOUNT_CODE in('FSPAD','PCA-D','FSPAF') and 
    d.STATUS='Approved'
