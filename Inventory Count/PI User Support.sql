--*** Change Site or User
select t.*, t.rowid
  from SBL_USER_LIST t
 WHERE /*t.site = '&shop_code'*/ t.user_id = '&emp_id';

--***** Cancel Approver Comment of a Site
select *
  from IFSAPP.SBL_SHOP_ARRPOVE_TBL a
 where a.shop_code like '&shop_code';

/*
update IFSAPP.SBL_SHOP_ARRPOVE_TBL a
   set a.approve_status = 0
 where a.shop_code like '&shop_code';
commit;

update IFSAPP.SBL_SHOP_ARRPOVE_TBL a
   set a.appr_comment = '', a.comment_date = ''
 where a.shop_code = '&shop_code';
commit;

update IFSAPP.SBL_SHOP_ARRPOVE_TBL a
   set a.appr_comment = 0, a.comment_date = ''
 where a.shop_code in (select a.shop_code
                         from IFSAPP.SBL_SHOP_ARRPOVE_TBL a
                        inner join (select distinct (s.site) s_site
                                     from SBL_PHYSICAL_INVENTORY_STATUS s
                                    where s.qty_short_over != 0
                                      and s.settlement_deadline is null) b
                           on a.shop_code = b.s_site
                        where a.appr_comment = 1);
commit;



delete from IFSAPP.SBL_SHOP_ARRPOVE_TBL a where a.shop_code = '&shop_code';
-- and a.approve_status = 0;
commit;

insert into IFSAPP.SBL_SHOP_ARRPOVE_TBL s
  (shop_code,
   shop_user_id,
   approve_status,
   approve_date,
   audit_user_id,
   mgr_nid)
values
  ('NMPB','KIBRIA1087', 1, to_date('2020/11/2', 'YYYY/MM/DD'), 'E10485', '2690421375817');
commit;
*/


--*****No of shops to be counted in a day
select count(u.site) no_of_shops
  from IFSAPP.SBL_USER_LIST U
 where u.date_of_count = to_date('&COUNT_DATE', 'YYYY/MM/DD')
   AND u.user_id != 'E10206';


--*****User details of a shop
select U.USER_ID,
       IFSAPP.Customer_Info_Api.Get_Name(U.USER_ID) USER_NAME,
       U.SITE,
       U.COUNT_YEAR,
       U.DATE_OF_COUNT,
       U.PASS
  from IFSAPP.SBL_USER_LIST U
 where U.site LIKE '&SHOP_CODE'
 AND U.USER_ID = '&USER_ID';
 
   
--*****Status of a WO
SELECT tt.wo_no,
       tt.objstate,
       TO_CHAR(tt.reg_date, 'MM/DD/YYYY') reg_date,
       TO_CHAR(tt.real_f_date, 'MM/DD/YYYY') real_f_date,
       tt.contract,
       tt.mch_code_contract Product_site,
       substr(tt.mch_code, 1, instr(tt.mch_code, '-', -1, 1) - 1) PRODUCT_CODE,
       tt.mch_code_description PRODUCT_DESC,
       tt.work_type_id,
       IFSAPP.WORK_TYPE_api.Get_Description(tt.work_type_id) work_type_desc,
       tt.work_leader_sign
  FROM IFSAPP.ACTIVE_SEPARATE tt
 where tt.wo_no = '&WO_NO'
   /*and substr(tt.mch_code, 1, instr(tt.mch_code, '-', -1, 1) - 1) like
       '&re_PRODUCT_CODE'
   and tt.mch_code_contract like '&re_SHOP_CODE'*/
UNION ALL
SELECT kk.wo_no,
       kk.wo_status_id,
       TO_CHAR(kk.reg_date, 'MM/DD/YYYY') reg_date,
       TO_CHAR(kk.real_f_date, 'MM/DD/YYYY') real_f_date,
       kk.CONTRACT,
       kk.mch_code_contract Product_site,
       substr(kk.mch_code, 1, instr(kk.mch_code, '-', -1, 1) - 1) PRODUCT_CODE,
       kk.mch_code_description PRODUCT_DESC,
       kk.work_type_id,
       IFSAPP.WORK_TYPE_api.Get_Description(kk.work_type_id) work_type_desc,
       kk.work_leader_sign
  FROM IFSAPP.HISTORICAL_SEPARATE kk
 where kk.wo_no = '&WO_NO'
   /*and substr(kk.mch_code, 1, instr(kk.mch_code, '-', -1, 1) - 1) like
       '&re_PRODUCT_CODE'
   and kk.mch_code_contract like '&re_SHOP_CODE'*/
   ;


--*****Password of a shop
select S.contract, S.USERID, IFSAPP.sbl_pass(USERID) PASS_WORD
  from IFSAPP.USER_ALLOWED_SITE S
 where s.CONTRACT LIKE '&SHOP_CODE'
   and s.USER_SITE_TYPE = 'DefaultSite';


--*****Approval details of a shop
SELECT A.SHOP_CODE,
       A.SHOP_USER_ID,
       A.APPROVE_STATUS,
       A.APPROVE_DATE,
       A.AUDIT_USER_ID,
       IFSAPP.Customer_Info_Api.Get_Name(A.AUDIT_USER_ID) USER_NAME,
       A.COUNT_YEAR
  FROM IFSAPP.SBL_SHOP_ARRPOVE_TBL A
 WHERE A.APPROVE_STATUS = 1
   AND A.SHOP_CODE LIKE '&SHOP_CODE'
   AND TRUNC(A.APPROVE_DATE) = TO_DATE('&APPROVE_DATE', 'YYYY/MM/DD')
 ORDER BY A.APPROVE_DATE /*DESC*/
 ;


--*****No of Shops completed counting in a day
SELECT COUNT(DISTINCT(A.SHOP_CODE)) NO_OF_SHOPS
  FROM IFSAPP.SBL_SHOP_ARRPOVE_TBL A
 WHERE A.APPROVE_STATUS = 1
   AND TRUNC(A.APPROVE_DATE) <= TO_DATE('&COUNT_DATE', 'YYYY/MM/DD');


--*****Counting not completed sites
select U.SITE,
       U.USER_ID,
       IFSAPP.Customer_Info_Api.Get_Name(U.USER_ID) USER_NAME,
       U.COUNT_YEAR,
       U.DATE_OF_COUNT,
       U.PASS
  from IFSAPP.SBL_USER_LIST U
 where U.DATE_OF_COUNT <= TO_DATE('&COUNT_DATE', 'YYYY/MM/DD')
   AND U.USER_ID != 'E10206'
   AND NOT EXISTS (SELECT A.SHOP_CODE
          FROM IFSAPP.SBL_SHOP_ARRPOVE_TBL A
         WHERE A.SHOP_CODE = U.SITE
           AND A.APPROVE_STATUS = 1
         /*AND TRUNC(A.APPROVE_DATE) = TO_DATE('&COUNT_DATE', 'YYYY/MM/DD')*/)
 ORDER BY 1;


--*****Sites where counting not finished on count date
SELECT A.SHOP_CODE,
       U.DATE_OF_COUNT,
       A.APPROVE_DATE,
       A.APPROVE_STATUS,
       A.AUDIT_USER_ID,
       IFSAPP.Customer_Info_Api.Get_Name(A.AUDIT_USER_ID) USER_NAME,
       A.COUNT_YEAR
  FROM IFSAPP.SBL_SHOP_ARRPOVE_TBL A
 INNER JOIN IFSAPP.SBL_USER_LIST U
    ON A.SHOP_CODE = U.SITE
   AND A.AUDIT_USER_ID = U.USER_ID
 WHERE TRUNC(A.APPROVE_DATE) != U.DATE_OF_COUNT
   AND U.DATE_OF_COUNT <= TO_DATE('&COUNT_DATE', 'YYYY/MM/DD');
