  SELECT u.name,
         DECODE (o.type#,  1, 'KEY',  2, 'TABLE', 4, 'VIEW', 5, 'SYNONEM',  6, 'SEQUENCE', 
         7, 'PROCEDURE',  8, 'FUNCTION',  9, 'PACKAGE',  11, 'PACKAGE BODY',
         12, 'TRIGGER',  13, 'TYPE',  14, 'TYPE BODY',  o.type#) TYPE,
         o.*, s.source
    FROM sys.obj$ o, sys.user$ u, sys.source$ s
   WHERE     u.user# = o.owner#
         AND s.obj#(+) = o.obj#
         --AND s.line(+) = 3
         --AND o.type# = 4
         AND u.name IN ('SYSADM', 'MOBINIL', 'ALCATEL', 'ALU', 'ALCATELDB')
         --AND (LOWER (s.source) LIKE 'on %' or LOWER (s.source) LIKE '% on %')
         AND LOWER (s.source) LIKE '%dispatch%'
         --AND LOWER (o.name) LIKE 'info%'
         --AND LOWER (o.name) LIKE '%auto%'
         --AND o.ctime > '01-03-2010'
ORDER BY 1, 2;