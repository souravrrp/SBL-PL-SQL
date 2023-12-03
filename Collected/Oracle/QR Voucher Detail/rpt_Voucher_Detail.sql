---voucher not posted---

select
v.VOUCHER_TYPE,
v.VOUCHER_NO,
v.VOUCHER_DATE,
v.VOUCHER_TEXT,
v.USERID,
v.APPROVED_BY_USERID,
t.ACCOUNT,
Decode(account, NULL, NULL, SUBSTRB(Text_Field_Translation_API.Get_Text(t.company,
                                          'CODEA', t.account),1,100))
                                                account_desc,
t.CODE_B,
nvl(t.CREDIT_AMOUNT,0) CREDIT_AMOUNT,
nvl(t.DEBET_AMOUNT,0) DEBET_AMOUNT,
t.TEXT


from
IFSAPP. VOUCHER_TAB v,
IFSAPP.voucher_row_tab t
where
v.VOUCHER_NO=t.VOUCHER_NO
and  v.VOUCHER_NO = voucher_no_ 
and v.VOUCHER_TYPE = voucher_type_;


union all


---voucher  posted---

select
v.VOUCHER_TYPE,
v.VOUCHER_NO,
v.VOUCHER_DATE,
v.VOUCHER_TEXT,
v.USERID,
v.APPROVED_BY_USERID,
I.ACCOUNT,
I.ACCOUNT_DESC,
I.CODE_B,
nvl(I.CURRENCY_CREDIT_AMOUNT,0) CREDIT_AMOUNT,
nvl(I.CURRENCY_DEBET_AMOUNT,0) DEBET_AMOUNT,
I.TEXT
from
IFSAPP.GEN_LED_VOUCHER2 V,
IFSAPP.GEN_LED_VOUCHER_ROW_UNION_QRY I
where
v.VOUCHER_NO=I.VOUCHER_NO
and  v.VOUCHER_NO = voucher_no_ 
and v.VOUCHER_TYPE = voucher_type_;
