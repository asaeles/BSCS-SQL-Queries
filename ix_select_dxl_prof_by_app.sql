   SELECT am.app_program_id, am.app_program_name, dp.process_id,
         dp.application_name, dpp.dxl_profile_id, DPP.PROCESS_PROFILE_DES
    FROM app_program am, dxl_process dp, dxl_process_profile dpp
   WHERE     dp.app_program_id = am.app_program_id
         AND dpp.process_id = dp.process_id
         AND app_program_name IN ('bch', 'bgh')
ORDER BY am.app_program_id, dp.process_id, dpp.dxl_profile_id;
