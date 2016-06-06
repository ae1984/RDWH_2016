create or replace view nv_rfo_application_baswrap as
select /*- no_parallel*/
   rr.rfo_con_or_claim_id
   ,rr.rfo_con_claim_type
   ,rr.folder_con_date
   ,rr.folder_con_date_time
   ,rr.folder_id
   ,rr.contract_number
   ,rr.contract_amount
   ,rr.process_code
   ,rr.process_name
   --,rr.cp_c_point
   --,rr.c_kas_vid_delivery
   --,rr.cs_c_add_prop
   --,rr.product1
   --,rr.product_type1
   --,rr.fd_c_status_doc
   --,rr.client_ref
   ,rr.rfo_client_id
   ,rr.iin
   ,rr.rnn
   ,rr.product
   ,rr.product_type
   --,rr.ps_cancel
   --,rr.vr_cancel
   --,rr.mo_cancel
   --,rr.cp_cancel
   --,rr.mn_cancel
   --,rr.cl_cancel
   ,rr.cancel_type_point
   ,rr.is_point_active
   ,rr.is_credit_issued
   ,rr.is_aa_approved
   ,rr.delivery_type
   ,rr.bk_folder_id
   ,rr.is_bk_aa_approved
   ,rr.folder_date_create_mi
   ,rr.folder_id_first
   --,rr.cancel_prescoring
   --,rr.cancel_verificator
   --,rr.cancel_middle_office
   --,rr.cancel_cpr_aa
   --,rr.cancel_manager
   --,rr.cancel_client
   --,rr.cancel_controller
   ,rr.is_bk_aa_approved_max
   ,rr.cancel_prescoring
   ,case when rr.cancel_middle_office=1 then case when nvl(rr.cancel_prescoring,0)>0 then 0 else 1 end end cancel_middle_office
   ,case when rr.cancel_controller=1 then case when nvl(rr.cancel_prescoring,0)
                                                   +nvl(rr.cancel_middle_office,0)>0 then 0 else 1 end end cancel_controller
   ,case when rr.cancel_client=1 then case when nvl(rr.cancel_prescoring,0)
                                               +nvl(rr.cancel_middle_office,0)
                                               +nvl(rr.cancel_controller,0)>0 then 0 else 1 end end cancel_client
   ,case when rr.cancel_manager=1 then case when nvl(rr.cancel_prescoring,0)
                                                +nvl(rr.cancel_middle_office,0)
                                                +nvl(rr.cancel_controller,0)
                                                +nvl(rr.cancel_client,0)>0 then 0 else 1 end end cancel_manager
   ,case when rr.cancel_cpr_aa=1 then case when nvl(rr.cancel_prescoring,0)
                                               +nvl(rr.cancel_middle_office,0)
                                               +nvl(rr.cancel_controller,0)
                                               +nvl(rr.cancel_client,0)
                                               +nvl(rr.cancel_manager,0)>0 then 0 else 1 end end cancel_cpr_aa
   ,case when rr.cancel_verificator=1 then case when nvl(rr.cancel_prescoring,0)
                                                    +nvl(rr.cancel_middle_office,0)
                                                    +nvl(rr.cancel_controller,0)
                                                    +nvl(rr.cancel_client,0)
                                                    +nvl(rr.cancel_manager,0)
                                                    +nvl(rr.cancel_cpr_aa,0)>0 then 0 else 1 end end cancel_verificator
   ,case when rr.is_point_active=0
              and rr.is_credit_issued=0
              and nvl(rr.cancel_prescoring,0)
                 +nvl(rr.cancel_middle_office,0)
                 +nvl(rr.cancel_controller,0)
                 +nvl(rr.cancel_client,0)
                 +nvl(rr.cancel_manager,0)
                 +nvl(rr.cancel_cpr_aa,0)
                 +nvl(rr.cancel_verificator,0)=0 then 1
    end as cancel_undefined

   ,case when coalesce(rr.is_aa_approved, rr.is_bk_aa_approved_max) = 0 then 1
         when coalesce(rr.is_aa_approved, rr.is_bk_aa_approved_max) = 1 then 0
    end as is_aa_reject

from NM_RFO_APPLICATION_BAS rr
where not( rr.rfo_con_claim_type = 'CARD'
          and rr.folder_con_date >=to_date('30.06.2014','dd.mm.yyyy')
          and rr.product_code = 'KAS_PC_DOG' -- Револьверные карты
          and rr.tariff_plan_code = 'PRIVILEGE' -- Привелигированный
          and rr.process_code in ('KAS_AUTO_CRED_PRIV_PC',   -- Каспийский. Выдача автокредита на карту
                                  'KAS_CREDIT_CASH_PRIV_PC', --'КАСПИЙСКИЙ. ВЫДАЧА КРЕДИТА НАЛИЧНЫМИ НА КАРТУ',
                                  'OPEN_CRED_PRIV_PC' --'КАСПИЙСКИЙ. ВЫДАЧА КРЕДИТА НА КАРТУ'
                                 )
         )
      and rr.product_code <> 'INSURANCE' -- страховки не показываем
      and rr.product_code <> 'DEP_CARD'  -- КАРТА ВКЛАДЧИКА
      and not (nvl(rr.delivery_type,'NONE') = 'БК' and rr.rfo_con_claim_type <> 'CARD') -- по БК
                                                         -- (безопасный кредит/управляемый кредит) показываем только карту
                                                         -- подумать по признакам на договор
;