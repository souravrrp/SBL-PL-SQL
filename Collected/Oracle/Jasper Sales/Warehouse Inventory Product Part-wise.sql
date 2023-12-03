--Warehouse Inventory Product Part-wise
select i.contract,
       i.part_no,
       p.product_family,
       i.qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 inner join IFSAPP.WARE_HOUSE_INFO w
    on i.contract = w.ware_house_name
 where i.qty_onhand > 0
   and i.part_no = 'SRBAT-HPD-100T' /*'SRREF-SINGER-DF1-07'*/
   /*and w.ware_house_name = 'SLWW'*/ /*'SWHW'*/ /*'LFBB'*/
 order by i.contract

--
select i.contract,
       i.part_no,
       p.product_family,
       sum(i.qty_onhand) qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 inner join IFSAPP.WARE_HOUSE_INFO w
    on i.contract = w.ware_house_name
 where i.qty_onhand > 0
   and i.part_no = /*'SRBAT-HPD-100T'*/ 'SRREF-SINGER-DF1-07'
   /*and w.ware_house_name = 'SLWW'*/ /*'SWHW'*/ /*'LFBB'*/
 group by i.contract, i.part_no, p.product_family
 order by i.contract

--
select w.ware_house_name,
       'SRBAT-HPD-100T' part_no,
       (select p.product_family
          from IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
         where p.product_code = 'SRBAT-HPD-100T') product_family,
       to_number(0) qty_onhand
  from IFSAPP.WARE_HOUSE_INFO w


--
select w2.ware_house_name,
       s.part_no,
       s.product_family,
       nvl(s.qty_onhand, 0) qty_onhand
  from IFSAPP.WARE_HOUSE_INFO w2
  left join (select i.contract,
                    i.part_no,
                    p.product_family,
                    sum(i.qty_onhand) qty_onhand
               from IFSAPP.INVENTORY_PART_IN_STOCK i
              inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
                 on i.part_no = p.product_code
              right join IFSAPP.WARE_HOUSE_INFO w
                 on i.contract = w.ware_house_name
              where i.qty_onhand > 0
                and i.part_no = 'SRBAT-HPD-100T'
              group by i.contract, i.part_no, p.product_family) s
    on w2.ware_house_name = s.contract
