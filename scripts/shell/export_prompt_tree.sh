sfdx force:data:tree:export -q "SELECT Name, ConversationId__c, (SELECT Name, role__c, content__c FROM AI_Roles_And_Contents__r) FROM AI_obj_Conversation__c ORDER BY CreatedDate" -d ./config/data/prompts edemoDjg --prefix prompt --plan