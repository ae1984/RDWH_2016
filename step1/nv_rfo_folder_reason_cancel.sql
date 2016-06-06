create or replace view nv_rfo_folder_reason_cancel as
select
--RDWH2.0
    cl.c_folders as folder_id
    ,clt.cancel_type
    ,clt.c_code
    ,clt.c_name
    ,clt.ps_cancel
    ,clt.vr_cancel
    ,clt.mo_cancel
    ,clt.cp_cancel
    ,clt.mn_cancel
    ,clt.cl_cancel
from u1.V_RFO_Z#KAS_CANCEL cl
left join u1.NV_RFO_KAS_CANCEL_TYPES clt on clt.id = cl.c_type
where (cl.c_hist_err_level = 1 or -- выбираем критичные отказы
      (clt.c_type in ('CLIENT_PC_TO_EKT') and upper(cl.c_note) like '%ќ“ ј«јЋ—я%'))
group by
    cl.c_folders
    ,clt.cancel_type
    ,clt.c_code
    ,clt.c_name
    ,clt.ps_cancel
    ,clt.vr_cancel
    ,clt.mo_cancel
    ,clt.cp_cancel
    ,clt.mn_cancel
    ,clt.cl_cancel
;