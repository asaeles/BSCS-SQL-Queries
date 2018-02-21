/* Formatted on 2011/11/20 13:06 (Formatter Plus v4.8.7) */
SELECT   /*+ FIRST_ROWS ORDERED */
         bah.billcycle, COUNT (1)
    FROM PR_SERV_SPCODE_HIST psh,
         CONTRACT_ALL co,
         BILLCYCLE_ASSIGNMENT_HISTORY bah
   WHERE co.co_id = psh.co_id
     AND bah.customer_id = co.customer_id
     AND psh.sncode = 1
     AND psh.spcode IN (94, 98, 130)
     AND co.Ch_Status <> 'd'
     AND bah.seqno = (SELECT MAX (seqno)
                        FROM BILLCYCLE_ASSIGNMENT_HISTORY
                       WHERE customer_id = bah.customer_id)
     AND psh.histno = (SELECT MAX (histno)
                         FROM PR_SERV_SPCODE_HIST
                        WHERE co_id = psh.co_id AND sncode = psh.sncode)
GROUP BY bah.billcycle;
