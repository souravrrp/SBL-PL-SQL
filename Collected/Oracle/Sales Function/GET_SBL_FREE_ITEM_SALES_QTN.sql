create or replace function GET_SBL_FREE_ITEM_SALES_QTN(
       invoice_id_          in number,
       item_id_             in number,
       sales_qty_           in number) return number

is

  cursor get_alt_sales_price(invoice_id_ in number, item_id_ in number) is
  select t.net_curr_amount SALES_PRICE
    from ifsapp.invoice_item_tab t   
   where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
     and t.rowstate = 'Posted'
     and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
     and t.invoice_id = invoice_id_
     and t.item_id != item_id_
     and t.net_curr_amount != 0
     and rownum <= 1;

  alt_sales_price_         number;
  free_qty_                number;

begin

  open get_alt_sales_price(invoice_id_, item_id_);
  fetch get_alt_sales_price into alt_sales_price_;
  close get_alt_sales_price;
      
  if alt_sales_price_ < 0 then
    free_qty_ := (-1) * sales_qty_;
  else
    free_qty_ := 1 * sales_qty_;
  end if;
      
  return free_qty_;
      
end GET_SBL_FREE_ITEM_SALES_QTN;
