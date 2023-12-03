select * from sbl_product_info
order by 1

/*
insert into product_info(group_no, product_group, avg_cost, short_name)
values('133', 'Water Heater', '', '');
commit;
*/

select * from product_category_info
where /*group_no = 131 
and*/ product_code like 'RMAV-%'

--new product insertion
/*
insert into product_category_info(group_no, product_code) values('105', 'SRWM-STD110LSDA');
insert into product_category_info(group_no, product_code) values('105', 'SRWM-STD80SFDA');
insert into product_category_info(group_no, product_code) values('105', 'SRWM-STD80SAPRO');
commit;
*/



--update product information
/*
update product_category_info p
set p.group_no = 120
where p.product_code = 'SRREF-STD-ALD-8';
commit;
*/

/*
delete from product_category_info p
 where p.product_code in ('PK-SRFUR-BSWD001F-SET-1',
                          'PK-SRFUR-LORA-SET-1',
                          'PK-SRFUR-ONYX-SET-1',
                          'PK-SRFUR-OPAL-TEAK-SET',
                          'PK-SRFUR-RICO-SET-1',
                          'PK-SRFUR-STDT001F-SET-1',
                          'PK-SRFUR-STDT002F-SET-1',
                          'PK-SRFUR-STDTTK001F',
                          'PK-SRFUR-STDTTK002F',
                          'PK-SRFUR-VIVO-SET-1',
                          'SRFUR-CBCT003F',
                          'SRFUR-CBCT004F',
                          'SRFUR-CBCT005F',
                          'SRFUR-CBCT006F',
                          'SRFUR-MAT001CR',
                          'SRFUR-ODMG201F',
                          'SRFUR-OSMG101F');
 commit;
*/


select * from shop_dts_info s
where /*s.shop_code like 'CPBB'*/
s.district_code = 29
order by s.district_code

--insertion of shop information
/*
insert into shop_dts_info(shop_code,area_code,district_code)
values('CPBB','EAST','17');
commit;
*/

--update shop information
/*update shop_dts_info s
set s.area_code = 'Central B Area'
where s.shop_code = 'DWRB';
commit;*/

/*DELETE FROM SHOP_DTS_INFO;
COMMIT;

TRUNCATE TABLE SHOP_DTS_INFO;
COMMIT;*/


select * from WARE_HOUSE_INFO w
where w.ware_house_name = 'TUWW'


--insertion of warehouse information
/*
insert into ware_house_info(ware_house_name, description) values('TUWW', 'Turag Wholesale Warehouse');
commit;
*/
