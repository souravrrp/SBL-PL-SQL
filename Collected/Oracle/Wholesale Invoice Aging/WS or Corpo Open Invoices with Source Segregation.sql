-- WS or Corpo Open Invoices with Source Segregation
select o.*,
       case
         when o.dealer_id like 'I000%' then
          'CORPORATE'
         else
          'WHOLESALE'
       end CHANNEL,
       b.singer_contribution,
       b.singer_vat_contribution,
       b.archelik_contribution,
       b.archelik_vat_contribution,
       b.third_party_contribution,
       b.third_party_vat_contribution,
       b.vat_contribution
  from ifsapp.SBL_VW_WS_DEALER_OPEN_INVOICE o
  left join (select t.invoice_id,
                    i.series_id,
                    i.invoice_no,
                    nvl(sum(case
                              when p.hyperion_source_code =
                                   'Source Singer (Production)' then
                               t.net_curr_amount
                              else
                               0
                            end),
                        0) singer_contribution,
                    nvl(sum(case
                              when p.hyperion_source_code =
                                   'Source Singer (Production)' then
                               t.vat_curr_amount
                              else
                               0
                            end),
                        0) singer_vat_contribution,
                    nvl(sum(case
                              when p.hyperion_source_code in
                                   ('Source Beko Electrical Appliances (Production)',
                                    'Source Arçelik (Production)',
                                    'Source Beko Thai (Production)') then
                               t.net_curr_amount
                              else
                               0
                            end),
                        0) archelik_contribution,
                    nvl(sum(case
                              when p.hyperion_source_code in
                                   ('Source Beko Electrical Appliances (Production)',
                                    'Source Arçelik (Production)',
                                    'Source Beko Thai (Production)') then
                               t.vat_curr_amount
                              else
                               0
                            end),
                        0) archelik_vat_contribution,
                    nvl(sum(case
                              when p.hyperion_source_code in
                                   ('Source Third Party (Trade)',
                                    'Source Dawlance (Production)',
                                    'Source Defy (Production)') then
                               t.net_curr_amount
                              else
                               0
                            end),
                        0) third_party_contribution,
                    nvl(sum(case
                              when p.hyperion_source_code in
                                   ('Source Third Party (Trade)',
                                    'Source Dawlance (Production)',
                                    'Source Defy (Production)') then
                               t.vat_curr_amount
                              else
                               0
                            end),
                        0) third_party_vat_contribution,
                    nvl(sum(t.vat_curr_amount), 0) vat_contribution
               from ifsapp.invoice_item_tab t
              inner join ifsapp.INVOICE_TAB i
                 on t.invoice_id = i.invoice_id
              inner join ifsapp.sbl_ak_sku_details p
                 on t.c5 = p.sales_part_no
              /*where t.invoice_id = '8192819'*/
              group by t.invoice_id, i.series_id, i.invoice_no) b
    on o.invoice_id = b.invoice_id
 where o.series_id not in ('CUCHECK', 'WSADV', 'CI');

/*select o.series_id
  from SBL_VW_WS_DEALER_OPEN_INVOICE o
 group by o.series_id;*/
