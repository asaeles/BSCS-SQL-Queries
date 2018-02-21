/* Formatted on 2010/07/27 12:55 (Formatter Plus v4.8.7) */
SELECT COUNT (1)
  FROM BILLCYCLE_ASSIGNMENT_HISTORY bah
 WHERE seqno > 1
   AND EXISTS (
          SELECT *
            FROM BILLCYCLE_ASSIGNMENT_HISTORY
           WHERE seqno = bah.seqno - 1
             AND customer_id = bah.customer_id
             AND billcycle <> bah.billcycle)
   AND valid_from > '24-06-2010';
