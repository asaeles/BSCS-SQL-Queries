  SELECT MH.PARENT, MH.GRPPERM, m.*
    FROM (    SELECT mh.parent, mh.child, mh.grpperm, ROWNUM rn
                FROM modules_hierarchy mh
          CONNECT BY PRIOR child = parent
          START WITH parent IN (SELECT DISTINCT mhi.parent
                                  FROM modules_hierarchy mhi
                                 WHERE     mhi.parent LIKE '0_CX_%'
                                       AND NOT EXISTS
                                              (SELECT *
                                                 FROM modules_hierarchy
                                                WHERE child = mhi.parent))) mh,
         modules m
   WHERE m.modulename = mh.child
ORDER BY mh.rn;