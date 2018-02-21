/* Formatted on 5/2/2012 1:26:19 PM (QP5 v5.185.11230.41888) */
UPDATE alcatel.batch_process_config
   SET config =
             SUBSTR (config, 1, INSTR (config, '</ConfigList>') - 1)
          || '<fileconfig>
<type>Exempt_Ann_Stamps</type>
<separator>;</separator>
<searchKey>Custcode</searchKey>
<searchKeyPosition>1</searchKeyPosition>
<MappingList>
<mapping>
<fieldNumber>2</fieldNumber>
<domain>additional_info</domain>
<cmsint_map>CHECK11</cmsint_map>
<DataType>Boolean</DataType>
<DefaultValue>X</DefaultValue>
<ActionOnNull>GetDefault</ActionOnNull>
<NullAlias></NullAlias>
<TrueAlias>X</TrueAlias>
</mapping>
</MappingList>
</fileconfig>
</ConfigList>
</config>'
 WHERE process_id = 17 AND INSTR (config, 'Exempt_Ann_Stamps') = 0;
 
 COMMIT;
 
 EXIT;
 