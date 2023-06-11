// sfdx force:source:deploy --sourcepath ./force-app/main/default/classes/SObjectListToCSVConverter_test.cls
// sfdx apex:run:test --class-names "SObjectListToCSVConverter_test" --code-coverage --synchronous --result-format tap
@IsTest
public with sharing class SObjectListToCSVConverter_test {
    @IsTest
    public static void testConvertToCSV() {
        // Create test data
        List<Account> accounts = new List<Account>();
        for (Integer i = 1; i <= 5; i++) {
            Account acc = new Account(Name = 'Test Account ' + i, Industry = 'Test Industry ' + i, Phone = '123-456-789' + i);
            accounts.add(acc);
        }

        // Convert the list of sObjects to CSV
        String csvString = SObjectListToCSVConverter.convertToCSV(accounts);

        System.debug(csvString);

        // Verify the CSV content
        String[] csvLines = csvString.split('\n');
        
        // Verify the header line
        String[] headerFields = csvLines[0].split(',');
        System.assertEquals('Name,Industry,Phone', csvLines[0]);
        
        // Verify the data lines
        for (Integer i = 0; i < accounts.size(); i++) {
            String[] dataFields = csvLines[i+1].split(',');
            for (Integer j = 0; j < dataFields.size(); ++j) {
                if (dataFields[j].startsWith('"') && dataFields[j].endsWith('"')) {
                    dataFields[j] = dataFields[j].removeEnd('"').removeStart('"');
                }
            }
            System.assertEquals(accounts[i].Name, dataFields[0]);
            System.assertEquals(accounts[i].Industry, dataFields[1]);
            System.assertEquals(accounts[i].Phone, dataFields[2]);
        }
    }
}