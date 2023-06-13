/*
sfdx force:source:deploy --sourcepath ./force-app/main/default/classes/SObjectListToCSVConverter.cls
*/
public with sharing class SObjectListToCSVConverter {
    /**
     * 
     * @param sObjects 
     * @return  `String`
     * 
        String q = 'SELECT Id, Name, Email, Phone, Account.Name FROM Contact';
        List<SObject> queryResults = Database.query(q);
        String ret =  SObjectListToCSVConverter.convertToCSV(queryResults);
        System.debug(ret);
     */
    public static String convertToCSV(List<sObject> sObjects) {
        return convertToCSV(sObjects, null);
    }
    public static String convertToCSV(List<sObject> sObjects, List<String> fieldNames) {
        String csvContent = '';

        // Extract the field names from the first sObject in the list
        if (!sObjects.isEmpty() && fieldNames == null) {
            sObject firstSObject = sObjects[0];
            Map<String, Object> fieldMap = firstSObject.getPopulatedFieldsAsMap();
            Set<String> fieldNamesSet = fieldMap.keySet();
            // Append the field names as the CSV header
            fieldNames = new List<String>(fieldNamesSet);
        }
        csvContent += String.join(fieldNames, ',') + '\n';

        // Process each sObject in the list
        for (sObject sObj : sObjects) {
            Map<String, Object> fieldMap = sObj.getPopulatedFieldsAsMap();
            List<String> fieldValues = new List<String>();

            // Extract the field values for each field name
            for (String fieldName : fieldMap.keySet()) {
                
                String fieldValue = String.valueOf(fieldMap.get(fieldName));
                if (fieldValue.contains('"') || fieldValue.contains(',')) {
                    // Escape any double quotes within the field value
                    fieldValue = fieldValue.replace('"', '""');
                    // Enclose the field value in double quotes
                    fieldValues.add('"' + fieldValue + '"');
                } else {
                    fieldValues.add(fieldValue);
                /*
                Object sObj1 = fieldMap.get(fieldName);
                if (sObj1 instanceof sObject) {
                    Map<String, Object> fieldMap1 = sObj1.getPopulatedFieldsAsMap();
                    List<String> fieldValues1 = new List<String>();

                    for (String fieldName : fieldMap1.keySet()) {
                        Object sObj2 = fieldMap1.get(fieldName);
                        String fieldValue = String.valueOf(sObj2);
                        if (fieldValue.contains('"') || fieldValue.contains(',')) {
                            // Escape any double quotes within the field value
                            fieldValue = fieldValue.replace('"', '""');
                            // Enclose the field value in double quotes
                            fieldValues1.add('"' + fieldValue + '"');
                        } else {
                            fieldValues1.add(fieldValue);
                        }
                    }
                } else {
                    String fieldValue = String.valueOf(sObj1);
                    if (fieldValue.contains('"') || fieldValue.contains(',')) {
                        // Escape any double quotes within the field value
                        fieldValue = fieldValue.replace('"', '""');
                        // Enclose the field value in double quotes
                        fieldValues.add('"' + fieldValue + '"');
                    } else {
                        fieldValues.add(fieldValue);
                    }
                }
                */
            }

            // Append the field values as a CSV row
            csvContent += String.join(fieldValues, ',') + '\n';
        }

        // Return the CSV content as a string
        return csvContent;
    }
}
