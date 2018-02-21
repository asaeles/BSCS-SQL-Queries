SELECT *
  FROM app_modules
 WHERE TRIM (params) IS NOT NULL;

SELECT * FROM billing_config;

SELECT * FROM mpdsctab;

SELECT * FROM mpscftab;

SELECT * FROM bscsproject_all;

SELECT * FROM app_program;

SELECT * FROM mpuhftab;

SELECT * FROM data_domain;

SELECT * FROM data_class;

SELECT * FROM scheduled_job;

SELECT * FROM bscshints;

SELECT * FROM rounding_strategy;

  SELECT *
    FROM call_detail_info
ORDER BY 1, 2;