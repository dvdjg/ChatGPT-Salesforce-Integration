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
public with sharing class ChatGPTService {
    //private static final String API_KEY = System.label.chatGPTAPIKey; // Replace with your actual API key
    //private static final String ENDPOINT_URL = 'https://api.openai.com/v1/chat/completions';
    private static final String MODEL = 'gpt-3.5-turbo';

    /**
     * @description Method to generate response from ChatGPT
     */
    @AuraEnabled(cacheable=false)
    public static List<AI_obj_RoleAndContent__c> generateResponse(String messageText, String conversationName) {

        List<AI_obj_RoleAndContent__c> lstContentsToSave = new List<AI_obj_RoleAndContent__c>();
        List<AI_obj_RoleAndContent__c> lstContents = [SELECT Id, Name, role__c, content__c, conversation__r.Id FROM AI_obj_RoleAndContent__c WHERE conversation__r.ConversationId__c=:conversationName ORDER BY CreatedDate ASC];

        List<Object> lstPrompts = new List<Object>();
        Id conversationId;
        Boolean noContents = lstContents.size() == 0;

        if (noContents) {
            AI_obj_RoleAndContent__c prompt = new AI_obj_RoleAndContent__c(Name = 'system', role__c = 'system', content__c = 'You are a helpful assistant.');
            lstContents.add(prompt);
            lstContentsToSave.add(prompt);
        } else {
            conversationId = lstContents.get(0).conversation__c;
        }

        AI_obj_RoleAndContent__c prompt = new AI_obj_RoleAndContent__c(Name = 'user', role__c = 'user', content__c = messageText);
        lstContents.add(prompt);
        lstContentsToSave.add(prompt);

        for (AI_obj_RoleAndContent__c content : lstContents) {
            Map<String, Object> promptBody = new Map<String, Object>{'role' => content.role__c, 'content' => content.content__c};
            lstPrompts.add(promptBody);
        }
        
        String response = 'Okok'; //generateResponse(lstPrompts);
        prompt = new AI_obj_RoleAndContent__c(Name = 'assistant', role__c = 'assistant', content__c = response);
        lstContents.add(prompt);
        lstContentsToSave.add(prompt);

        if (noContents) {
            AI_obj_Conversation__c conversation = new AI_obj_Conversation__c(Name = conversationName, ConversationId__c = conversationName);
            upsert conversation ConversationId__c;
            conversationId = conversation.Id;
        }

        for (AI_obj_RoleAndContent__c content : lstContentsToSave) {
            content.conversation__c = conversationId;
        }
        insert lstContentsToSave;

        return lstContents;
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