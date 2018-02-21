

--version 1.00:
--============

select --sum (rated_flat_amount)  bill_value
/*duration_volume, */data_volume ,START_TIME_TIMESTAMP, /*entry_date_timestamp ,*/ o_p_number_address , rated_flat_amount, remark
from rtx , customer_all
where rtx.cust_info_customer_id = customer_all.customer_id
and customer_id = (select ca.customer_id from
				  directory_number dn , contr_services_cap csc , contract_all co , customer_all ca
				  where dn.dn_id = csc.dn_id 
				  and csc.co_id = co.co_id
				  and co.customer_id = ca.customer_id
				  and dn.dn_num = '123652809'
				  and csc.cs_deactiv_date is null)
--and rtx.s_p_number_address = '20121004446'
and rtx.START_TIME_TIMESTAMP >= to_date ('01/06/2009' , 'dd/mm/yyyy')
and rtx.START_TIME_TIMESTAMP  <  to_date ('08/03/2010' , 'dd/mm/yyyy')
--and o_p_number_address not like '202%'
--and length(o_p_number_address) > 6
--and rated_flat_amount <> 0
--and o_p_number_address = '20235720132'
order by START_TIME_TIMESTAMP


select s_p_number_address, duration_volume, entry_date_timestamp,
o_p_number_address , rated_flat_amount,
(rated_flat_amount*100/data_volume) factor from rtx
where o_p_number_address = 'mobinilwap'
and rated_flat_amount<>0
and data_volume>(99*1024)
and rownum<100
