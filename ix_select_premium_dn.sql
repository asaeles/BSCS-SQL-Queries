SELECT
    dn.dn_id,
    dn.dn_num,
    sn.sncode dn_type,
    DECODE(
        sn.sncode,
        1,
        regexp_replace(
            dn.dn_num,
            '12(\d\d\d)(\d\d\d)(\d\d)',
            '12 \1 \2 \3'
        ),
        2,
        regexp_replace(
            dn.dn_num,
            '12(\d)(\d\d\d)(\d\d\d)(\d)',
            '12 \1 \2 \3 \4'
        ),
        3,
        regexp_replace(
            dn.dn_num,
            '12(\d\d\d)(\d\d\d)(\d\d)',
            '12 \1 \2 \3'
        ),
        4,
        regexp_replace(
            dn.dn_num,
            '12(\d)(\d\d\d)(\d\d\d)(\d)',
            '12 \1 \2 \3 \4'
        ),
        dn.dn_num
    ) dn_fmt,
    dn.dn_status
FROM
    directory_number dn,
    mpusntab sn
WHERE
    dn.hlcode = 58
    AND dn.dn_status IN(
        'r',
        'd'
    )
    AND(
        (
            regexp_like(
                dn.dn_num,
                '12.(.)(.)\2\1\2\2.'
            )
            AND sn.sncode = 4
        )
        OR(
            regexp_like(
                dn.dn_num,
                '12(.)(.)\2\1\2\2(.)(\3|0)'
            )
            AND sn.sncode = 3
        )
        OR(
            regexp_like(
                dn.dn_num,
                '12.(.)(\1\1|00)\1\2.'
            )
            AND sn.sncode = 2
        )
        OR(
            regexp_like(
                dn.dn_num,
                '12(.)(\1\1|00)\1\2(.)(\3|0)'
            )
            AND sn.sncode = 1
        )
    );
