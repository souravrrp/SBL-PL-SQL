(
SELECT 
          tt.wo_no,
          tt.objstate Status , 
          tt.reg_date,
    --   tt.real_s_date,
          tt.real_f_date Fininsh_Date,
          tt.contract,
          tt.mch_code_contract Product_site,
          substr(tt.mch_code,1,instr( tt.mch_code,'-',-1,1)-1) PRODUCT_CODE,
          tt.mch_code_description PRODUCT_DESC,
          tt.customer_no,
          ifsapp.customer_info_api.Get_Name(tt.customer_no) Customer_name,
          tt.phone_no,
          tt.address2 Address,
           tt.work_type_id,
          IFSAPP.WORK_TYPE_api.Get_Description(tt.work_type_id) work_type_desc,
          tt.work_leader_sign,
          tt.reported_by
 FROM IFSAPP.ACTIVE_SEPARATE tt
   where tt.wo_no=&wo_no
UNION ALL
SELECT 
           kk.wo_no,
           kk.wo_status_id,
           kk.reg_date,     
       -- kk.real_s_date,
           kk.real_f_date Fininsh_Date,           
     
           kk.CONTRACT,
           kk.mch_code_contract Product_site,
            substr(kk.mch_code,1,instr(kk.mch_code,'-',-1,1)-1) PRODUCT_CODE,
           kk.mch_code_description PRODUCT_DESC,         
           kk.customer_no,
           ifsapp.customer_info_api.Get_Name(kk.customer_no) Customer_name,
           kk.phone_no,
           kk.address2,
           kk.work_type_id,
           IFSAPP.WORK_TYPE_api.Get_Description(kk.work_type_id) work_type_desc   ,
           kk.work_leader_sign,
           kk.reported_by
  FROM IFSAPP.HISTORICAL_SEPARATE kk
   where kk.wo_no=&wo_no
  ) 

 -- where kk.wo_status_id='FINISHED'
 -- order by kk.reg_date desc;
 order by 2 desc
  
