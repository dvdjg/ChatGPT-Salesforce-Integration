/*
 * Copyright  2023 , Author - Jitendra Zaa
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *        https://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 *         https://wwww.jitendraZaa.com
 * 
 * @date          March 2023
 * @author        Jitendra Zaa
 * @email         jitendra.zaa+30@gmail.com
 * @description   Apex class to interact with chat GPT Web Service
 */
/*
 sfdx force:source:deploy --sourcepath ./force-app/main/default/classes/ChatGPTService.cls
 */
public with sharing class ChatGPTService {
    private static final String MODEL = 'gpt-3.5-turbo';
    private static final Integer IDX_LEN = 5;
    // private static final String IDX_CONV = 'CV-';
    private static final String IDX_PFX = 'PR-';
    private static final String RESPONSE_USER = 'USER: ';
    private static final String RESPONSE_QUERY = 'QUERY: ';
    private static final String RESPONSE_APEX = 'APEX: ';
    private static final String RESPONSE_ERROR = 'ERROR: ';

    private List<AI_obj_RoleAndContent__c> lstContentsToSave;
    private List<AI_obj_RoleAndContent__c> lstContents;
    
    private String conversationName;
    private String systemMessage = 'You are a helpful assistant.';

    public ChatGPTService(String conversationName) {
        this.conversationName = conversationName;
        lstContentsToSave = new List<AI_obj_RoleAndContent__c>();
        lstContents = [
            SELECT Id, Name, role__c, content__c, conversation__r.Id, CreatedBy.Name, CreatedDate 
            FROM AI_obj_RoleAndContent__c WHERE conversation__r.ExternalId__c=:conversationName ORDER BY Name, CreatedDate ASC
        ];
    }

    public List<AI_obj_RoleAndContent__c> getPrompts() {
        return lstContents;
    }

    public void addRoleAndContent(String role, String content) {
        String name = IDX_PFX + String.valueOf(lstContents.size()).leftPad(IDX_LEN, '0');
        AI_obj_RoleAndContent__c prompt = new AI_obj_RoleAndContent__c(Name = name, role__c = role, content__c = content);
        lstContents.add(prompt);
        lstContentsToSave.add(prompt);
    }

    @TestVisible 
    private String generateResponse() {
        List<Object> lstPromptsToQuery = new List<Object>();
        for (AI_obj_RoleAndContent__c content : lstContents) {
            lstPromptsToQuery.add(new Map<String, Object>{'role' => content.role__c, 'content' => content.content__c});
        }
        String responseJSON = generateResponse(lstPromptsToQuery); // Callout
        return responseJSON;
    }

    public void processUserMessage(String messageText) {
        
        Id conversationId;
        Boolean noContents = lstContents.size() == 0;

        if (noContents) {
            addRoleAndContent('system', systemMessage);
        } else {
            conversationId = lstContents.get(0).conversation__c;
        }

        Integer i = 0;
        while (!String.isBlank(messageText)) {
            addRoleAndContent('user', messageText);
        
            String responseJSON = generateResponse(); // Callout // 'Ok ok: ' + String.valueOf(Datetime.now()); // 
            addRoleAndContent('assistant', responseJSON);

            String response = processResponse(responseJSON);
            if (response.startsWith(RESPONSE_QUERY)) {
                messageText = response.removeStart(RESPONSE_QUERY);
            } else if (response.startsWith(RESPONSE_APEX)) {
                messageText = response.removeStart(RESPONSE_APEX);
            } else if (response.startsWith(RESPONSE_ERROR)) {
                messageText = response;
            } else {
                break; // No issue new query
            }
            if (++i > 5) {
                System.debug('Reached max oppotunities to answer.');
                break;
            }
        }
    }

    @TestVisible 
    private void save() {
        if (!lstContentsToSave.isEmpty()) {
            Id conversationId = lstContents.get(0).conversation__c;
            if (conversationId == null) {
                AI_obj_Conversation__c conversation = new AI_obj_Conversation__c(Name = conversationName, ExternalId__c = conversationName);
                upsert conversation ExternalId__c;
                conversationId = conversation.Id;
            }
        
            for (AI_obj_RoleAndContent__c content : lstContentsToSave) {
                content.conversation__c = conversationId;
            }
            insert lstContentsToSave;
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<AI_obj_RoleAndContent__c> generateResponse(String messageText, String conversationName) {
        ChatGPTService serv = new ChatGPTService(conversationName);
        serv.processUserMessage(messageText);
        serv.save(); // Do DML after the callouts.
        return serv.getPrompts();
    }


    public static String generateResponse(String messageText) {
        List<AI_obj_RoleAndContent__c> lst = generateResponse(messageText, 'FieldsFetcher');
        String response = lst.get(lst.size()-1).content__c;
        return response;
    }

    @AuraEnabled(cacheable=false)
    public static List<AI_obj_Conversation__c> getConversations() {
        List<AI_obj_Conversation__c> response = [SELECT Id, Name, ExternalId__c, PromptCount__c, LastPromptDatetime__c FROM AI_obj_Conversation__c ORDER BY LastPromptDatetime__c DESC];
        return response;
    }

    public class AI_Response {
        public AI_Response() {

        }
        public String recipient;
        public String action;
        public String message;
    }


    @TestVisible 
    private static String processResponse(String response) {
        String ret = response;
        try {
            Integer first = response.indexOf('{');
            Integer last = response.lastIndexOf('}');
            if (first != -1 && last != -1) {
                String cut = response.substring(first, last+1);
                System.debug('cut: ' + cut);
                AI_Response res = (AI_Response)JSON.deserializeStrict(cut, AI_Response.class);
                System.debug('AI_Response: ' + res);
                if (res.recipient == 'USER') {
                    ret = 'USER: ' + res.message;
                } else if (res.recipient == 'SERVER' && res.action == 'QUERY') {
                    List<SObject> queryResults = Database.query(res.message);
                    ret = JSON.serialize(queryResults); //SObjectListToCSVConverter.convertToCSV(queryResults);
                    ret = 'QUERY: ' + ret;
                } else if (res.recipient == 'SERVER' && res.action == 'APEX') {
                    ret = soapSforceCom200608Apex.evalString(res.message + ' System.debug(LoggingLevel.Error, JSON.serialize(result));');
                    ret = 'APEX: ' + ret;
                    System.debug(ret);
                } else {
                    System.debug('Invalid AI_Response.');
                    ret = 'ERROR: Invalid JSON. Plese retry.';
                }
            }
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, 'Exception Stack Trace: ' + e.getStackTraceString());
            ret = 'ERROR: ' + e.getMessage();      
        }
        System.debug('JSON Response: ' + response);
        System.debug('Return Response: ' + ret);
        return ret;
    }

    public static String generateResponse(List<Object> lstPrompts) {
        OpenAI_Config__mdt config = OpenAI_Config__mdt.getInstance('Main');

        String API_KEY = config.api_key__c; // Replace with your actual API key
        String ENDPOINT_URL = config.endpoint__c;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT_URL);
        req.setMethod('POST');
        req.setTimeout(1000*120);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + API_KEY); // Add the API key to the request header


        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('messages', lstPrompts);
        requestBody.put('model', MODEL);
        //requestBody.put('max_tokens', 50);
        //requestBody.put('n', 1);
        //requestBody.put('stop', new List<String>{'\n'});

        req.setBody(JSON.serialize(requestBody));
        System.debug('Request Body: ' + req.getBody());

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            System.debug(res.getBody());
            Map<String, Object> responseBody = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            List<Object> choices = (List<Object>)responseBody.get('choices');
            if (choices.size() > 0) {
                Map<String, Object> choice = (Map<String, Object>)choices.get(0);
                Map<String,Object> mpMessages = (Map<String,Object>)choice.get('message');

                String responseText = (String)mpMessages.get('content');

                responseText = responseText != null ? responseText.trim() : '';
                //system.debug('Response Text: ' + responseText);
                return responseText;
            }
        } else {
            String resp = 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
            System.debug(resp);
            throw new ChatGPTException(resp);
        }

        return '';
    }

    /**
     * @description Custom exception class
     */
    public class ChatGPTException extends Exception {}
}