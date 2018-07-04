CREATE TABLE sysadm.bc_act_view_custs
AS
	SELECT customer_id
	  FROM customer_all
	 WHERE customer_id IN (XXXXXXXXX);

GRANT SELECT ON sysadm.bc_act_view_custs TO bscs_role;

CREATE OR REPLACE FORCE VIEW sysadm.billcycle_actual_view
(
	customer_id,
	billcycle,
	valid_from,
	reason_id,
	username,
	comments
)
AS
	SELECT customer_id,
			 billcycle,
			 valid_from,
			 reason_id,
			 username,
			 comments
	  FROM billcycle_assignment_history bah
	 WHERE	  bah.customer_id IN (SELECT customer_id
												FROM bc_act_view_custs)
			 AND bah.valid_from IN (SELECT MAX (valid_from)
											  FROM billcycle_assignment_history
											 WHERE	  customer_id = bah.customer_id
													 AND valid_from <= SYSDATE)
			 AND bah.seqno IN (SELECT MAX (seqno)
										FROM billcycle_assignment_history
									  WHERE		customer_id = bah.customer_id
											  AND valid_from <= SYSDATE);

CREATE OR REPLACE FORCE VIEW sysadm.group_share
(
	grp_share_co_code,
	grp_share_type
)
AS
	SELECT co.co_code, DECODE (ic.combo06, 'Initiator', 'INITIATOR', 'MEMBER')
	  FROM sysadm.contract_all co, sysadm.info_contr_combo ic
	 WHERE	  ic.co_id = co.co_id
			 AND (	ic.combo06 = 'Initiator'
					OR ic.combo06 LIKE 'Mem%'
					OR ic.combo06 LIKE 'Data Line -%')
			 AND co.customer_id IN (SELECT customer_id
											  FROM bc_act_view_custs);

COMMENT ON TABLE sysadm.group_share IS 'contract type used by BGH for E-bill';

GRANT SELECT ON sysadm.group_share TO BSCS_ROLE;

CREATE OR REPLACE FORCE VIEW sysadm.cust_mlg_attach_view
(
	customer_id,
	mlg_id,
	mlg_seq,
	mlga_id,
	rec_version
)
AS
	SELECT customer_id, 1, 1, 1, 1 FROM bc_act_view_custs;

CREATE OR REPLACE PUBLIC SYNONYM cust_mlg_attach FOR sysadm.cust_mlg_attach_view;

GRANT SELECT ON sysadm.cust_mlg_attach_view TO bscs_role;

CREATE OR REPLACE FORCE VIEW sysadm.cust_mlg_att_view
(
	custcode,
	customer_id,
	mlg_id,
	mlg_seq,
	mlga_id,
	rec_version
)
AS
	SELECT ca.custcode,
			 c.customer_id,
			 c.mlg_id,
			 c.mlg_seq,
			 c.mlga_id,
			 c.rec_version
	  FROM cust_mlg_attach c, customer_all ca
	 WHERE	  c.customer_id = ca.customer_id
			 AND c.customer_id IN (SELECT customer_id
											 FROM bc_act_view_custs);

CREATE OR REPLACE FORCE VIEW sysadm.cust_mlg_it_view
(
	custcode,
	customer_id,
	mlg_id,
	mlg_seq,
	numcopies,
	processed,
	moddate,
	userlastmod,
	rec_version
)
AS
	SELECT ca.custcode,
			 c.customer_id,
			 c.mlg_id,
			 c.mlg_seq,
			 c.numcopies,
			 c.processed,
			 c.moddate,
			 c.userlastmod,
			 c.rec_version
	  FROM cust_mlg_item c, customer_all ca
	 WHERE	  c.customer_id = ca.customer_id
			 AND c.customer_id IN (SELECT customer_id
											 FROM bc_act_view_custs);


CREATE OR REPLACE TRIGGER mobinil.add_cust_id
	BEFORE INSERT
	ON sysadm.mdsrrtab
	REFERENCING NEW AS new OLD AS old
	FOR EACH ROW
DECLARE
	v_count	 NUMBER;
BEGIN
	SELECT COUNT (1)
	  INTO v_count
	  FROM sysadm.bc_act_view_custs
	 WHERE customer_id = :new.customer_id;

	IF (v_count = 0) THEN
		INSERT INTO sysadm.bc_act_view_custs
			  VALUES (:new.customer_id);
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		NULL;
END add_cust_id;
/

ALTER TRIGGER mobinil.add_cust_id COMPILE DEBUG;
