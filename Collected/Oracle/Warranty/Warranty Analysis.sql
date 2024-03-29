--Table Names
/*IFSAPP.WARRANTY_CONDITION
IFSAPP.CUST_WARRANTY_TYPE_TEMP
IFSAPP.CUST_WARRANTY_TEMP_COND
IFSAPP.SALES_PART
IFSAPP.CUST_WARRANTY_TAB
IFSAPP.CUST_WARRANTY_TYPE_TAB *****
IFSAPP.SERIAL_WARRANTY_DATES_TAB *****
EQUIPMENT_OBJECT_TAB
OBJECT_CUST_WARRANTY_TAB *****
PART_SERIAL_CATALOG_TAB*/

--
select *
  from OBJECT_CUST_WARRANTY_TAB t
 where t.mch_code = /*'DLCOM-VOSTRO-3668MT-610'*/ 'SRMO-SMW-25GQ5A-22054' /*'SRMO-SMW-G30G6-73154'*/ /*'SRMO-SMW-20D2A-2090'*/ /*'SREO-HK-3402RC-4'*/ /*'SRREF-SINGER-BCD-198R-4928'*/ /*'SREO-STO23BDHT-1098'*/
   /*and*/ t.contract = 'COXB' 'DGNB' 'CMRB'
   /*and*/ substr(t.source_id, 1, (instr(t.source_id, ' ', 1) - 1)) =
       'COX-R14001' /*'DGN-R22071' 'CMR-R4354'*/;

--
  select substr(t.source_id, 1, (instr(t.source_id, ' ', 1) - 1))
          from OBJECT_CUST_WARRANTY_TAB t
         where t.mch_code = /*'SREO-HK-3402RC-4'*/ /*'SREO-STO23BDHT-1098'*/ 'SRREF-SINGER-BCD-198R-4928'

--
select * from CUST_WARRANTY_TYPE_TAB t
where t.warranty_type_id = 'SR EK- 1YEAR'
ORDER BY T.ROWVERSION DESC

--
select * from CUST_WARRANTY_TAB t
WHERE t.warranty_id = '161675'

--
select * from SERIAL_WARRANTY_DATES_TAB t

--
select *
  from PART_SERIAL_CATALOG_TAB t
 WHERE /*T.ALTERNATE_ID = 'SREO-STO23BDHT-1098'*/
 T.PART_NO = 'SREK-PRISMA2912'
 AND T.ALTERNATE_CONTRACT = 'DGNB'
 AND TRUNC(T.PURCHASED_DATE) >= TO_DATE('10/18/2017', 'MM/DD/YYYY')
 
--
select * from EQUIPMENT_OBJECT_TAB t
where t.part_no = /*'SREO-HK-3402RC'*/ 'DLCOM-VOSTRO-3668MT'
and t.mch_serial_no = /*'4'*/ '610'

--
select * from SALES_PART_TAB t
where t.catalog_no = /*'SRMO-SMW-25GQ5A'*/ /*'SREO-HK-3402RC'*/ /*'SRMO-SMW-20D2A'*/ 'DLCOM-VOSTRO-3668MT'
/*and t.contract = 'DMRB'*/
and T.CUST_WARRANTY_ID is not null /*= '161675'*/

--
select * from WARRANTY_CONDITION_TAB t
select * from CUST_WARRANTY_TYPE_TEMP_TAB t
select * from CUST_WARRANTY_TEMP_COND_TAB t

--*****Transfer Warranty to All Sites
begin
  update_warrnty_for_inv_part('SRMO-SMW-25GQ5A');
  commit;
end;
