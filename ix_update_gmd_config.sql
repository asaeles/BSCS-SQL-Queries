ALTER TRIGGER sysadm.msdsvtab_biu DISABLE;

UPDATE msdsvtab
   SET HOST = 'td1';

UPDATE msdsvtab
   SET port = 'GMDRRS'
 WHERE srv_id = 'GMDR1';

COMMIT;

ALTER TRIGGER sysadm.msdsvtab_biu ENABLE;

BEGIN
   FOR gd IN (SELECT *
                FROM gmd_destination
               WHERE port != 'GMDPROD')
   LOOP
      BEGIN
         UPDATE gmd_destination
            SET port = 'GMDPROD'
          WHERE vmd_id = gd.vmd_id AND HOST = gd.HOST AND port = gd.port;
      EXCEPTION
         WHEN OTHERS
         THEN
            DELETE FROM gmd_destination
                  WHERE     vmd_id = gd.vmd_id
                        AND HOST = gd.HOST
                        AND port = gd.port;
      END;
   END LOOP;

   COMMIT;
END;
/

EXIT;
