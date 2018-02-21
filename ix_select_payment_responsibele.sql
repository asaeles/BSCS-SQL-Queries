SELECT * FROM (
	SELECT * FROM (
        SELECT ca.customer_id, ca.customer_id_high, ca.custcode,
        ca.paymntresp
        FROM customer_all ca
        CONNECT BY PRIOR ca.customer_id_high = ca.customer_id
        START WITH ca.custcode = '3.122.13.00.100000') ca
    WHERE ca.paymntresp = 'X'
    ORDER BY ca.custcode DESC)
WHERE ROWNUM < 2;
