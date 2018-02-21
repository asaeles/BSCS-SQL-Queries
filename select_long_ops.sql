select S.USERNAME, s.sid, s.osuser, t.sql_id, sql_text
from v$sqltext_with_newlines t,V$SESSION s
where t.address =s.sql_address
and t.hash_value = s.sql_hash_value
and s.status = 'ACTIVE'
and s.username <> 'SYSTEM'
order by s.sid,t.piece;

select
  object_name, 
  object_type, 
  session_id, 
  type,         -- Type or system/user lock
  lmode,        -- lock mode in which session holds lock
  request, 
  block, 
  ctime         -- Time since current mode was granted
from
  v$locked_object, all_objects, v$lock
where
  v$locked_object.object_id = all_objects.object_id AND
  v$lock.id1 = all_objects.object_id AND
  v$lock.sid = v$locked_object.session_id
order by
  session_id, ctime desc, object_name;

COLUMN percent FORMAT 999.99 

SELECT s.sid, TO_CHAR(start_time, 'hh24:mi:ss') stime,
TO_CHAR(SYSDATE, 'hh24:mi:ss') cur,
TO_CHAR(TO_DATE('1970', 'rrrr')+(SYSDATE-start_time)/sofar*totalwork, 'hh24:mi:ss') dur,
TO_CHAR(start_time+(SYSDATE-start_time)/sofar*totalwork, 'hh24:mi:ss') eta,
message,sofar/totalwork*100 percent
FROM v$session s, v$session_longops l
WHERE l.sid = s.sid
AND sofar/totalwork < 1
--AND s.osuser = 'ashahawy'
AND l.sid IN (
   SELECT s.sid
   FROM v$sqltext_with_newlines t, v$session s
   WHERE t.address = s.sql_address
   AND t.hash_value = s.sql_hash_value
   AND s.status = 'ACTIVE'
   AND s.username <> 'SYSTEM'
   AND LOWER(sql_text) LIKE '%paral%'
);
