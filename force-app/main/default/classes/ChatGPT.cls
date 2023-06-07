public with sharing class ChatGPT {
    public ChatGPT() {

    }

    public List<RoleContent> getMessageStack() {
        List<RoleContent> roles = new List<RoleContent> {
            new RoleContent('system' , 'You act as the middleman between USER and a DATABASE. Your main goal is to answer questions based on data stored in a Salesforce CRM database (SERVER). You do this by executing valid queries against the database and interpreting the results to answer the questions from the USER.'),
            new RoleContent('user' , 'From now you will only ever respond with JSON. When you want to address the user, you use the following format {"recipient": "USER", "message":"message for the user"}.'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"I understand."}.'),
            new RoleContent('user' , 'You can access Salesforce by using the SERVER recipient. When calling the server, you must also specify an action. The action can be QUERY when you want to QUERY the database with a SOQL, or DML when you want to do a DML operation using a supplied record. The format you will use for a insert operation is as follows {"recipient":"SERVER", "action":"DML", "message":"insert new Account(Name = \'Acme Corp.\')"}. The format you will use for an insert operation is as follows {"recipient":"SERVER", "action":"DML", "message":"insert new Account(Name = \'Acme Corp.\')"}. The format you will use for an upsert operation is as follows {"recipient":"SERVER", "action":"DML", "message":"upsert new Lead(LastName = \'testLead\', Company = \'testCompany\', ExternalId__c = \'NUM-0001\') ExternalId__c"}. The format you will use for executing a SOQL is as follows: {"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, CaseNumber, Subject, Description, Status, CreatedDate FROM Case WHERE CaseNumber = \'00001002\'"}. When a succesfull DML operation is issued, the user will return the Id of the record. When a successfull QUERY is performed, the data will be returned by the user as a CSV string.'),
            new RoleContent('user' , 'Let\'s start! I want to know all the cases for a contact identified by its Email \'asong@uog.com\' or Phone \'(212) 842-5500\' , in the last year'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, CaseNumber, Subject, Description, Status, CreatedDate FROM Case WHERE ContactId IN ( SELECT Id FROM Contact WHERE Email = \'asong@uog.com\' OR Phone = \'(212) 842-5500\' ) AND CreatedDate >= LAST_N_DAYS:365"}'),
            //new RoleContent('user' , 'Let\'s start! I want to know all the closed won opportunities and its related order products in the last year for a given Account identified by its unique Account Number 00012321'),
            //new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, Name, StageName, CloseDate, (SELECT Id, Name, Product2.Name, Quantity, TotalPrice FROM OpportunityLineItems) FROM Opportunity WHERE  Account.AccountNumber = \'00012321\' AND StageName = \'Closed Won\' AND CloseDate >= LAST_N_DAYS:365"}'),
            new RoleContent('user' , 'Id,CaseNumber,Subject,Description,Status,CreatedDate\n5007R00003XpYf9QAF,00001002,Seeking guidance on electrical wiring installation for GC5060,,New,2023-05-23T15:04:02.000+0000'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"I found one Case with number 00001002."}.'),
            new RoleContent('user' , 'Excellent. What more can you tell me about the case?'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"The case 00001002 is in the \'New\' state. It was created on May 23, 2023, at 15:04 with the subject \'Seeking guidance on electrical wiring installation for GC5060\'."}.'),
            new RoleContent('user' , 'Thanks!. Give me contact and account information related to this case.'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Contact.Id, Contact.Name, Contact.Email, Contact.Phone, Account.Id, Account.Name, Account.BillingAddress FROM Case WHERE Id = \'5007R00003XpYf9QAF\'"}'),
            new RoleContent('user' , 'Contact.Id,Contact.Name,Contact.Email,Contact.Phone,Account.Id,Account.Name,Account.BillingAddress.city,Account.BillingAddress.country,Account.BillingAddress.geocodeAccuracy,Account.BillingAddress.latitude,Account.BillingAddress.longitude,Account.BillingAddress.postalCode,Account.BillingAddress.state,Account.BillingAddress.street\n0037R00003JDJo7QAH,Stella Pavlova,spavlova@uog.com,(212) 842-5500,0017R00002wgqvxQAA,United Oil & Gas Corp.,New York,,,,,,NY,"1301 Avenue of the Americas New York, NY 10019 USA"'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"The case belongs to Stella Pavlova. She can be reached via email at spavlova@uog.com or by phone at (212) 842-5500. Stella is associated with an account named United Oil & Gas Corp. The account is located at 1301 Avenue of the Americas in New York, with a ZIP code of 10019."}.')
            
        };
        return roles;
    }
/*
    {"role": "assistant", "content": ""},
    {"role": "user", "content": "You can address the SQL Server by using the SERVER recipient. When calling the server, you must also specify an action. The action can be QUERY when you want to QUERY the database, or SCHEMA when you need SCHEMA information for a comma separated list of tables. The format you will use for requesting schema information is as follows {"recipient":"SERVER", "action":"SCHEMA", "message":"Person.Person, Person.Address"}. The format you will use for executing a query is as follows: {"recipient":"SERVER", "action":"QUERY", "message":"SELECT SUM(OrderQty) FROM Sales.SalesOrderDetail;"}"},
    # At some point the list of tables should become dynamic. Todo: Figure out how the flows can be dynamic, perhaps some sort of config.
    {"role": "user", "content": "THe following tables are available in the database: Sales.SalesOrderDetail, Sales.SalesOrderHeader, Person.Address, Person.Person, Production.Product, Production.ProductCategory, Production.ProductSubcategory. You will always first request the SCHEMA for a table before using the table in a QUERY."},
    {"role": "user", "content": "Let's start! How many Orders did we ship to Bellflower?"},
    {"role": "assistant", "content": "{"recipient":"SERVER", "action":"SCHEMA", "message":"Person.Address, Sales.SalesOrderHeader"}"},
    {"role": "user", "content": "Table, Column, DataType\nPerson.Address, AddressID, int\nPerson.Address, AddressLine1, nvarchar\nPerson.Address, AddressLine2, nvarchar\nPerson.Address, City, nvarchar\nPerson.Address, StateProvinceID, int\nPerson.Address, PostalCode, nvarchar\nPerson.Address, SpatialLocation, geography\nPerson.Address, rowguid, uniqueidentifier\nPerson.Address, ModifiedDate, datetime\nSales.SalesOrderHeader, SalesOrderID, int\nSales.SalesOrderHeader, RevisionNumber, tinyint\nSales.SalesOrderHeader, OrderDate, datetime\nSales.SalesOrderHeader, DueDate, datetime\nSales.SalesOrderHeader, ShipDate, datetime\nSales.SalesOrderHeader, Status, tinyint\nSales.SalesOrderHeader, OnlineOrderFlag, bit\nSales.SalesOrderHeader, SalesOrderNumber, nvarchar\nSales.SalesOrderHeader, PurchaseOrderNumber, nvarchar\nSales.SalesOrderHeader, AccountNumber, nvarchar\nSales.SalesOrderHeader, CustomerID, int\nSales.SalesOrderHeader, SalesPersonID, int\nSales.SalesOrderHeader, TerritoryID, int\nSales.SalesOrderHeader, BillToAddressID, int\nSales.SalesOrderHeader, ShipToAddressID, int\nSales.SalesOrderHeader, ShipMethodID, int\nSales.SalesOrderHeader, CreditCardID, int\nSales.SalesOrderHeader, CreditCardApprovalCode, varchar\nSales.SalesOrderHeader, CurrencyRateID, int\nSales.SalesOrderHeader, SubTotal, money\nSales.SalesOrderHeader, TaxAmt, money\nSales.SalesOrderHeader, Freight, money\nSales.SalesOrderHeader, TotalDue, money\nSales.SalesOrderHeader, Comment, nvarchar\nSales.SalesOrderHeader, rowguid, uniqueidentifier\nSales.SalesOrderHeader, ModifiedDate, datetime"},
    {"role": "assistant", "content": "{"recipient":"SERVER", "action":"QUERY", "message":"SELECT COUNT(*) AS COUNT FROM Sales.SalesOrderHeader sh JOIN Person.Address a ON sh.ShipToAddressID = a.AddressID  WHERE a.City = 'Bellflower'"}"},
    {"role": "user", "content": "COUNT\n243"},
    {"role": "assistant", "content": "{"recipient": "USER", "message":"243 orders were shipped to Bellflower."}."},
    {"role": "user", "content": "excellent, thank you! Now the next question. How many orders did we ship to Milwaukee?"},
    {"role": "assistant", "content": "{"recipient":"SERVER", "action":"QUERY", "message":"SELECT COUNT(*) AS COUNT FROM Sales.SalesOrderHeader sh JOIN Person.Address a ON sh.ShipToAddressID = a.AddressID  WHERE a.City = 'Milwaukee'"}"},
    {"role": "user", "content": "COUNT\n4"},
    {"role": "assistant", "content": "{"recipient": "USER", "message":"4 orders were shipped to Milwaukee."}."},
    {"role": "user", "content": "great, thank you! Now the next question. How many orders did we ship to Chicago?"},
    # The below messages will be generated by ChatGPT based on the above. Still keeping them in to reinforce the idea, not sure if useful(?).
    {"role": "assistant", "content": "{"recipient":"SERVER", "action":"QUERY", "message":"SELECT COUNT(*) AS COUNT FROM Sales.SalesOrderHeader sh JOIN Person.Address a ON sh.ShipToAddressID = a.AddressID  WHERE a.City = 'Chicago'"}", "role": "assistant"},
    {"role": "user", "content": "COUNT\n30"},
    {"role": "assistant", "content": "{"recipient": "USER", "message":"30 orders were shipped to Chicago."}."},
    {"role": "user", "content": "What was the top selling product in 2014 by quantity?"},
    {"role": "assistant", "content": "{"recipient":"SERVER", "action":"SCHEMA", "message":"Production.Product, Sales.SalesOrderDetail"}"},
    {"role": "user", "content": "Production.Product, ProductID, int\nProduction.Product, Name, nvarchar\nProduction.Product, ProductNumber, nvarchar\nProduction.Product, MakeFlag, bit\nProduction.Product, FinishedGoodsFlag, bit\nProduction.Product, Color, nvarchar\nProduction.Product, SafetyStockLevel, smallint\nProduction.Product, ReorderPoint, smallint\nProduction.Product, StandardCost, money\nProduction.Product, ListPrice, money\nProduction.Product, Size, nvarchar\nProduction.Product, SizeUnitMeasureCode, nchar\nProduction.Product, WeightUnitMeasureCode, nchar\nProduction.Product, Weight, decimal\nProduction.Product, DaysToManufacture, int\nProduction.Product, ProductLine, nchar\nProduction.Product, Class, nchar\nProduction.Product, Style, nchar\nProduction.Product, ProductSubcategoryID, int\nProduction.Product, ProductModelID, int\nProduction.Product, SellStartDate, datetime\nProduction.Product, SellEndDate, datetime\nProduction.Product, DiscontinuedDate, datetime\nProduction.Product, rowguid, uniqueidentifier\nProduction.Product, ModifiedDate, datetime\nSales.SalesOrderDetail, SalesOrderID, int\nSales.SalesOrderDetail, SalesOrderDetailID, int\nSales.SalesOrderDetail, CarrierTrackingNumber, nvarchar\nSales.SalesOrderDetail, OrderQty, smallint\nSales.SalesOrderDetail, ProductID, int\nSales.SalesOrderDetail, SpecialOfferID, int\nSales.SalesOrderDetail, UnitPrice, money\nSales.SalesOrderDetail, UnitPriceDiscount, money\nSales.SalesOrderDetail, LineTotal, numeric\nSales.SalesOrderDetail, rowguid, uniqueidentifier\nSales.SalesOrderDetail, ModifiedDate, datetime"},
    {"role": "assistant", "content": "{"recipient":"SERVER", "action":"QUERY", "message":"SELECT TOP 1 Production.Product.Name FROM Production.Product JOIN Sales.SalesOrderDetail ON Product.ProductID = SalesOrderDetail.ProductID JOIN Sales.SalesOrderHeader ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID WHERE YEAR(SalesOrderHeader.OrderDate) = 2014 GROUP BY Product.Name ORDER BY SUM(OrderQty) DESC;"},
    {"role": "user", "content": "Name\nWater Bottle - 30 oz."},
    {"role": "assistant", "content": "{"recipient": "USER", "message":"The top selling product by quantity in 2014 is the Water Bottle - 30 oz."}."}
    */


    public class RoleContent {
        public RoleContent(String r, String c) {
            role = r;
            content = c;
        }
        public String role;
        public String content;
    }
    //public class MessageStack {
    //    public List<RoleContent> 
    //}
}