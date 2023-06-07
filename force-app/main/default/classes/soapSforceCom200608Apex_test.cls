@isTest
public with sharing class soapSforceCom200608Apex_test {
    // Método de prueba de ejemplo
    @isTest
    static void testMethod1() {
        string output = soapSforceCom200608Apex.evalString('string first = \'foo\'; string second = \'bar\'; string result = first + second; System.debug(LoggingLevel.Error, result);');
        System.assertEquals('foobar', output);
        System.debug(output);
    }

    @isTest
    static void testMethod2() {    
        integer output = soapSforceCom200608Apex.evalInteger('integer first = 1; integer second = 5; integer result = first + second; System.debug(LoggingLevel.Error, result);');
        System.assertEquals(6, output);
        System.debug(output);
    }
    
    @isTest
    static void testMethod3() {
        boolean output = soapSforceCom200608Apex.evalBoolean('boolean first = true; boolean second = false; boolean result = first || second; System.debug(LoggingLevel.Error, result);');
        System.assertEquals(true, output);
        System.debug(output);
    }

    @isTest
    static void testMethod4() {
        string outputJson = soapSforceCom200608Apex.evalString('List<object> result = new List<object>(); result.add(\'foo\'); result.add(12345); System.debug(LoggingLevel.Error, JSON.serialize(result));');
        System.debug(outputJson);
        List<Object> result = 
           (List<Object>)JSON.deserializeUntyped(outputJson);
        System.assertEquals(2, result.size());
        System.assertEquals('foo', result[0]);
        System.assertEquals(12345, result[1]);
    }  
    
    @isTest
    static void testMethod5() {
        string output = soapSforceCom200608Apex.evalString('string first = \'foo\'; string second = \'bar\'; string result = first + second; System.debug(LoggingLevel.Error, result);');
        System.assertEquals('foobar', output);
        System.debug(output);
        //SELECT COUNT() FROM Case WHERE ContactId = '0037R00003JDJo7QAH' AND IsClosed = false
    }
}