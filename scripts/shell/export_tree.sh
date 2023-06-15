sfdx force:data:tree:export -q "SELECT Name, ExternalId__c, (SELECT Name, role__c, content__c FROM AI_Roles_And_Contents__r) FROM AI_obj_Conversation__c ORDER BY CreatedDate" -d ./config/data/prompts edemoDjg --prefix prompt --plan
sfdx force:data:tree:import -p./config/data/prompts/prompt-AI_obj_Conversation__c-AI_obj_RoleAndContent__c-plan.json -u resilient-wolf

SELECT Name, ExternalId__c FROM AI_obj_Conversation__c ORDER BY CreatedDate
SELECT conversation__r.ExternalId__c, Name, role__c, content__c FROM AI_obj_RoleAndContent__c ORDER BY conversation__r.ExternalId__c, Name