--***** Inventory Transaction History
select t.* /*,
       case
         when t.order_type_db = 'PUR ORDER' then
          (select p.vendor_no
             from PURCHASE_ORDER_TAB p
            where p.order_no = t.order_no)
         when t.order_type_db = 'CUST ORDER' then
          (select c.customer_no
             from HPNRET_CUSTOMER_ORDER c
            where c.order_no = t.order_no)
         else
          ''
       END "VENDOR/CUSTOMER"*/
  from IFSAPP.INVENTORY_TRANSACTION_HIST t
 where t.direction in ('+', '-')
      /*and t.contract in ('CTGW', 'CTWW', 'CTCW')*/
      /*and t.transaction in ('INVM-ISS', 'INVM-IN', 'NISS', 'NREC')*/
   and trunc(t.dated) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and t.part_no in ('RMAC-COMPSR-SAS12L90LVLGT',
                     'RMAC-COMPSR-SAS18L90LVLGT',
                     'RMAC-PANEL-SAS12L90LVLGT',
                     'RMAC-PANEL-SAS18L90LVLGT',
                     'RMAC-PARTS-SAS12L90LVLGT',
                     'RMAC-PARTS-SAS18L90LVLGT',
                     'RMAV-LED-28 -TCL',
                     'RMAV-LED-32-TCL-LCD-DEVIC',
                     'RMAV-PANEL-PARTS-28 -TCL',
                     'RMAV-PANEL-PARTS-32-TCL',
                     'RMAV-PARTS-SLE28D1620TC',
                     'RMAV-PARTS-SLE32A7000STC',
                     'RMAV-PARTS-SLE32D1200TC',
                     'RMAV-PARTS-SLE32D1202TC')
 order by t.transaction_id
