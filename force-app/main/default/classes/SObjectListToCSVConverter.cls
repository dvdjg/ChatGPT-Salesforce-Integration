/*
sfdx force:source:deploy --sourcepath ./force-app/main/default/classes/SObjectListToCSVConverter.cls
*/
public with sharing class SObjectListToCSVConverter {
    public static String convertToCSV(List<sObject> sObjects) {
        String csvContent = '';

        // Extract the field names from the first sObject in the list
        if (!sObjects.isEmpty()) {
            sObject firstSObject = sObjects[0];
            Map<String, Object> fieldMap = firstSObject.getPopulatedFieldsAsMap();
            Set<String> fieldNames = fieldMap.keySet();
            // Append the field names as the CSV header
            csvContent += String.join(new List<String>(fieldNames), ',') + '\n';
        }

        // Process each sObject in the list
        for (sObject sObj : sObjects) {
            Map<String, Object> fieldMap = sObj.getPopulatedFieldsAsMap();
            List<String> fieldValues = new List<String>();

            // Extract the field values for each field name
            for (String fieldName : fieldMap.keySet()) {
                String fieldValue = String.valueOf(fieldMap.get(fieldName));
                // Escape any double quotes within the field value
                fieldValue = fieldValue.replace('"', '""');
                // Enclose the field value in double quotes
                fieldValues.add('"' + fieldValue + '"');
            }

            // Append the field values as a CSV row
            csvContent += String.join(fieldValues, ',') + '\n';
        }

        // Return the CSV content as a string
        return csvContent;
    }
}
