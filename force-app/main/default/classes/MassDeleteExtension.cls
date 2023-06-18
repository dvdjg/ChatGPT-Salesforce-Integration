// Extension to delete all of the selected objects
public with sharing class MassDeleteExtension {

    ApexPages.StandardSetController setCon;
    public String error { get; set; }
    public PageReference originalUrl { get; set; }

    public MassDeleteExtension(ApexPages.StandardSetController controller) {
        setCon = controller;
    }

    public String getMySelectedSize() {
        return setCon.getSelected().size() + '';
    }
    
    public PageReference deleteRecords(){
        originalUrl = setCon.cancel();
        System.debug(setCon.getSelected());
        System.debug([SELECT Id, Name, conversation__c FROM AI_obj_RoleAndContent__c WHERE Id IN :setCon.getSelected()]);

        delete [SELECT Id, Name, conversation__c FROM AI_obj_RoleAndContent__c WHERE Id IN :setCon.getSelected()];
        return originalUrl;
    }

}