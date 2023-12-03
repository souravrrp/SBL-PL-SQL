--Revert Details
SELECT distinct 
    vv.area,
    vv.area_id,
    vv.district,
    hp.contract site_code,
    hp.account_no org_acc_no,
    dt.part_no,
    hp.id nic_no, 
    --hp.hp_type,      
    IFSAPP.Customer_Info_Api.Get_Name( hp.id) Cust_Name,
    ifsapp.customer_info_address_api.Get_Address1( hp.id,'1') add_1,
    ifsapp.customer_info_address_api.Get_Address2( hp.id,'1') add_2,'' add_3,
    ifsapp.customer_info_address_api.Get_City( hp.id,'1') city,
    hp.account_no org_acc_no2, 
    ifsapp.hpnret_hp_head_api.Get_Gross_Hire_Value(hp.account_no,hp.account_rev) "Gross Hire",
    ifsapp.hpnret_hp_head_api.get_total_list_price(hp.account_no,1) list_pr,
    hp.length_of_contract term,
    ifsapp.hpnret_hp_head_api.get_total_monthly_payment(hp.account_no,1) mth_pay,
    hp.sales_date sale_date,       
    ifsapp.hpnret_hp_head_api.Get_Total_Out_Bal(hp.account_no,1) out_bal,
    aa.inventory_value cost
FROM 
  ifsapp.hpnret_hp_head_info hp,
  ifsapp.hpnret_hp_dtl_info dt,
  ifsapp.hpnret_hp_line_history hl,
  ifsapp.hpnret_levels_overview vv,
  IFSAPP.INVENTORY_PART_UNIT_COST aa
WHERE 
  hp.account_no = dt.account_no AND 
  dt.line_no = hl.line_no AND 
  dt.supply_code NOT IN ('Pkg') AND 
  hp.account_no = hl.account_no AND 
  dt.account_rev = dt.account_rev AND 
  hp.contract = dt.contract AND 
  hp.contract = hl.contract AND 
  hp.contract LIKE '&Site' AND 
  hl.status IN ('Reverted') and 
  dt.state IN ('Reverted') and 
  --hp.hp_type like '&Hp_type' and 
  vv.area_id like '&Area_id' and 
  hp.contract = vv.site_id and 
  aa.contract = dt.contract and 
  aa.part_no = dt.part_no AND 
  TRUNC(hl.entered_date) BETWEEN TO_DATE('&Rvt_from_date_', 'YYYY/MM/DD') AND TO_DATE('&Rvt_to_date_', 'YYYY/MM/DD')
