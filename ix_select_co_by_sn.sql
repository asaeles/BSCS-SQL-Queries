/* Formatted on 2009/11/09 17:51 (Formatter Plus v4.8.7) */
SELECT co.co_id, co.co_code, ca.custcode
  FROM (SELECT sh.co_id
          FROM pr_serv_status_hist sh
         WHERE sh.sncode = 65
           AND sh.status = 'A'
           AND sh.histno =
                  (SELECT MAX (histno)
                     FROM pr_serv_status_hist
                    WHERE co_id = sh.co_id
                      AND profile_id = sh.profile_id
                      AND sncode = sh.sncode)
           AND ROWNUM < 5) c,
       contract_all co,
       customer_all ca
 WHERE co.co_id = c.co_id AND ca.customer_id = co.customer_id;

SELECT co.co_id, co.co_code, ca.custcode
          FROM pr_serv_status_hist sh, contract_all co,
       customer_all ca
         WHERE sh.sncode = 1
           AND sh.status = 'A'
           AND sh.histno =
                  (SELECT MAX (histno)
                     FROM pr_serv_status_hist
                    WHERE co_id = sh.co_id
                      AND profile_id = sh.profile_id
                      AND sncode = sh.sncode)
and co.co_id = sh.co_id AND ca.customer_id = co.customer_id and co.TMCODE = 82;

select * from pr_serv_status_hist sh where co_id = 11026

select * from mdsrrtab order by 1 desc

begin
contract.finish_request(165688683);
end;