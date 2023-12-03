PROCEDURE Process_Data (
   stat_year_ IN NUMBER,
   stat_period_no_ IN NUMBER,
    contract_   IN VARCHAR2 DEFAULT NULL )
IS
   branch_           VARCHAR2(5);
   site_type_        NUMBER;
   ad_               VARCHAR2(1);
   start_date_       VARCHAR2(10);
   end_date_         VARCHAR2(10);
   bf_balance_       NUMBER := 0;
   adj_dr_           NUMBER;
   adj_cr_           NUMBER;
   debit_note_       NUMBER;
   exch_in_cash_     NUMBER;
   exch_in_hire_     NUMBER;
   revert_qty_       NUMBER;
   sale_reverse_     NUMBER;
   trf_in_           NUMBER;
   trfc_in_          NUMBER;
   dir_debits_       NUMBER;
   other_rec_        NUMBER;
   credit_note_      NUMBER;
   exch_out_cash_    NUMBER := 0;
   exch_out_hire_    NUMBER := 0;
   trf_out_          NUMBER;
   trfc_out_         NUMBER;
   other_iss_        NUMBER;
   revert_rev_       NUMBER;
   sales_            NUMBER := 0;
   ad_sales_         NUMBER := 0;
   cf_balance_       NUMBER := 0;
   revert_bal_       NUMBER := 0;
   school_stock_     NUMBER := 0;
   ad_stock_         NUMBER := 0;
   acc_qty_          NUMBER := 0;
   trans_qty_        NUMBER := 0;
   order_qty_        NUMBER := 0;
   sch_sew_qty_      NUMBER := 0;
   sch_cs_qty_       NUMBER := 0;
   oereturns_        NUMBER := 0;
   last_stat_year_   NUMBER;
   last_stat_no_     NUMBER;
   dummy_            NUMBER;
   trans_exist_      VARCHAR2(5) := 'FALSE';

   newrec_           REP246_TAB%ROWTYPE;
   objid1_           VARCHAR2(2000);
   objversion1_      VARCHAR2(2000);
   attr1_            VARCHAR2(5000);
   transfer_out_qty_ NUMBER;
   transfer_in_qty_  NUMBER;
   dir_del_          NUMBER;
   del_to_tran_      NUMBER;
   rec_from_tran_    NUMBER;
   ipd_sales_        NUMBER := 0;
   con_              NUMBER:=0;
   --(+) 170420 SANPLK (START)
   mr_ret_           NUMBER:=0;
   mr_iss_           NUMBER:=0;
   mrn_iss_          NUMBER:=0;
   --(+) 170420 SANPLK (END)
--(+) 130321 SANPLK G1240973 (START)
   other_crn_        NUMBER:=0;
   arrival_          NUMBER:=0;
   invscrap_         NUMBER;
   countin_          NUMBER;
   countout_         NUMBER;
   assembly_return_  NUMBER;
--(+) 130321 SANPLK G1240973 (END)

   CURSOR fetch_sites IS
      SELECT contract
      FROM   site_tab
      WHERE  company = Site_API.Get_Company(User_Default_API.Get_Contract)
      AND ((1=con_) OR (contract = contract_));

--(+) 130321 SANPLK G1240973 (START)
   /*CURSOR fetch_parts (contract_ IN VARCHAR2) IS
      SELECT part_no, contract
      FROM   inventory_part_tab
      WHERE  nvl(accounting_group,'TEST') != 'BOOKS'
      AND    contract = contract_
      ORDER BY accounting_group, part_product_family, part_no;*/
   CURSOR fetch_parts (contract_ IN VARCHAR2) IS
     SELECT DISTINCT i.accounting_group, i.part_product_family, i.part_no
     FROM   inventory_part i
     WHERE i.contract = contract_
     --AND i.accounting_group != 'BOOKS'
     AND nvl(i.accounting_group,'TEST') != 'BOOKS'
     AND EXISTS
     (
     SELECT 1
     FROM inventory_transaction_hist h
     WHERE  i.part_no = h.part_no
     AND    i.contract = h.contract
     AND    h.direction IN ('-', '+')
     )
     ORDER BY i.accounting_group, i.part_product_family, i.part_no;
--(+) 130321 SANPLK G1240973 (END)

   CURSOR fetch_branch (contract_ IN VARCHAR2) IS
      SELECT site_id
      FROM hpnret_level_hierarchy_tab x
      WHERE x.level_id IN ( SELECT  Hpnret_Level_h_Util_Api.Get_Percent_Higher_Level(t.level_id)
                     FROM hpnret_level_hierarchy_tab t,
                          Hpnret_Level_tab b
                     WHERE t.site_id = contract_
                     AND  b.level_id = Hpnret_Level_h_Util_Api.Get_Level_By_Site(t.site_id)
                     AND  b.level_type = 8
                     AND  Hpnret_Level_Api.Get_Level_Type_Num(Hpnret_Level_h_Util_Api.Get_Percent_Higher_Level(t.level_id))= 7);

   CURSOR get_site_type (contract_ IN VARCHAR2) IS
      SELECT hpnret_level_api.Get_Level_Type_Num(t.level_id)
      FROM hpnret_level_hierarchy_tab t
      WHERE t.site_id = contract_;

   CURSOR qty_onhand_by_date (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, date_applied_ IN VARCHAR2) IS
      SELECT nvl(sum(to_number(direction||to_char(quantity))),0)
      FROM   inventory_transaction_hist_tab
      WHERE  part_no   = part_no_
      --AND    configuration_id = '*'
      AND    contract  = contract_
      AND    direction IN ('-', '+')
      AND   (trunc(date_applied) < to_Date(date_applied_, 'DD/MM/YYYY'));

--(+) 130321 SANPLK G1240973 (START)
   CURSOR qty_onhand_by_date_location (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, date_applied_ IN VARCHAR2, location_no_ IN VARCHAR2) IS
      SELECT nvl(sum(to_number(direction||to_char(quantity))),0)
      FROM   inventory_transaction_hist
      WHERE  part_no   = part_no_
      AND    contract  = contract_
      AND    location_no = location_no_
      AND    direction IN ('-', '+')
      AND   (trunc(date_applied) < to_Date(date_applied_, 'DD/MM/YYYY'));
--(+) 130321 SANPLK G1240973 (END)
   CURSOR get_cf_balance (stat_year_ IN NUMBER, stat_period_no_ IN NUMBER, contract_ IN VARCHAR2, part_no_ IN VARCHAR2) IS
      SELECT cf_balance
      FROM   rep246_tab
      WHERE  stat_year = stat_year_
      AND    stat_period_no = stat_period_no_
      AND    contract = contract_
      AND    part_no = part_no_;

   CURSOR get_qty_by_transaction_code (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2, tran_code_ IN VARCHAR2) IS
      SELECT TRIM(substr(RPAD(source,20,'A'),14,4)) source, nvl(quantity,0) quantity
      FROM   inventory_transaction_hist_tab
      WHERE  direction IN ('-', '+')
      --AND    configuration_id = '*'
      AND    part_no   = part_no_
      AND    transaction_code = tran_code_
      AND    contract  = contract_
      AND   (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));

   CURSOR qty_by_trans_code (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2, tran_code_ IN VARCHAR2) IS
      SELECT nvl(sum(quantity),0)
      FROM   inventory_transaction_hist_tab
      WHERE  direction IN ('-', '+')
      --AND    configuration_id = '*'
      AND    part_no   = part_no_
      AND    transaction_code = tran_code_
      AND    contract  = contract_
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));

--(+) 130321 SANPLK G1240973 (START)

   CURSOR qty_by_trans_code2 (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
     SELECT nvl(sum(quantity),0)
     FROM   inventory_transaction_hist
     WHERE  direction IN ('-', '+')
     AND    part_no   = part_no_
     AND    transaction_code IN ('ARRIVAL','RETCORCRE','RETCORWORK')
     AND    contract  = contract_
     AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));

--(+) 130321 SANPLK G1240973 (END)
  CURSOR get_exch_in_cash (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT COUNT(1) exch_in
      FROM   Customer_Order_Line col, hpnret_exchanges_tab e
      WHERE  e.order_no = col.order_no
      AND    e.line_no = col.line_no
      AND    e.rel_no = col.rel_no
      AND    e.line_item_no = col.line_item_no
      AND    customer_order_line_api.get_real_ship_date(e.new_order_no,e.new_line_no,e.new_rel_no,e.new_line_item_no) BETWEEN to_date(from_date_,'DD/MM/YYYY') AND to_date(to_date_,'DD/MM/YYYY')
      AND    col.part_no = part_no_
      AND    col.contract = contract_;

   CURSOR get_exch_in_hire_qty (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT SUM(dtl.quantity)
      FROM   hpnret_hp_dtl_tab dtl
      WHERE  dtl.part_no = part_no_
      AND    TRUNC(dtl.variated_date) BETWEEN  to_date(from_date_,'DD/MM/YYYY') AND to_date(to_date_,'DD/MM/YYYY')
      AND    dtl.Rowstate = 'ExchangedIn'
      AND    dtl.contract = contract_;
   --(-/+) 151117 SANPLK (START)
   /*CURSOR get_revert_qty (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT SUM(nvl(dtl.reverted_qty,0))
      FROM   hpnret_hp_dtl_tab dtl
      WHERE  dtl.reverted_date IS NOT NULL  --dtl.Rowstate IN ('Reverted','RevertReversed')
      AND    dtl.part_no = part_no_
      AND    dtl.contract = contract_
      AND    TRUNC(dtl.reverted_date) BETWEEN to_date(from_date_,'DD/MM/YYYY') AND to_date(to_date_,'DD/MM/YYYY');*/
   CURSOR get_revert_qty (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS   
      SELECT SUM(nvl(dtl.reverted_qty,0))
      FROM   hpnret_hp_dtl_tab dtl,inventory_transaction_hist_tab ith
      WHERE  ith.part_no  = dtl.part_no
      AND    ith.contract = dtl.contract      
      AND    dtl.part_no = part_no_
      AND    dtl.contract = contract_
      AND    transaction_code = 'OERETURN'
      AND    dtl.reverted_date IS NOT NULL 
      AND    TRUNC(ith.date_applied) BETWEEN to_date(from_date_,'DD/MM/YYYY') AND to_date(to_date_,'DD/MM/YYYY');
      
   --(-/+) 151117 SANPLK (END)   
   CURSOR get_sale_reverse (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT SUM(nvl(rml.qty_to_return,0))
      FROM   hpnret_sales_ret_line_tab sr, return_material_line_tab rml
      WHERE  sr.sales_return_no = rml.rma_no
      AND    sr.sales_ret_dtl_no = rml.rma_line_no
      AND    Sales_Part_API.Get_Part_No(rml.contract, rml.catalog_no) = part_no_
      AND    rml.rowstate = 'ReturnCompleted'
      AND    TRUNC(rml.date_returned) BETWEEN to_date(from_date_,'DD/MM/YYYY') AND to_date(to_date_,'DD/MM/YYYY')
      AND    rml.contract = contract_;

   CURSOR get_revert_reversed_qty (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT SUM(nvl(dtl.reverted_qty,0))
      FROM   hpnret_hp_dtl_tab dtl
      WHERE  dtl.Rowstate = 'RevertReversed'
      AND    TRUNC(dtl.variated_date) BETWEEN to_date(from_date_,'DD/MM/YYYY') AND to_date(to_date_,'DD/MM/YYYY')
      AND    dtl.part_no = part_no_
      AND    dtl.contract = contract_;

   CURSOR get_exch_acc_info (contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT DISTINCT h.account_no, SUBSTR(h.previous_account,INSTR(h.previous_account,';',-1,1)+1,2000) previous_acc
      FROM   hpnret_hp_head_tab h, customer_order_line_tab col
      WHERE  h.account_no = col.order_no
      AND    col.rowstate IN ('Invoiced','Delivered','PartiallyDelivered')
      AND    TRUNC(col.real_ship_date) BETWEEN to_Date(from_date_, 'DD/MM/YYYY') AND to_Date(to_date_, 'DD/MM/YYYY')
      AND    col.contract = contract_
      AND    h.exchange_out = 1;

   CURSOR get_part_qty_in_acc (part_no_ IN VARCHAR2, acc_no_ IN VARCHAR2) IS
      SELECT SUM(nvl(dtl.quantity,0))
      FROM   hpnret_hp_dtl_tab dtl
      WHERE  dtl.rowstate NOT IN ('Planned','Reserved','Released')
      AND    dtl.part_no = part_no_
      AND    dtl.account_no = acc_no_;

   CURSOR get_transfered_qty (part_no_ IN VARCHAR2, acc_no_ IN VARCHAR2) IS
      SELECT SUM(nvl(dtl.quantity,0))
      FROM   hpnret_hp_dtl_tab dtl
      WHERE  dtl.part_no = part_no_
      AND    dtl.rowstate != 'ExchangedIn'
      AND    dtl.account_no = acc_no_;

   CURSOR get_cash_exch_out_orders (contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT DISTINCT e.new_order_no
      FROM   hpnret_exchanges_tab e, customer_order_line_tab col
      WHERE  col.order_no = e.new_order_no
      AND    col.line_no = e.new_line_no
      AND    col.rel_no = e.new_rel_no
      AND    col.line_item_no = e.line_item_no
      AND    col.rowstate in ('Invoiced','Delivered','PartiallyDelivered')
      AND    col.real_ship_date <= to_date(to_date_,'DD/MM/YYYY')
      AND    col.real_ship_date >= to_date(from_date_,'DD/MM/YYYY')
      AND    e.contract = contract_;

   CURSOR get_order_qty (order_no_ IN VARCHAR2, part_no_ IN VARCHAR2) IS
      SELECT SUM(nvl(col.buy_qty_due,0))
      FROM   Customer_Order_Line_Tab col
      WHERE  col.part_no = part_no_
      AND    col.order_no = order_no_;

   CURSOR check_inv_trans_exist (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT 1
      FROM  inventory_transaction_hist_tab
      WHERE part_no   = part_no_
      AND   contract  = contract_
      AND   (trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'))
      AND   (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY'));

   CURSOR get_transfer_out_qty (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT SUM(d.quantity) quantity
      FROM   Hpnret_Hp_Dtl_Tab d, hpnret_hp_head_tab h
      WHERE  d.reference_hp = h.account_no
      AND    d.contract = contract_
      AND    d.catalog_no = part_no_
      AND    h.transferred_account = 1  --d.rowstate = 'TransferAccount'
      AND    d.ref_line_item_no >= 0
      AND   (trunc(h.sales_date) <= to_Date(to_date_, 'DD/MM/YYYY'))
      AND   (trunc(h.sales_date) >= to_Date(from_date_, 'DD/MM/YYYY'));

   CURSOR get_transfer_in_qty (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT SUM(col.qty_shipped) quantity
      FROM   hpnret_hp_head_tab h, Customer_order_line_tab col
      WHERE  h.account_no = col.order_no
      AND    col.catalog_no = part_no_
      AND    h.transferred_account = 1
      AND    col.line_item_no >= 0
      AND   (trunc(col.real_ship_date) <= to_Date(to_date_, 'DD/MM/YYYY'))
      AND   (trunc(col.real_ship_date) >= to_Date(from_date_, 'DD/MM/YYYY'))
      AND    col.contract = contract_;

   CURSOR get_direct_deliveries (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT nvl(ith.quantity,0) qty, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(col.supply_site)) BM_AD1, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(ith.contract)) BM_AD2,Site_API.Get_Site_Type(col.supply_site) From_Site_Type
      FROM   inventory_transaction_hist_tab ith, customer_order_line_tab col
      WHERE  ith.order_no = col.order_no
      AND    ith.release_no = col.line_no
      AND    ith.sequence_no = col.rel_no
      AND    ith.line_item_no = col.line_item_no
      AND    direction = '0'
      AND    ith.part_no   = part_no_
      AND    transaction_code = 'INTPODIRSH'
      AND    ith.contract  = contract_
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));

   --(+)  130218  Krsalk   C_G1228842(Start)
   CURSOR get_po_receives (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT nvl(ith.quantity,0) qty, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(purchase_order_api.get_vendor_no(ith.order_no))) BM_AD1, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(ith.contract)) BM_AD2,Site_API.Get_Site_Type(Purchase_Order_API.Get_Vendor_No(ith.order_no)) From_Site_Type
      FROM   inventory_transaction_hist_tab ith
      WHERE    direction IN ('-', '+')
      AND    ith.part_no   = part_no_
      --(+) 130321 SANPLK G1240973 (START)
      --AND    transaction_code = 'ARRTRAN'
      AND    transaction_code IN ( 'ARRTRAN','RETCORWINT')
      --(+) 130321 SANPLK G1240973 (END)
      AND    ith.contract  = contract_
      AND (order_no ,release_no,sequence_no,line_item_no) NOT IN (SELECT  order_no,
                                                                           line_no,
                                                                           release_no,
                                                                           receipt_no
                                                                  FROM return_from_transit_tab
                                                                  WHERE  order_no=ith.order_no
                                                                  AND  line_no = ith.release_no
                                                                  AND  release_no = ith.sequence_no
                                                                  AND  receipt_no = ith.line_item_no)
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));
    --(+)  130218  Krsalk   C_G1228842(End)

   CURSOR get_126B_out_for_multi_site (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT nvl(ith.quantity,0) qty, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(purchase_order_api.get_contract(co.customer_po_no))) BM_AD1, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(ith.contract)) BM_AD2 ,Site_API.Get_Site_Type(purchase_order_api.get_contract(co.customer_po_no)) accepting_site
      FROM   inventory_transaction_hist_tab ith, customer_order_tab co
      WHERE  ith.order_no = co.order_no
      AND    direction IN ('-', '+')
      AND    part_no   = part_no_
      AND    transaction_code IN ('SHIPDIR', 'SHIPTRAN')
      AND    ith.contract  = contract_
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));

   CURSOR get_revt_location (contract_ IN VARCHAR2) IS
      SELECT location_no
      FROM INVENTORY_LOCATION_TAB
      WHERE contract = contract_
      AND   location_group = 'REVT';
  --(+) 130321 SANPLK G1240973 (START)
  CURSOR get_dir_ret_from_transit (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT t.quantity, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(Return_Material_API.Get_Customer_No(t.order_no))) customer_type, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(t.contract)) site_type
      FROM   inventory_transaction_hist t
      WHERE  direction IN ('-', '+')
      AND    part_no   = part_no_
      AND    transaction_code = 'OERET-INT'
      AND    contract  = contract_
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'))
         UNION ALL
      SELECT t.quantity, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(R.customer_id)) customer_type, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(t.contract)) site_type
      FROM   inventory_transaction_hist t,return_from_transit r
      WHERE  direction IN ('-', '+')
      AND    part_no   = part_no_
      AND    transaction_code = 'INVM-COIN'
      AND    t.contract  = contract_
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'))
      AND    substr(t.source,16,100) =r.transport_task_id ;
   CURSOR get_other_crn (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT nvl(sum(quantity),0)
      FROM   inventory_transaction_hist
      WHERE  direction IN ('-', '+')
      AND    part_no   = part_no_
      AND    transaction_code IN ('RETWORK','RETWORKINT','RETCREDIT','UNRCPT-')
      AND    contract  = contract_
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));

   CURSOR get_po_receipt_cancel (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT nvl(ith.quantity,0) qty, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(purchase_order_api.get_vendor_no(ith.order_no))) BM_AD1, hpnret_level_api.Get_Level_Type_Num(hpnret_level_h_util_api.get_level_by_site(ith.contract)) BM_AD2, Site_API.Get_Site_Type(Purchase_Order_API.Get_Vendor_No(ith.order_no)) From_Site_Type
      FROM   inventory_transaction_hist ith
      WHERE    direction IN ('-', '+')
      AND    ith.part_no   = part_no_
      AND    transaction_code = 'UNRC-ARRTR'
      AND    ith.contract  = contract_
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));
   trade_in_qty_ NUMBER:=0;
   CURSOR get_invscrap_countout_purship (part_no_ IN VARCHAR2, contract_ IN VARCHAR2, from_date_ IN VARCHAR2, to_date_ IN VARCHAR2) IS
      SELECT nvl(sum(quantity),0)
      FROM   inventory_transaction_hist
      WHERE  direction IN ('-', '+')
      AND    part_no   = part_no_
      AND    transaction_code IN ('INVSCRAP','COUNT-OUT','PURSHIP')
      AND    contract  = contract_
      AND    (trunc(date_applied) >= to_Date(from_date_, 'DD/MM/YYYY') AND trunc(date_applied) <= to_Date(to_date_, 'DD/MM/YYYY'));

   temp_             NUMBER;
   --(+) 130321 SANPLK G1240973 (END)
BEGIN
   General_SYS.Init_Method(lu_name_, 'REP246_API', 'Process_Data');

   start_date_ := '01/'||TO_CHAR(stat_period_no_)||'/'||TO_CHAR(stat_year_);
   end_date_ := To_Char(last_day(to_date(start_date_,'DD/MM/YYYY')),'DD')||'/'||TO_CHAR(stat_period_no_)||'/'||TO_CHAR(stat_year_);

   IF stat_period_no_ = 1 THEN
      last_stat_year_ := stat_year_ - 1;
      last_stat_no_ := 12;
   ELSE
      last_stat_year_ := stat_year_;
      last_stat_no_ := stat_period_no_ - 1;
   END IF;

   IF ((contract_ IS NULL ) OR (contract_ = '%')) THEN
       con_ :=1;
   END IF;
   FOR site_rec_ IN fetch_sites LOOP
      branch_ := '';
      OPEN fetch_branch(site_rec_.contract);
      FETCH fetch_branch INTO branch_;
      CLOSE fetch_branch;

      OPEN get_site_type(site_rec_.contract);
      FETCH get_site_type INTO site_type_;
      CLOSE get_site_type;

      IF site_type_ = 7 THEN
         branch_ := site_rec_.contract;
         ad_ := 'N';
      ELSIF site_type_ = 8 THEN
         ad_ := 'Y';
      ELSE
         ad_ := 'N';
      END IF;
      IF branch_ IS NULL THEN
         branch_ := site_rec_.contract;
      END IF;

      FOR part_rec_ IN fetch_parts(site_rec_.contract) LOOP
         --bf_balance_
         --IF Check_Exist___(last_stat_year_, last_stat_no_, site_rec_.contract, part_rec_.part_no) THEN
        --    OPEN get_cf_balance(last_stat_year_, last_stat_no_, site_rec_.contract, part_rec_.part_no);
        --    FETCH get_cf_balance INTO bf_balance_;
        --    CLOSE get_cf_balance;
        -- ELSE
            OPEN qty_onhand_by_date(part_rec_.part_no, site_rec_.contract, start_date_);
            FETCH qty_onhand_by_date INTO bf_balance_;
            CLOSE qty_onhand_by_date;
       --  END IF;
         bf_balance_ := nvl(bf_balance_,0);

         trans_exist_ := 'FALSE';
         OPEN check_inv_trans_exist(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
         FETCH check_inv_trans_exist INTO dummy_;
         IF (check_inv_trans_exist%FOUND) THEN
            trans_exist_ := 'TRUE';
         END IF;
         CLOSE check_inv_trans_exist;

         exch_out_cash_ := 0;
         exch_out_hire_ := 0;

         adj_dr_ := 0;
         adj_cr_ := 0;
         debit_note_ := 0;
         trf_in_ := 0;
         trfc_in_ := 0;
         dir_debits_ := 0;
         other_rec_ := 0;
         credit_note_ := 0;
         trf_out_ := 0;
         trfc_out_ := 0;
         other_iss_ := 0;

         exch_in_cash_ := 0;
         exch_in_hire_ := 0;
         revert_qty_ := 0;
         sale_reverse_ := 0;
         revert_rev_ := 0;
         sales_ := 0;
         oereturns_ := 0;
         ipd_sales_ := 0;
         
         --(+) 170420 SANPLK (START)
         mr_ret_  := 0;
         mr_iss_  := 0;
         mrn_iss_ :=0;
         --(+) 170420 SANPLK (END)
         
         IF trans_exist_ = 'TRUE' THEN
            FOR rec_ IN get_qty_by_transaction_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'NREC') LOOP
               --adj_dr_
               IF rec_.source = 'AJDB' THEN
                  adj_dr_ := adj_dr_ + rec_.quantity;
               --debit_note_
               ELSIF (rec_.source IN ('DBN', 'DBNP', 'DBNR', 'DBNS')) THEN
                  debit_note_ := debit_note_ + rec_.quantity;
               --trf_in_
               ELSIF rec_.source = '126B' THEN
                  trf_in_ := trf_in_ + rec_.quantity;
               --trfc_in_
               ELSIF rec_.source = '126C' THEN
                  trfc_in_ := trfc_in_ + rec_.quantity;
               --dir_debits_
               ELSIF rec_.source = 'DDBN' THEN
                  dir_debits_ := dir_debits_ + rec_.quantity;
               --other_rec_
               ELSE
                  other_rec_ := other_rec_ + rec_.quantity;
               END IF;
            END LOOP;
            FOR rec_ IN get_qty_by_transaction_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'NISS') LOOP
               --adj_cr_
               IF rec_.source = 'AJCR' THEN
                  adj_cr_ := adj_cr_ + rec_.quantity;
               --credit_note_
               --(+) 130321 SANPLK G1240973 (START)
               --ELSIF (rec_.source IN ('CRN', 'CRNP', 'CRNR', 'CRNS')) THEN
               ELSIF (rec_.source IN ('CRN', 'CRNP', 'CRNR', 'CRNS', '406R')) THEN
               --(+) 130321 SANPLK G1240973 (END)
                  credit_note_ := credit_note_ + rec_.quantity;
               --trf_out_
               ELSIF rec_.source = '126B' THEN
                  trf_out_ := trf_out_ + rec_.quantity;
               --trfc_out_
               ELSIF rec_.source = '126C' THEN
                  trfc_out_ := trfc_out_ + rec_.quantity;
               --other_iss_
               ELSE
                  other_iss_ := other_iss_ + rec_.quantity;
               END IF;
            END LOOP;

            --(+) 130321 SANPLK G1240973 (START)
            OPEN get_invscrap_countout_purship(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_invscrap_countout_purship INTO temp_;
            CLOSE get_invscrap_countout_purship;
            adj_cr_ := adj_cr_ + nvl(temp_,0);

            OPEN qty_by_trans_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'COUNT-IN');
            FETCH qty_by_trans_code INTO countin_;
            CLOSE qty_by_trans_code;
            adj_dr_ := adj_dr_ + nvl(countin_,0);
            --(+) 130321 SANPLK G1240973 (END)
            --exch_in_cash_
            OPEN get_exch_in_cash(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_exch_in_cash INTO exch_in_cash_;
            CLOSE get_exch_in_cash;

            --exch_in_hire_
            OPEN get_exch_in_hire_qty(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_exch_in_hire_qty INTO exch_in_hire_;
            CLOSE get_exch_in_hire_qty;
            exch_in_hire_ := nvl(exch_in_hire_,0);

            --revert_qty_
            OPEN get_revert_qty(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_revert_qty INTO revert_qty_;
            CLOSE get_revert_qty;
            revert_qty_ := nvl(revert_qty_,0);

            --sale_reverse_
            OPEN get_sale_reverse(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_sale_reverse INTO sale_reverse_;
            CLOSE get_sale_reverse;
            sale_reverse_ := nvl(sale_reverse_,0);

            --exch_out_cash_
            FOR ex_rec_ IN get_cash_exch_out_orders(site_rec_.contract, start_date_, end_date_) LOOP
               OPEN get_order_qty(ex_rec_.new_order_no, part_rec_.part_no);
               FETCH get_order_qty INTO order_qty_;
               CLOSE get_order_qty;

               exch_out_cash_ := exch_out_cash_ + nvl(order_qty_,0);
            END LOOP;
            exch_out_cash_ := nvl(exch_out_cash_,0);

            --exch_out_hire_
            FOR exch_rec_ IN get_exch_acc_info(site_rec_.contract, start_date_, end_date_) LOOP
               OPEN get_part_qty_in_acc(part_rec_.part_no, exch_rec_.account_no);
               FETCH get_part_qty_in_acc INTO acc_qty_;
               CLOSE get_part_qty_in_acc;
               acc_qty_ := nvl(acc_qty_,0);

               IF acc_qty_ > 0 THEN
                  OPEN get_transfered_qty(part_rec_.part_no, exch_rec_.previous_acc);
                  FETCH get_transfered_qty INTO trans_qty_;
                  CLOSE get_transfered_qty;

                  acc_qty_ := acc_qty_ - nvl(trans_qty_,0);
               END IF;

               exch_out_hire_ := exch_out_hire_ + acc_qty_;
            END LOOP;
            exch_out_hire_ := nvl(exch_out_hire_,0);

            --revert_rev_
            OPEN get_revert_reversed_qty(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_revert_reversed_qty INTO revert_rev_;
            CLOSE get_revert_reversed_qty;
            revert_rev_ := nvl(revert_rev_,0);

            --sales_ or ad_sales_
            OPEN qty_by_trans_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'OESHIP');
            FETCH qty_by_trans_code INTO sales_;
            CLOSE qty_by_trans_code;

            OPEN qty_by_trans_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'OERETURN');
            FETCH qty_by_trans_code INTO oereturns_;
            CLOSE qty_by_trans_code;

            OPEN get_transfer_out_qty(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_transfer_out_qty INTO transfer_out_qty_;
            CLOSE get_transfer_out_qty;

            OPEN get_transfer_in_qty(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_transfer_in_qty INTO transfer_in_qty_;
            CLOSE get_transfer_in_qty;

            --(+) 170420 SANPLK (START)
            OPEN qty_by_trans_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'WOUNISS');
            FETCH qty_by_trans_code INTO mr_ret_;
            CLOSE qty_by_trans_code;
            mr_ret_ := nvl(mr_ret_,0);

            OPEN qty_by_trans_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'WOISS');
            FETCH qty_by_trans_code INTO mr_iss_;
            CLOSE qty_by_trans_code;
            mr_iss_ := nvl(mr_iss_,0);
            
            OPEN qty_by_trans_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'INTSHIP');
            FETCH qty_by_trans_code INTO mrn_iss_;
            CLOSE qty_by_trans_code;
            mrn_iss_ := nvl(mrn_iss_,0);
            
            --(+) 170420 SANPLK (END)
            
            --Start Multi Site Changes
            FOR rec_ IN get_direct_deliveries(part_rec_.part_no, site_rec_.contract, start_date_, end_date_) LOOP
               --(+) 130321 SANPLK G1240973 (START)
               IF rec_.From_Site_Type = 'WH' OR rec_.From_Site_Type = 'FACTORY' THEN
                  debit_note_ := debit_note_ + rec_.qty;
               ELSE
               --(+) 130321 SANPLK G1240973 (END)
                  IF rec_.BM_AD1 = 7 AND rec_.BM_AD2 = 7 THEN
                     trf_in_ := trf_in_ + rec_.qty;
                  ELSE
                     trfc_in_ := trfc_in_ + rec_.qty;
                  END IF;
               --(+) 130321 SANPLK G1240973 (START)
               END IF;
               --(+) 130321 SANPLK G1240973 (END)
               ipd_sales_ := ipd_sales_ + rec_.qty;
            END LOOP;

            FOR rec_ IN get_po_receives(part_rec_.part_no, site_rec_.contract, start_date_, end_date_) LOOP
               --(+) 130321 SANPLK G1240973 (START)
               IF rec_.From_Site_Type = 'WH' OR rec_.From_Site_Type = 'FACTORY' THEN
                  debit_note_ := debit_note_ + rec_.qty;
               ELSE

                  IF rec_.BM_AD1 = 7 AND rec_.BM_AD2 = 7 THEN
                     trf_in_ := trf_in_ + rec_.qty;
                  ELSE
                     trfc_in_ := trfc_in_ + rec_.qty;
                  END IF;
               --(+) 130321 SANPLK G1240973 (END)
               END IF;
            END LOOP;

            FOR rec_ IN get_126B_out_for_multi_site(part_rec_.part_no, site_rec_.contract, start_date_, end_date_) LOOP
               IF rec_.accepting_site = 'WH' OR rec_.accepting_site = 'FACTORY' THEN
                  credit_note_ := credit_note_ + rec_.qty;
               ELSE
               
               dbms_output.put_line('******  rec_.BM_AD1 = '|| rec_.BM_AD1);
               dbms_output.put_line('******  rec_.BM_AD2 = '|| rec_.BM_AD2);
               dbms_output.put_line('******  rec_.qty = '|| rec_.qty);
               
               IF rec_.BM_AD1 = 7 AND rec_.BM_AD2 = 7 THEN
                  trf_out_ := trf_out_ + rec_.qty;
               ELSE
                  trfc_out_ := trfc_out_ + rec_.qty;
               END IF;
             END IF;
            END LOOP;
           FOR rec_ IN get_po_receipt_cancel(part_rec_.part_no, site_rec_.contract, start_date_, end_date_) LOOP
               IF rec_.From_Site_Type = 'WH' OR rec_.From_Site_Type = 'FACTORY' THEN
                  credit_note_ := credit_note_ + rec_.qty;
               ELSE
                  dbms_output.put_line('****** 222  rec_.BM_AD1 = '|| rec_.BM_AD1);
                  dbms_output.put_line('****** 222  rec_.BM_AD2 = '|| rec_.BM_AD2);
                  dbms_output.put_line('****** 222  rec_.qty = '|| rec_.qty);
               
                  IF rec_.BM_AD1 = 7 AND rec_.BM_AD2 = 7 THEN
                     trf_out_ := trf_out_ + rec_.qty;
                  ELSE
                     trfc_out_ := trfc_out_ + rec_.qty;
                  END IF;
               END IF;
            END LOOP;
            OPEN get_other_crn(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH get_other_crn INTO other_crn_;
            CLOSE get_other_crn;

            credit_note_ := credit_note_ + nvl(other_crn_,0);

            OPEN  qty_by_trans_code2(part_rec_.part_no, site_rec_.contract, start_date_, end_date_);
            FETCH qty_by_trans_code2 INTO arrival_;
            CLOSE qty_by_trans_code2;



            dir_debits_ := dir_debits_ + nvl(arrival_,0);

            --Direct returns from transit
            FOR rec_ IN get_dir_ret_from_transit(part_rec_.part_no, site_rec_.contract, start_date_, end_date_) LOOP
               IF rec_.customer_type = 7 AND rec_.site_type = 7  THEN
                  trf_in_ := trf_in_ + rec_.quantity;
               ELSE
                  trfc_in_ := trfc_in_ + rec_.quantity;
               END IF;
            END LOOP;
            --End Multi Site Changes
            --(+) 130321 SANPLK G1240973 (START)
            OPEN qty_by_trans_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'OERET-NO');
            FETCH qty_by_trans_code INTO trade_in_qty_;
            CLOSE qty_by_trans_code;
            adj_dr_ := adj_dr_ + nvl(trade_in_qty_,0);

            OPEN qty_by_trans_code(part_rec_.part_no, site_rec_.contract, start_date_, end_date_, 'OERET-NC');
            FETCH qty_by_trans_code INTO assembly_return_;
            CLOSE qty_by_trans_code;
            adj_dr_ := adj_dr_ + nvl(assembly_return_,0);
            --(+) 130321 SANPLK G1240973 (END)

            sales_ := (nvl(sales_,0) + nvl(transfer_out_qty_,0)) + nvl(ipd_sales_,0) - nvl(transfer_in_qty_,0);
            oereturns_ := nvl(oereturns_,0);
            sales_ := sales_ - (oereturns_ - (exch_in_cash_+exch_in_hire_+revert_qty_+sale_reverse_));
            sales_ := sales_ - (exch_out_cash_+exch_out_hire_+revert_rev_);
         END IF;

         --cf_balance_
         --(-/+) 170420 SANPLK (START)
         --cf_balance_ := (bf_balance_+adj_dr_+debit_note_+exch_in_cash_+exch_in_hire_+revert_qty_+sale_reverse_+trf_in_+trfc_in_+dir_debits_+other_rec_) - (adj_cr_+credit_note_+exch_out_cash_+exch_out_hire_+trf_out_+trfc_out_+other_iss_+revert_rev_+sales_);
         other_rec_ := other_rec_ + mr_ret_;
         other_iss_ := mr_iss_ + mrn_iss_;
         
         cf_balance_ := (bf_balance_+adj_dr_+debit_note_+exch_in_cash_+exch_in_hire_+revert_qty_+sale_reverse_+trf_in_+trfc_in_+dir_debits_+other_rec_) - (adj_cr_+credit_note_+exch_out_cash_+exch_out_hire_+trf_out_+trfc_out_+other_iss_+revert_rev_+sales_);
         --(-/+) 170420 SANPLK (END)
         
         --revert_bal_
         --(-/+) 130321 SANPLK G1240973 (START)
         --revert_bal_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand_By_Location(part_rec_.part_no, site_rec_.contract, 'REVERTS');
         OPEN qty_onhand_by_date_location(part_rec_.part_no, site_rec_.contract, end_date_, 'REVERTS');
         FETCH qty_onhand_by_date_location INTO revert_bal_;
         CLOSE qty_onhand_by_date_location;

         --school_stock_
         --sch_sew_qty_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand_By_Location(part_rec_.part_no, site_rec_.contract, 'SCHOOL-SEW');
         --sch_cs_qty_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand_By_Location(part_rec_.part_no, site_rec_.contract, 'SCHOOL-CS');
         OPEN qty_onhand_by_date_location(part_rec_.part_no, site_rec_.contract, end_date_, 'SCHOOL-SEW');
         FETCH qty_onhand_by_date_location INTO sch_sew_qty_;
         CLOSE qty_onhand_by_date_location;

         OPEN qty_onhand_by_date_location(part_rec_.part_no, site_rec_.contract, end_date_, 'SCHOOL-CS');
         FETCH qty_onhand_by_date_location INTO sch_cs_qty_;
         CLOSE qty_onhand_by_date_location;
         school_stock_ := nvl(sch_sew_qty_,0) + nvl(sch_cs_qty_,0);
         --(-/+) 130321 SANPLK G1240973 (END)

         --ad_stock_
         IF site_type_ = 8 THEN
            ad_stock_ := nvl(cf_balance_,0);
         --(+) 130321 SANPLK G1240973 (START)
         ELSE
            ad_stock_ := 0;
         END IF;
         --(+) 130321 SANPLK G1240973 (END)

         --ad_sales_
         IF ad_ = 'Y' THEN
            ad_sales_ := sales_;
            sales_ := 0;
         --(+) 130321 SANPLK G1240973 (START)
         ELSE
            ad_sales_ := 0;
         END IF;
         --(+) 130321 SANPLK G1240973 (END)

         IF trans_exist_ = 'TRUE' OR bf_balance_ != 0 THEN
            --Inserting Data
            Client_SYS.Clear_Attr(attr1_);

            newrec_.stat_year       := stat_year_;
            newrec_.stat_period_no  := stat_period_no_;
            newrec_.contract        := site_rec_.contract;
            newrec_.part_no         := part_rec_.part_no;
            newrec_.branch          := branch_;
            newrec_.ad              := ad_;
            newrec_.bf_balance      := to_number( bf_balance_ );
            newrec_.adj_dr          := to_number( adj_dr_ );
            newrec_.adj_cr          := to_number( adj_cr_ );
            newrec_.debit_note      := to_number( debit_note_ );
            newrec_.exch_in_cash    := to_number( exch_in_cash_ );
            newrec_.exch_in_hire    := to_number( exch_in_hire_ );
            newrec_.revert_qty      := to_number( revert_qty_ );
            newrec_.sale_reverse    := to_number( sale_reverse_ );
            newrec_.trf_in          := to_number( trf_in_ );
            newrec_.trfc_in         := to_number( trfc_in_ );
            newrec_.direct_dr       := to_number( dir_debits_ );
            newrec_.other_rec       := to_number( other_rec_ );
            newrec_.credit_note     := to_number( credit_note_ );
            newrec_.exch_out_cash   := to_number( exch_out_cash_ );
            newrec_.exch_out_hire   := to_number( exch_out_hire_ );
            newrec_.trf_out         := to_number( trf_out_ );
            newrec_.trfc_out        := to_number( trfc_out_ );
            newrec_.other_iss       := to_number( other_iss_ );
            newrec_.revert_rev      := to_number( revert_rev_ );
            newrec_.sales           := to_number( sales_ );
            newrec_.ad_sales        := to_number( ad_sales_ );
            newrec_.cf_balance      := to_number( cf_balance_ );
            newrec_.revert_bal      := to_number( revert_bal_ );
            newrec_.school_stock    := to_number( school_stock_ );
            newrec_.ad_stock        := to_number( ad_stock_ );
            --(+) 170420 SANPLK (START)
            --newrec_.mr_ret          := to_number( mr_ret_ );
            --newrec_.mr_iss          := to_number( mr_iss_ );
            --newrec_.mrn_iss          := to_number( mrn_iss_ );
            --(+) 170420 SANPLK (END)
            Insert___(objid1_, objversion1_, newrec_, attr1_);
         END IF;

      END LOOP;
   END LOOP;
END Process_Data;
