﻿create materialized view NM_MATRIX_ALL_DAY_BAS
build deferred
refresh force on demand
as
select /*+ parallel(64)*/
     yyyy
    ,quarter
    ,text_yyyy_mm
    ,week_text
    ,text_yyyy_mm_dd_week_day
    ,con_yyyy
    ,con_quarter
    ,con_text_yyyy_mm
    ,con_week_text
    ,con_text_yyyy_mm_dd_week_day
    --,rfo_con_or_claim_id
    ,rfo_con_claim_type
    --,folder_con_date
    --,folder_con_date_time
    --,folder_id
    --,contract_number
    ,sum(contract_amount)/1000000 as amount_requested_mln
    ,process_code
    ,process_name
    --,rfo_client_id
    --,iin
    --,rnn
    ,product
    ,product_type
    --,folder_date_create_mi
    ,count(rbo_contract_id) as contract_cnt
    ,count(distinct rbo_contract_id) as contract_cnt_dist
    ,count(*) as cnt
    ,count(distinct case when t.rfo_con_claim_type='CLAIM' then rfo_con_or_claim_id end) as claim_cnt
    ,count(distinct case when t.rfo_con_claim_type<>'CLAIM' then rfo_con_or_claim_id end) as rfo_con_cnt
    ,count(distinct rfo_con_or_claim_id) as rfo_con_or_claim_cnt -- кол-во заявок, включая онлайн
    ,count(distinct folder_id) as fld_cnt
    ,sum(cancel_prescoring)           as   cancel_prescoring
    ,sum(cancel_middle_office)        as   cancel_middle_office
    ,sum(cancel_controller) as             cancel_controller
    ,sum(cancel_client) as                 cancel_client
    ,sum(cancel_manager) as                cancel_manager
    ,sum(cancel_cpr_aa) as                 cancel_cpr_aa
    ,sum(cancel_verificator) as            cancel_verificator
    ,sum(cancel_undefined) as              cancel_undefined
    ,sum(is_aa_approved) as                is_aa_approved
    ,sum(is_aa_reject) as                  is_aa_reject
    ,sum(rfo_con_or_claim_not_rej) as      rfo_con_or_claim_not_rej
    ,is_credit_issued_rfo
    ,is_credit_issued_rbo
    --,rbo_contract_id
    ,sum(contract_amount_rbo)/1000000 as contract_amount_rbo_mln
    ,is_on_balance
    ,sum(sales)/1000000 as sales_mln
    ,sum(del_debt_7d       )/1000000  as del_debt_7d_mln
    ,sum(del_debt_30d      )/1000000  as del_debt_30d_mln
    ,sum(del_debt_60d      )/1000000  as del_debt_60d_mln
    ,sum(del_debt_90d      )/1000000  as del_debt_90d_mln
    ,sum(del_debt_30d_ever )/1000000  as del_debt_30d_ever_mln
    ,sum(del_debt_60d_ever )/1000000  as del_debt_60d_ever_mln
    ,sum(del_debt_90d_ever )/1000000  as del_debt_90d_ever_mln
    ,sum(pmt_1_0d_del_debt )/1000000  as pmt_1_0d_del_debt_mln
    ,sum(pmt_1_0d_sales    )/1000000  as pmt_1_0d_sales_mln
    ,sum(pmt_1_7d_del_debt )/1000000  as pmt_1_7d_del_debt_mln
    ,sum(pmt_1_7d_sales    )/1000000  as pmt_1_7d_sales_mln
    ,sum(pmt_2_7d_del_debt )/1000000  as pmt_2_7d_del_debt_mln
    ,sum(pmt_2_7d_sales    )/1000000  as pmt_2_7d_sales_mln
    ,sum(pmt_3_7d_del_debt )/1000000  as pmt_3_7d_del_debt_mln
    ,sum(pmt_3_7d_sales    )/1000000  as pmt_3_7d_sales_mln
    ,sum(pmt_4_7d_del_debt )/1000000  as pmt_4_7d_del_debt_mln
    ,sum(pmt_4_7d_sales    )/1000000  as pmt_4_7d_sales_mln
    ,sum(pmt_5_7d_del_debt )/1000000  as pmt_5_7d_del_debt_mln
    ,sum(pmt_5_7d_sales    )/1000000  as pmt_5_7d_sales_mln
    ,sum(pmt_6_7d_del_debt )/1000000  as pmt_6_7d_del_debt_mln
    ,sum(pmt_6_7d_sales    )/1000000  as pmt_6_7d_sales_mln
    ,sum(pmt_1_30d_del_debt)/1000000  as pmt_1_30d_del_debt_mln
    ,sum(pmt_1_30d_sales   )/1000000  as pmt_1_30d_sales_mln
    ,sum(pmt_1_60d_del_debt)/1000000  as pmt_1_60d_del_debt_mln
    ,sum(pmt_1_60d_sales   )/1000000  as pmt_1_60d_sales_mln
from NV_MATRIX_ALL_DAY_DETAIL t
group by
     yyyy
    ,quarter
    ,text_yyyy_mm
    ,week_text
    ,text_yyyy_mm_dd_week_day
    ,con_yyyy
    ,con_quarter
    ,con_text_yyyy_mm
    ,con_week_text
    ,con_text_yyyy_mm_dd_week_day
    ,rfo_con_claim_type
    ,process_code
    ,process_name
    ,product
    ,product_type
    ,is_credit_issued_rfo
    ,is_credit_issued_rbo
    ,is_on_balance;