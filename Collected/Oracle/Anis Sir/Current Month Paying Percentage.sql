--Current Month Paying Percentage
SELECT S.SHOP_CODE,
       S.TOTAL_ACCT,
       NVL(S2.PAYING_ACCT, 0) PAYING_ACCT,
       ROUND((NVL(S2.PAYING_ACCT, 0) / S.TOTAL_ACCT) * 100, 2) PAYING_PERCENTAGE
  FROM (SELECT P.SHOP_CODE, COUNT(P.ORIGINAL_ACCT_NO) TOTAL_ACCT
          FROM IFSAPP.SBL_PAYING_ACC_LIST P
         GROUP BY P.SHOP_CODE) S
  LEFT JOIN (SELECT P2.SHOP_CODE, COUNT(P2.ORIGINAL_ACCT_NO) PAYING_ACCT
               FROM IFSAPP.SBL_PAYING_ACC_LIST P2
              WHERE P2.PAYING_STATUS = 'PAYING'
              GROUP BY P2.SHOP_CODE) S2
    ON S.SHOP_CODE = S2.SHOP_CODE
 WHERE S.SHOP_CODE IN
       (select U.CONTRACT
          from IFSAPP.USER_ALLOWED_SITE U
         where U.USERID = ifsapp.fnd_session_api.Get_Fnd_User)
   AND S.SHOP_CODE LIKE '&SHOP_CODE'
 ORDER BY 1
