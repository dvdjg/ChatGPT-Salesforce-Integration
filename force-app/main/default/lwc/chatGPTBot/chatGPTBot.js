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
/*
sfdx force:source:deploy --sourcepath ./force-app/main/default/lwc/chatGPTBot/chatGPTBot.js-meta.xml
 */
import { LightningElement, track, wire, api } from 'lwc';
import generateResponse from '@salesforce/apex/ChatGPTService.generateResponse';
import getConversations from '@salesforce/apex/ChatGPTService.getConversations';

const DEF_CONV = 'First';
const KEY_ENTER = 13;

export default class ChatGPTBot extends LightningElement {
    @track conversations = [];
    @track conversation = [];
    @track messageInput = '';
    @track strConversation = DEF_CONV;
    @track inputConversation;
    @track error;

    handleInputConversationChange(event) {
        this.inputConversation = event.detail.value;
    }

    async keyCheckConversation(component) {
        if (component.which == KEY_ENTER) {
            this.strConversation = this.inputConversation;
            this.conversation = await this.responseUserMessage(this.messageInput, this.strConversation);
            this.messageInput = '';
        }
    }

    async keyCheckMessage(component) {
        if (component.which == KEY_ENTER) {
            this.conversation = await this.responseUserMessage(this.messageInput, this.strConversation);
            this.messageInput = '';
        }
    }

    async handleChangeConversation(event) {
        // Get the string of the "value" attribute on the selected option
        if (event && event.detail) {
            this.strConversation = event.detail.value;
            this.conversation = await this.responseUserMessage(this.messageInput, this.strConversation);
            this.messageInput = '';
        }
    }

    // initialize component
    async connectedCallback() {
        await this.init();
    }

    async init() {
        try {
            const data = await getConversations();
            this.conversations = data.map((r, i) => (
                {
                    value: r.ExternalId__c,
                    label: r.ExternalId__c,
                    description: r.Name + ' (' + r.PromptCount__c + ')',
                }
            ));
            this.error = undefined;
            if (this.conversations.length > 0) {
                this.strConversation = this.conversations[0].value;
            }
            this.conversation = await this.responseUserMessage(this.messageInput, this.strConversation);
            this.messageInput = '';
        } catch (error) {
            console.error('Error retrieving conversaions: ', error);
            this.error = error;
            this.conversations = [{
                value: DEF_CONV,
                label: DEF_CONV,
                description: DEF_CONV + ' (0)',
            }];
        }
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
            const chatGPTResponses = await generateResponse({ messageText: messageInput, conversationName });
            conversation = chatGPTResponses.map((r, i) => {
                const created = new Date(r.CreatedDate);
                const isBot = r.role__c != 'user';
                const type = r.role__c != 'user' ? 'inbound' : 'outbound'; // 'inbound', 'outbound', 'event', 'bookend';
                const options = {
                    weekday: "long",
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                    hour: 'numeric',
                    minute: 'numeric',
                    second: 'numeric',
                  };
                const meta = (isBot ? 'GPT ('+r.role__c+')' : r.CreatedBy?.Name ? r.CreatedBy.Name : 'USER') + ' • ' + created.toLocaleDateString("es-ES", options);
                return {
                    id: r.Id,
                    role: r.role__c,
                    text: r.content__c,
                    type: type,
                    liClass: 'slds-chat-listitem slds-chat-listitem_'+type,
                    messageClass: 'slds-chat-message__text slds-chat-message__text_'+type,
                    metaLabel: 'said '+meta,
                    meta
                }
            });
            const scrollArea = this.template.querySelector('.slds-scrollable_y');
            scrollArea.scrollTop = scrollArea.scrollHeight;
            this.error = undefined;
        } catch (error) {
            console.error('Error generating ChatGPT response: ', error);
            this.error = error;
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