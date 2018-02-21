CREATE OR REPLACE TRIGGER trg_pass_pec_requests
   AFTER INSERT
   ON sysadm.mdsrrtab
   REFERENCING NEW AS new OLD AS old
   FOR EACH ROW
BEGIN
   IF (    :new.userid = 'PEC'
       AND :new.switch_id != 'BYPASS'
       AND :new.parent_request IS NULL
       AND (:new.provisioning_flag != 'N' OR :new.provisioning_flag IS NULL))
   THEN
      UPDATE sysadm.mdsrrtab
         SET status = 15
       WHERE request = :new.request;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
/