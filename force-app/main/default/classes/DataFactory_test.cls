/**
 * @description Test de la Factoría de datos para test de Apex. 

sfdx force:source:deploy --sourcepath ./force-app/main/default/classes/DataFactory_test.cls

sfdx force:data:soql:query --json --query "SELECT Id, CaseNumber, Status, Priority, Origin, Subject, Description, CreatedDate, Contact.Name FROM Case WHERE (Contact.Email = 'asong@uog.com' OR Contact.
Phone = '(212) 842-5500') AND CreatedDate >= LAST_N_DAYS:365"
 */
@isTest
public with sharing class DataFactory_test {
    @isTest(SeeAllData=false) static void createAccountDataForTests() {
        
        Test.startTest();
       
        Account[] accts = DataFactory.createAccountsWithContactsCasesAndOpps(
            2,  // numBusinessAccounts
            1,  // numContactsPerAcct
            4,  // numCasesPerContact
            1); // numOppsPerAcct

        Test.stopTest();

        System.assertNotEquals(null, accts);
        System.assertEquals(2, accts.size());
    }

    
    @isTest(SeeAllData=false) static void createAccountDataAccessingRecordsForTests() {
        
        Test.startTest();
       
        DataFactory.Seed = 100;
        DataFactory.CreateAccountsWithContactsCasesAndOpps inst = new DataFactory.CreateAccountsWithContactsCasesAndOpps(
            2,   // numBusinessAccounts
            1,   // numContactsPerAcct
            4,   // numCasesPerContact
            1 ); // numOppsPerAcct

        Test.stopTest();
        

        System.assertNotEquals(null, inst);
        System.assertEquals(8, inst.cases.size());
        System.assertNotEquals(null, inst.cases[0].Account.Id);
    }

    @isTest static void createUserDataForTests() {

        Test.startTest();
       
        User[] users = DataFactory.createUsers(3);

        Test.stopTest();

        System.assertNotEquals(null, users);
        System.assertEquals(3, users.size());
    }
}
