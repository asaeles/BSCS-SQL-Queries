/* Formatted on 2011/07/14 13:04 (Formatter Plus v4.8.7) */
CREATE TABLE ash_temp_co_id AS (
SELECT co.co_id, co.Ch_Status, co.ch_status_validfrom, co.tmcode,
       co.customer_id, co.tmcode_date
  FROM CONTRACT_ALL co
 WHERE co.tmcode IN (
	      29,30,31,32,33,34,36,37,38,41,42,45,54,57,59,71,72,73,75,76,78,79,
	      80,81,82,83,84,85,86,87,88,89,90,91,93,94,95,96,97,98,99,100,101,
	      102,103,107,108,109,110,111,112,113,114,115,116,118,121,122,123,
	      124,125,129,134,135,136,138,139,143,147,148,149,150,151,165,166
      )
   AND co.Ch_Status <> 'd');

SELECT COUNT (*)
  FROM ash_temp_co_id;

--1007798

CREATE TABLE ash_temp_co_id_2 AS (
SELECT co.co_id, ps.status_histno
  FROM ash_temp_co_id co, PROFILE_SERVICE ps
 WHERE ps.co_id = co.co_id AND ps.sncode = 135);

SELECT COUNT (*)
  FROM ash_temp_co_id_2;

--215357

CREATE TABLE ash_temp_co_id_3 AS (
SELECT ps.co_id
  FROM ash_temp_co_id_2 ps, PR_SERV_STATUS_HIST psh
 WHERE psh.co_id = ps.co_id
   AND psh.histno = ps.status_histno
   AND psh.sncode = 135
   AND psh.status = 'A');

SELECT COUNT (1)
  FROM ash_temp_co_id_2 ps, PR_SERV_STATUS_HIST psh
 WHERE psh.co_id = ps.co_id
   AND psh.histno = ps.status_histno
   AND psh.sncode = 135
   AND psh.status = 'A';

--215357
