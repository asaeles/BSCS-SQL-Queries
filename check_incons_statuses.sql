/* Formatted on 2011/06/08 13:43 (Formatter Plus v4.8.7) */
SELECT *
  FROM CONTRACT_ALL co
 WHERE Ch_Status <> 'a'
   AND Ch_Status <> 'o'
   AND EXISTS (SELECT *
                 FROM PR_SERV_STATUS_HIST psh
                WHERE psh.co_id = co.co_id AND LOWER(psh.STATUS) <> co.Ch_Status AND psh.histno = )
