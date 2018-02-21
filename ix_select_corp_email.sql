SELECT cu.custcode, cu.customer_id, TRIM (TO_CHAR ( ROUND (cu.cscurbalance), '99G999G999G999' )) ||
' EGP' balance, NVL (ca.cnt, 0) contracts, p.email email_address FROM ( SELECT ca.parent_id, COUNT
(1) cnt FROM ( SELECT CONNECT_BY_ROOT ca.customer_id parent_id, ca.customer_id FROM customer_all ca
START WITH ca.customer_id IN (SELECT customer_id FROM customer_all WHERE custcode LIKE '2.75%' AND
cstype = 'a' AND cslevel != '40' AND paymntresp = 'X') CONNECT BY PRIOR ca.customer_id =
ca.customer_id_high AND ca.paymntresp IS NULL AND ca.cstype = 'a') ca, contract_all co WHERE
co.customer_id = ca.customer_id AND co.ch_status IN ('a', 's') GROUP BY ca.parent_id) ca,
customer_all cu, mobinil.portal_customer_info p WHERE cu.customer_id = ca.parent_id AND
p.customer_id(+) = cu.customer_id ORDER BY cu.custcode;

SELECT p.email, cu.custcode
FROM mobinil.portal_customer_info p, customer_all cu
WHERE 	 cu.customer_id = p.customer_id
AND p.email IN ('peter.mounir@hp.com', 'refaat.mm@pg.com',
'shrief.m@pg.com', 'ghalab.n@pg.com', 'alex.adm@egytrans.com.eg')
ORDER BY 1, 2;