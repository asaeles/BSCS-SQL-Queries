SELECT dn_num, hlcode,
       TO_NUMBER(SUBSTR(dn_num, 1, 2), 'xx') || '.' || 
       TO_NUMBER(SUBSTR(dn_num, 3, 2), 'xx') || '.' || 
       TO_NUMBER(SUBSTR(dn_num, 5, 2), 'xx') || '.' || 
       TO_NUMBER(SUBSTR(dn_num, 7, 2), 'xx') ip
FROM directory_number
WHERE dirnum_npcode = 22
AND dn_status = 'r';
