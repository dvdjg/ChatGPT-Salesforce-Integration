/**
 * @description Factoría de datos para test de Apex. 
 * 
 * Basada en:
 * https://trailhead.salesforce.com/content/learn/modules/apex_testing/apex_testing_data
 * https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_utility_classes.htm
 * 
 * Otros enlaces de interés:
 * https://www.apexhours.com/test-data-factory-in-salesforce/
 * https://github.com/benahm/TestDataFactory/blob/master/force-app/main/default/classes/TestDataFactory.cls
 *
 * 
    sfdx force:source:deploy --sourcepath ./force-app/main/default/classes/DataFactory.cls
 */
@isTest
public with sharing class DataFactory {

    // Constantes y literales
    //private static final String RT_PERSON_ACCOUNT_DEVELOPER_NAME = '';
    //private static final String RT_BUSINESS_ACCOUNT_DEVELOPER_NAME = '';
    // private static final String OPPORTUNITY_STAGE = '';

    public static Integer Seed = 0;

    public static List<Account> createAccountsWithContactsCasesAndOpps(Integer numBusinessAccounts, Integer numContactsPerAcct, Integer numCasesPerPerson, Integer numOppsPerAcct) {
        CreateAccountsWithContactsCasesAndOpps inst = new CreateAccountsWithContactsCasesAndOpps(numBusinessAccounts, numContactsPerAcct, numCasesPerPerson, numOppsPerAcct);
        return inst.accs;
    }

    public class CreateAccountsWithContactsCasesAndOpps {

        public List<Account> accs = new List<Account>();
        //public List<Account> accsPerson = new List<Account>();
        public List<Account> accsBusiness = new List<Account>();
        public List<Opportunity> opps = new List<Opportunity>();
        public Contact[] contacts = new Contact[] {};
        public Case[] cases = new Case[] {};

        public  CreateAccountsWithContactsCasesAndOpps(Integer numBusinessAccounts, Integer numContactsPerBusiness, Integer numCasesPerPerson, Integer numOppsPerPerson) {

            //Id personAccountRecordTypeId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(RT_PERSON_ACCOUNT_DEVELOPER_NAME)?.getRecordTypeId();
            //Id businessAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(RT_BUSINESS_ACCOUNT_DEVELOPER_NAME)?.getRecordTypeId();

            String OPPORTUNITY_STAGE;
            if (numOppsPerPerson > 0) {
                List<String> stages = getOpportunityStagePicklistValues();
                OPPORTUNITY_STAGE = stages.get(0);
            }
            /*
            // Person accounts antes que los Business accounts
            for(Integer i=0; i<numPersonAccounts; i++) {
                Account a = new Account(
                    RecordTypeId = personAccountRecordTypeId,                    
                    FirstName = 'FirstName-' + i + Seed,
                    LastName = 'LastName-' + i + Seed,
                    PersonEmail = 'first.last-'+ i + Seed +'@domain.com',
                    Phone = String.valueOf(665000000 + i + Seed)
                );
                accsPerson.add(a);
            }
            */

            for(Integer i=0; i<numBusinessAccounts; i++) {
                Account a = new Account(
                    //RecordTypeId = businessAccountRecordTypeId,
                    Name='Business Account ' + i + Seed,
                    Phone = String.valueOf(666000000 + i + Seed)
                );
                accsBusiness.add(a);
            }

            //accs.addAll(accsPerson);
            accs.addAll(accsBusiness);
            insert accs;

            // Añade oportunidades a las cuentas personales
            for (Integer j=0; j<numBusinessAccounts; j++) {
                Account acct = accsBusiness[j];
                for (Integer k=0; k<numOppsPerPerson; k++) {
                    opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                                        StageName=OPPORTUNITY_STAGE,
                                        CloseDate=System.today().addMonths(1),
                                        Account=acct,
                                        AccountId=acct.Id));
                }
            }
            insert opps;

            // Añade casos a las cuentas personales
            for (Integer i = 0; i < numBusinessAccounts; i++) {
                for (Integer k = 0; k < numCasesPerPerson; k++) {
                    cases.add(new Case(
                        Subject='Subject for Case-' + i + Seed + '.' + k,
                        Account = accsBusiness[i],
                        AccountId = accsBusiness[i].Id
                        //ContactId = accsBusiness[i].PersonContactId,
                        ));
                }
            }
            insert cases;

            // Añade contactos a las cuentas de empresa
            for (Integer i = 0; i < numBusinessAccounts; i++) {
                for (Integer j = 0; j < numContactsPerBusiness; j++) {
                    contacts.add(new Contact(
                        FirstName = 'FirstName-' + i + Seed + '.' + j,
                        LastName = 'LastName-' + i + Seed + '.' + j,
                        Account = accsBusiness[i],
                        AccountId = accsBusiness[i].Id,
                        Email = 'first.last-'+ i + Seed + '.'+ j +'@domain.com'
                        ));
                }
            }
            insert contacts;
        }
    }


    public static User[] createUsers(Integer numUsers) {
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
        return createUsers(numUsers, r.Id);
    }

    public static User[] createUsers(Integer numUsers, Id userRoleId) {
        User[] users = new User[]{};
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        for(Integer i=0;i<numUsers;i++) {
            User u = new User(Alias = 'stand'+i, Email='standarduser'+i+'@mapfre.com', 
                EmailEncodingKey='UTF-8', LastName='Testing'+i, LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = userRoleId, 
                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser'+i+'@mapfre.com');
            users.add(u);
        }
        insert users;
        return users;
    }
    
    public static List<String> getOpportunityStagePicklistValues() {
        List<String> picklistValues = new List<String>();

        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry entry : picklistEntries) {
            picklistValues.add(entry.getLabel());
        }

        return picklistValues;
    }
}