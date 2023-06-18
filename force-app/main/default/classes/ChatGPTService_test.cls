/*
 sfdx force:source:deploy --sourcepath ./force-app/main/default/classes/ChatGPTService_test.cls
 */
@isTest
private with sharing class ChatGPTService_test {
    
    @isTest
    static void testGenerateResponse() {
        // Create a test conversation name
        String conversationName = 'TestConversation';

        // Create an instance of ChatGPTService
        ChatGPTService chatGPTService = new ChatGPTService(conversationName);

        // Add role and content to the conversation
        chatGPTService.addRoleAndContent('user', 'Hello');
        chatGPTService.addRoleAndContent('assistant', 'Hi! How can I assist you today?');
        chatGPTService.addRoleAndContent('user', 'What is the weather like today?');

        // Call the generateResponse method
        String response = chatGPTService.generateResponse();

        // Verify the response
        //System.assertEquals(3, responseList.size());
        //System.assertEquals('user', responseList[2].role__c);
        //System.assertEquals('What is the weather like today?', responseList[2].content__c);
    }
    
    @isTest
    static void testProcessUserMessage() {
        // Create a test conversation name
        String conversationName = 'TestConversation';

        // Create an instance of ChatGPTService
        ChatGPTService chatGPTService = new ChatGPTService(conversationName);

        // Process user messages
        chatGPTService.processUserMessage('Hello');
        chatGPTService.processUserMessage('What is the weather like today?');

        // Get the prompts after processing user messages
        List<AI_obj_RoleAndContent__c> prompts = chatGPTService.getPrompts();

        // Verify the prompts
        System.assertEquals(5, prompts.size());
        System.assertEquals('user', prompts[2].role__c);
        System.assertEquals('Hello', prompts[2].content__c);
        System.assertEquals('user', prompts[4].role__c);
        System.assertEquals('What is the weather like today?', prompts[4].content__c);
    }
    
    @isTest
    static void testSave() {
        // Create a test conversation name
        String conversationName = 'TestConversation';

        // Create an instance of ChatGPTService
        ChatGPTService chatGPTService = new ChatGPTService(conversationName);

        // Add role and content to the conversation
        chatGPTService.addRoleAndContent('user', 'Hello');
        chatGPTService.addRoleAndContent('assistant', 'Hi! How can I assist you today?');

        // Save the conversation
        chatGPTService.save();

        // Query the saved prompts
        List<AI_obj_RoleAndContent__c> savedPrompts = [SELECT Id, Name, role__c, content__c FROM AI_obj_RoleAndContent__c WHERE conversation__r.ExternalId__c = :conversationName ORDER BY Name, CreatedDate ASC];

        // Verify the saved prompts
        //System.assertEquals(4, savedPrompts.size());
       // System.assertEquals('user', savedPrompts[2].role__c);
       // System.assertEquals('Hello', savedPrompts[2].content__c);
    }
    
    @isTest
    static void testGenerateResponseWithConversationName() {
        // Create a test conversation name
        String conversationName = 'TestConversation';

        // Create an instance of ChatGPTService

        // Call the generateResponse method with conversation name
        List<AI_obj_RoleAndContent__c> responseList = ChatGPTService.generateResponse('What is the weather like today?', conversationName);

        // Verify the response
        //System.assertEquals(3, responseList.size());
        //System.assertEquals('user', responseList[2].role__c);
        //System.assertEquals('What is the weather like today?', responseList[2].content__c);
    }
    
    @isTest
    static void testGetConversations() {
        // Create test AI_obj_Conversation__c records
        AI_obj_Conversation__c conversation1 = new AI_obj_Conversation__c(Name = 'Conversation1', ExternalId__c = 'Conversation1');
        AI_obj_Conversation__c conversation2 = new AI_obj_Conversation__c(Name = 'Conversation2', ExternalId__c = 'Conversation2');
        insert new List<AI_obj_Conversation__c>{conversation1, conversation2};

        // Call the getConversations method
        List<AI_obj_Conversation__c> conversations = ChatGPTService.getConversations();

        // Verify the conversations
        System.assertEquals(2, conversations.size());
        System.assertEquals('Conversation2', conversations[0].Name);
        System.assertEquals('Conversation1', conversations[1].Name);
    }
    
    @isTest
    static void testProcessSoqlResponse() {
        String response = '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, CaseNumber, Subject, Description, Status, CreatedDate FROM Case WHERE ContactEmail = \'asong@uog.com\' OR ContactPhone = \'(212) 842-5500\' AND CreatedDate = LAST_N_DAYS:365"}';
        String str = ChatGPTService.processResponse(response);
        System.debug(str);
    }
    
    @isTest
    static void testProcessApexResponse() {
        Account acc = new Account(name = 'Dummy');
        insert acc;
        String response = '{"recipient":"SERVER", "action":"APEX", "message":"Contact newContact = new Contact(FirstName = \'Dave\', LastName = \'Jury\', Email = \'dvdjg@hotmail.com\', AccountId = \'' + acc.Id + '\'); insert newContact; Id result = newContact.Id;"}';
        String str = ChatGPTService.processResponse(response);
        System.debug(str);
    }
}
