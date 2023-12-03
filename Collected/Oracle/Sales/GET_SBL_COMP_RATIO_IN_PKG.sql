create or replace function GET_SBL_COMP_RATIO_IN_PKG(parent_part_ in varchar2,
                                                     comp_part_   in varchar2,
                                                     shop_code_   in varchar2,
                                                     calc_date_   in date)
  return number

 is

  cursor get_comp_part_cost(comp_part_ in varchar2,
                            shop_code_ in varchar2,
                            calc_date_ date) is
    select (p.qty_per_assembly *
           (select c.cost
               from IFSAPP.INVENT_ONLINE_COST_TAB c
              where c.year = extract(year from calc_date_)
                and c.period = extract(month from calc_date_)
                and c.contract = p.contract
                and c.part_no = p.catalog_no))
      from IFSAPP.SALES_PART_PACKAGE_TAB p
     where p.catalog_no = comp_part_
       and p.contract = shop_code_;

  cursor get_pkg_total_cost(parent_part_ in varchar2,
                            shop_code_   in varchar2,
                            calc_date_   date) is
    select sum(p.qty_per_assembly *
               (select c.cost
                  from IFSAPP.INVENT_ONLINE_COST_TAB c
                 where c.year = extract(year from calc_date_)
                   and c.period = extract(month from calc_date_)
                   and c.contract = p.contract
                   and c.part_no = p.catalog_no))
      from IFSAPP.SALES_PART_PACKAGE_TAB p
     where p.parent_part = parent_part_
       and p.contract = shop_code_;

  comp_cost_      number;
  pkg_total_cost_ number;
  comp_ratio_     number;

begin
  open get_comp_part_cost(comp_part_, shop_code_, calc_date_);

  if get_comp_part_cost%notfound then
    comp_cost_ := 0;
  else
    fetch get_comp_part_cost
      into comp_cost_;
  end if;

  if get_comp_part_cost%isopen then
    close get_comp_part_cost;
  end if;

  open get_pkg_total_cost(parent_part_, shop_code_, calc_date_);

  if get_pkg_total_cost%found then
    pkg_total_cost_ := 0;
  else
    fetch get_pkg_total_cost
      into pkg_total_cost_;
  end if;

  if get_pkg_total_cost%isopen then
    close get_pkg_total_cost;
  end if;

  if pkg_total_cost_ != 0 then
    comp_ratio_ := round((comp_cost_ / pkg_total_cost_), 6);
  else
    comp_ratio_ := 0;
  end if;

  return comp_ratio_;

end GET_SBL_COMP_RATIO_IN_PKG;