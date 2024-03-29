--Data Load for ECC Forward Aging
INSERT INTO SBL_ECC_FORWARD_AGING
  (YEAR,
   PERIOD,
   SHOP_CODE,
   ACCT_NO,
   MONTHLY_PAY,
   ACT_OUT_BAL,
   EFFECTIVE_RATE,
   PRESENT_VALUE,
   ACTUAL_UCC)
  SELECT H.YEAR,
         H.PERIOD,
         H.SHOP_CODE,
         H.ACCT_NO,
         H.MONTHLY_PAY,
         H.ACT_OUT_BAL,
         H.EFFECTIVE_RATE,
         H.PRESENT_VALUE,
         H.ACTUAL_UCC
    FROM HPNRET_FORM249_ARREARS_TAB H
   WHERE H.YEAR = '&YEAR_I'
     AND H.PERIOD = '&PERIOD'
     AND H.ACT_OUT_BAL > 0;
COMMIT;

--*****Transfer Data of Forward Aging
begin
  ifsapp.SET_SBL_ECC_FORWARD_AGING(&year, &period);
end;
