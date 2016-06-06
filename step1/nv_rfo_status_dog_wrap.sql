create or replace view nv_rfo_status_dog_wrap as
select
   sd."ID",sd."C_CODE",sd."C_NAME",sd."SN",sd."SU"
   ,case when sd.c_code = 'RFO_CLOSE' then 1 -- СЛУЖЕБНОЕ
         when sd.c_code in ('CANCEL','PREPARE','PREP_REVOLV') then 0 --ОТКАЗ, ПОДГОТОВКА, ПОДГОТОВКА К УСТНОВКЕ РЕВОЛЬВЕРНОСТИ
         else 1
    end as is_credit_issued
from V_RFO_Z#STATUS_DOG sd
;