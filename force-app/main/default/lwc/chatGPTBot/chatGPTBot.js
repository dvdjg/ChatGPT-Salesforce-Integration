/*
 * Copyright  2023  , Author - Jitendra Zaa
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
 * @email           jitendra.zaa+30@gmail.com
 * @description   TBD
 */
import { LightningElement, track, api } from 'lwc';
import generateResponse from '@salesforce/apex/ChatGPTService.generateResponse';

export default class ChatGPTBot extends LightningElement {
    @track conversation = [];
    @track messageInput = '';
    @track strConversation = 'FirstContact';

    // initialize component
    async connectedCallback() {
        this.conversation = await this.responseUserMessage(this.messageInput, this.strConversation);
    }

    handleChange(event) {
        if (event && event.target) {
            this.messageInput = event.target.value;
        }
    }

    async handleSendMessage() {
        if (this.messageInput) {
            this.conversation = await this.responseUserMessage(this.messageInput, this.strConversation);
            this.messageInput = '';
        }
    }

    async responseUserMessage(messageInput, conversationName) { 
        let conversation = [];       
        try {
            const chatGPTResponses = await generateResponse({ messageText: messageInput, conversationName});
            conversation = chatGPTResponses.map((r, i) => ({
                id: 'PROMPT-' + i,
                role: r.role__c,
                text: r.content__c,
                containerClass: (r.role__c == 'user') ? 'slds-chat-message slds-chat-message_outbound user-message' : 'slds-chat-message slds-chat-message_inbound',
                textClass: (r.role__c == 'user') ? 'slds-chat-message__text slds-chat-message__text_outbound' : 'slds-chat-message__text slds-chat-message__text_inbound',
                isBot: r.role__c != 'user'
            }));
        } catch (error) {
            console.error('Error generating ChatGPT response:', error);
        }
        return conversation;
    }

    /*
    @api
    async generateChatGPTResponse(messageInput, conversationName) {
        try {
            const response = await generateResponse({ messageText: messageInput, conversationName});
            return response;
        } catch (error) {
            console.error('Error: Unable to generate response from ChatGPT.', error);
            return 'Error: Unable to generate response from ChatGPT.';
        }
    }
    */
}
