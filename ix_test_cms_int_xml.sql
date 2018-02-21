--Change bill medium

/* 
    Actions:
    1 = customer and contracts creation
    2 = contract creation
    3 = delete list of services
    4 = create list of services
    5 = suspend contract
    6 = reactivate contract
    7 = deactivate contract
    8 = invoice payment (CE2IN-X2)
    9 = advance payment
    10 = deposit payment
    11 = OCC
    12 = invoice payment (CE2IN-X1)
    13 = advance payment (for OCC)
    14 = create further charge (CR-FC)
    15 = contract service package modification
    16 = activate contract
    17 = move family member (not available for BSCS v8)
    18 = modify customer information
    19 = large account creation
    20 = tickler creation
    21 = modify contract information
    22 = convert from LA to flat customer
    23 = modify service parameters
    24 = set itemize bill
*/

DECLARE
   rc   INTEGER;
BEGIN
   rc :=
      mobinil.common.add_cms_int_request (
         1,
         '<?xml version="1.0"?>
<customer xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <is_business_partner>false</is_business_partner>
    <occ_rate_plan_code>163</occ_rate_plan_code>
    <price_group_code>2</price_group_code>
    <family_id>1</family_id>
    <cost_center>1</cost_center>
    <billing_cycle>01</billing_cycle>
    <address>
        <roles>
            <role>B</role>
        </roles>
        <custtype>C</custtype>
        <first_name/>
        <middle_name/>
        <last_name>MultiMass</last_name>
        <full_name/>
        <title>1</title>
        <email/>
        <sms_no/>
        <job_desc/>
        <cctn/>
        <cctn_area/>
        <cctn2/>
        <cctn2_area/>
        <fax/>
        <fax_area/>
        <remark/>
        <street/>
        <house_no/>
        <zip_code/>
        <city>Cairo</city>
        <state/>
        <country_id>1</country_id>
        <language>2</language>
        <address_note_1/>
        <address_note_2/>
        <address_note_3/>
        <nationality>1</nationality>
        <company_reg_no>0</company_reg_no>
        <company_tax_no>0</company_tax_no>
        <is_employee>false</is_employee>
    </address>
    <payment_arrangement>
        <payment_method_id>-1</payment_method_id>
        <account_no/>
        <account_owner/>
        <bank_name/>
        <bank_zip/>
        <bank_city/>
        <swift/>
    </payment_arrangement>
    <contract>
        <status>1</status>
        <status_reason>6</status_reason>
        <device>
            <storage_medium_number>8920013101990424402F</storage_medium_number>
        </device>
        <rate_plan_code>163</rate_plan_code>
        <network_code>68</network_code>
        <market_code>1</market_code>
        <submarket_code>1</submarket_code>
        <call_detail>P</call_detail>
        <billing_medium>1</billing_medium>
        <service>
            <sncode>1</sncode>
            <service_package_code>307</service_package_code>
            <directory_number main="true" npcode="1" create_if_unexisting="false">1222161873</directory_number>
        </service>
        <service>
            <sncode>154</sncode>
            <service_package_code>157</service_package_code>
        </service>
        <service>
            <sncode>11</sncode>
            <service_package_code>19</service_package_code>
            <parameter>
                <id>24</id>
                <no>1</no>
                <value>2</value>
                <des>N</des>
            </parameter>
        </service>
        <service>
            <sncode>36</sncode>
            <service_package_code>19</service_package_code>
        </service>
        <service>
            <sncode>9</sncode>
            <service_package_code>19</service_package_code>
        </service>
        <service>
            <sncode>8</sncode>
            <service_package_code>19</service_package_code>
        </service>
        <service>
            <sncode>2</sncode>
            <service_package_code>19</service_package_code>
        </service>
        <service>
            <sncode>29</sncode>
            <service_package_code>19</service_package_code>
        </service>
        <service>
            <sncode>54</sncode>
            <service_package_code>19</service_package_code>
        </service>
        <service>
            <sncode>20</sncode>
            <service_package_code>19</service_package_code>
        </service>
    </contract>
</customer>
');
END;

/* 
    Status:
    2 = to be processed 
    99 = being processed 
    1 = OK 
    0 = KO
    3 = GMD based request is temporary stopped
*/

SELECT MAX (request_id) FROM alcatel.cms_int_view;

SELECT *
  FROM alcatel.cms_int_view
 WHERE request_id > 590708160;

EDIT ALCATEL.CMS_INT_NETWORK WHERE request_id >= 590708165;

SELECT *
  FROM alcatel.batch_record
 WHERE batch_number = 133034;

  SELECT *
    FROM alcatel.cms_int_history
   WHERE request_id > 590708160
ORDER BY 1 DESC;

EDIT mdsrrtab order by 2 desc;

  SELECT *
    FROM gmd_request_history
   WHERE request > 691974506
ORDER BY 1 DESC;

  SELECT *
    FROM alcatel.cms_int_failed
   WHERE request_id > 589022826
ORDER BY 1 DESC;