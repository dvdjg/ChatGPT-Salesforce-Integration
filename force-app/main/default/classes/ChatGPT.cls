public with sharing class ChatGPT {
    public ChatGPT() {

    }

    /*
        To achieve this, I would listen to the questions asked by the USER and analyze them to understand the information they are looking for. Based on the type of question and data needed, I would use SQL to construct valid queries that retrieve the relevant information from the Salesforce CRM database.

        Once the queries are executed, I would interpret the results and format them in a way that is easy to understand for the USER. This could involve visual aids such as charts or graphs, or simply presenting the data in a clear and concise manner.

        Throughout the process, I would ensure that the data retrieved and presented to the USER is accurate and up-to-date. If necessary, I would also suggest additional queries or data sources to provide a more comprehensive answer to the USER's question. Overall, my goal would be to provide the USER with valuable insights and information that helps them make informed decisions based on the data at hand.     
     */

    public List<RoleContent> getMessageStack_v1() {
        List<RoleContent> roles = new List<RoleContent> {
            new RoleContent('system' , 'You act as the middleman between USER and a DATABASE. Your main goal is to answer questions based on data stored in a Salesforce CRM database (SERVER). You do this by executing valid queries against the database and interpreting the results to answer the questions from the USER.'),
            new RoleContent('user' , 'From now you will only ever respond with JSON. When you want to address the user, you use the following format {"recipient": "USER", "message":"message for the user"}.'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"I understand."}'),
            new RoleContent('user' , 'You can access Salesforce by using the SERVER recipient. When calling the server, you must also specify an action. The action can be QUERY when you want to query the database with a SOQL, or APEX  when you want to run a piece of APEX code. User will return the content of the variable \'result\' if defined. The format you will use for an insert operation returning its Id is as follows {"recipient":"SERVER", "action":"APEX", "message":"Account acc = new Account(Name = \'Acme Corp.\'); insert acc; Id result = acc.Id;"}. The format you will use for an upsert operation is as follows {"recipient":"SERVER", "action":"APEX", "message":"LEAD l = new Lead(LastName = \'testLead\', Company = \'testCompany\', ExternalId__c = \'NUM-0001\') ExternalId__c; upsert l; Id result = l.Id;"}. The format you will use for query uses SOQL as follows: {"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, CaseNumber, Subject, Description, Status, CreatedDate FROM Case WHERE CaseNumber = \'00001002\'"}. When a successfull QUERY is performed, the data will be returned by the user as a CSV string.'),
            new RoleContent('user' , 'Let\'s start! I want to know all the cases for a contact identified by its Email asong@uog.com or Phone (212) 842-5500 , in the last year'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, CaseNumber, Subject, Description, Status, CreatedDate FROM Case WHERE ContactId IN ( SELECT Id FROM Contact WHERE Email = \'asong@uog.com\' OR Phone = \'(212) 842-5500\' ) AND CreatedDate >= LAST_N_DAYS:365"}'),
            //new RoleContent('user' , 'Let\'s start! I want to know all the closed won opportunities and its related order products in the last year for a given Account identified by its unique Account Number 00012321'),
            //new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, Name, StageName, CloseDate, (SELECT Id, Name, Product2.Name, Quantity, TotalPrice FROM OpportunityLineItems) FROM Opportunity WHERE  Account.AccountNumber = \'00012321\' AND StageName = \'Closed Won\' AND CloseDate >= LAST_N_DAYS:365"}'),
            new RoleContent('user' , '"Id","CaseNumber","Status","Priority","Origin","Subject","Description","CreatedDate","Contact.Name"\n"5007R00003XpYf8QAF","00001001","Closed","High","Phone","Performance inadequate for second consecutive week","","2023-05-23T15:04:02.000+0000","Avi Green"\n"5007R00003XpYf9QAF","00001002","New","Low","Web","Seeking guidance on electrical wiring installation for GC5060","","2023-05-23T15:04:02.000+0000","Stella Pavlova"\n"5007R00003XpYfSQAV","00001021","Closed","High","Phone","Generator GC3060 platform structure is weakening","","2023-05-23T15:04:02.000+0000","Stella Pavlova"\n"5007R00003XpYfTQAV","00001022","Closed","Medium","Web","Signal panel on GC5060 blinks intermittently","","2023-05-23T15:04:02.000+0000","Stella Pavlova"\n"5007R00003XpYfUQAV","00001023","Closed","High","Phone","Electric surge damaging adjacent equipment","","2023-05-23T15:04:02.000+0000","Stella Pavlova"\n"5007R00003XpYfVQAV","00001024","New","Low","Web","Design issue with mechanical rotor","","2023-05-23T15:04:02.000+0000","Lauren Boyle"\n"5007R00003XpYfWQAV","00001025","Closed","Medium","Phone","Motor design hindering performance","","2023-05-23T15:04:02.000+0000","Lauren Boyle"'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"I found seven Cases."}'),
            new RoleContent('user' , 'Tell me the ones you find with the status New.'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"I found one Case with number 00001002. It was created on May 23, 2023, at 15:04 with the subject \'Seeking guidance on electrical wiring installation for GC5060\'."}'),
            new RoleContent('user' , 'Thanks!. Please give me the case description.'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"The case 00001002 has no description. Would you like more information about the case?"}'),
            new RoleContent('user' , 'Yes!. Give me contact and account information related to this case.'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, Contact.Id, Contact.Name, Contact.Email, Contact.Phone, Account.Id, Account.Name, Account.BillingAddress FROM Case WHERE CaseNumber = \'00001002\'"}'),
            new RoleContent('user' , 'Id,Contact.Id,Contact.Name,Contact.Email,Contact.Phone,Account.Id,Account.Name,Account.BillingAddress.city,Account.BillingAddress.country,Account.BillingAddress.geocodeAccuracy,Account.BillingAddress.latitude,Account.BillingAddress.longitude,Account.BillingAddress.postalCode,Account.BillingAddress.state,Account.BillingAddress.street\n5007R00003XpYf9QAF,0037R00003JDJo7QAH,Stella Pavlova,spavlova@uog.com,(212) 842-5500,0017R00002wgqvxQAA,United Oil & Gas Corp.,New York,,,,,,NY,"1301 Avenue of the Americas New York, NY 10019 USA"'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"The case belongs to Stella Pavlova. She can be reached via email at spavlova@uog.com or by phone at (212) 842-5500. Stella is associated with an account named United Oil & Gas Corp. The account is located at 1301 Avenue of the Americas in New York, with a ZIP code of 10019."}'),
            new RoleContent('user' , 'please, modify the Stella surname. It is Paulova.'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"APEX", "message":"Case caseToUpdate = [SELECT Id, ContactId FROM Case WHERE CaseNumber = \'00001002\']; Contact contactToUpdate = new Contact(Id = caseToUpdate.ContactId, LastName = \'Paulova\'); update contactToUpdate; Id result = contactToUpdate.Id;"}'),
            new RoleContent('user' , '0037R00003JDJo7QAH'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"The contact\'s last name has been updated to \'Paulova\'."}'),
            new RoleContent('user' , 'Put a case comment with the text "Paulova is the best!"'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"APEX", "message":"CaseComment comment = new CaseComment(ParentId = \'5007R00003XpYf9QAF\', CommentBody = \'Paulova is the best!\'); insert comment; Id result = comment.Id;"}'),
            new RoleContent('user' , '00a7R00001NVyyGQAT'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"A comment has been added to the case."}'),
            new RoleContent('user' , 'Add a feed item to the case with the same text.'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"APEX", "message":"FeedItem post = new FeedItem(ParentId = \'5007R00003XpYf9QAF\', Body = \'Paulova is the best!\'); insert post; Id result = post.Id;"}'),
            new RoleContent('user' , '0D57R0000Bwrh2RSQQ'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"A feed item has been added to the case."}'),
            new RoleContent('user' , '¿Te puedo preguntar en español?'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"¡Por supuesto! Estoy aquí para ayudarte en lo que necesites."}'),
            new RoleContent('user' , '¿Cuántos casos tiene abiertos Paulova?'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT COUNT(Id) FROM Case WHERE ContactId = \'0037R00003JDJo7QAH\' AND IsClosed = false"}'),
            new RoleContent('user' , '1'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"Actualmente, Paulova tiene 1 caso abierto."}'),
            new RoleContent('user' , '¿Cuántos casos tiene cerrados Paulova?'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT COUNT(Id) FROM Case WHERE ContactId = \'0037R00003JDJo7QAH\' AND IsClosed = true"}'),
            new RoleContent('user' , '3'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"Paulova tiene 3 casos cerrados."}'),
            new RoleContent('user' , '¿Cuál es el caso de Paulova que se ha cerrado más recientemente?'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, CaseNumber, Status, Priority, Origin, Subject, Description, CreatedDate, ClosedDate FROM Case WHERE ContactId = \'0037R00003JDJo7QAH\' AND IsClosed = true ORDER BY ClosedDate DESC LIMIT 1"}'),
            new RoleContent('user' , '"Id","CaseNumber","Status","Priority","Origin","Subject","Description","CreatedDate","ClosedDate"\n"5007R00003XpYfSQAV","00001021","Closed","High","Phone","Generator GC3060 platform structure is weakening","","2023-05-23T15:04:02.000+0000","2015-07-28T18:59:51.000+0000"'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"El caso más reciente cerrado de Paulova es el número 00001021. Fue cerrado el 28 de julio de 2015 y su asunto es \'Generator GC3060 platform structure is weakening\'."}'),
            new RoleContent('user' , '¿A qué hora fue cerrado?'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"El caso 00001021 fue cerrado a las 18:59:51 UTC."}'),
            new RoleContent('user' , 'Y en el horario de Madrid?'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"Madrid está 2 horas adelantado de UTC en verano, por lo que la hora local de Madrid sería las 20:59:51."}'),
            new RoleContent('user' , 'Y en Islas Canarias?'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"Las Islas Canarias están 1 hora detrás de la hora de Madrid en verano, por lo que la hora local en las Islas Canarias sería las 19:59:51."}'),
            new RoleContent('user' , 'Cuántas oportunidades ganadas tiene?'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"¿El sistema o Paulova?"}'),
            new RoleContent('user' , 'Paulova'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT COUNT(Id) FROM Opportunity WHERE Contact__c = \'0037R00003JDJo7QAH\' AND StageName = \'Closed Won\'"}'),
            new RoleContent('user' , '0'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"Actualmente, Paulova no tiene oportunidades ganadas."}'),
            new RoleContent('user' , ''),
            new RoleContent('assistant' , ''),
            new RoleContent('user' , ''),
            new RoleContent('assistant' , ''),
            new RoleContent('user' , ''),
            new RoleContent('assistant' , ''),
            new RoleContent('user' , ''),
            new RoleContent('assistant' , ''),
            new RoleContent('user' , ''),
            new RoleContent('assistant' , ''),
            new RoleContent('user' , ''),
            new RoleContent('assistant' , ''),
            new RoleContent('user' , ''),
            new RoleContent('assistant' , '')
            
        };
        return roles;
    }

    public List<RoleContent> getMessageStack_v2() {
        List<RoleContent> roles = new List<RoleContent> {
            new RoleContent('system' , 'You act as the middleman between USER and a DATABASE. Your main goal is to answer questions based on data stored in a Salesforce CRM database (SERVER). You do this by executing valid queries against the database and interpreting the results to answer the questions from the USER.'),
            new RoleContent('user' , 'From now you will only ever respond with JSON. When you want to address the user, you use the following format {"recipient": "USER", "message":"message for the user"}.'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"I understand."}'),
            new RoleContent('user' , 'You can access Salesforce by using the SERVER recipient. When calling the server, you must also specify an action. The action can be QUERY when you want to query the database with a SOQL, or APEX  when you want to do a piece of APEX code. The format you will use for an insert operation is as follows {"recipient":"SERVER", "action":"APEX", "message":"insert new Account(Name = \'Acme Corp.\');"}. The format you will use for an upsert operation is as follows {"recipient":"SERVER", "action":"APEX", "message":"upsert new Lead(LastName = \'testLead\', Company = \'testCompany\', ExternalId__c = \'NUM-0001\') ExternalId__c;"}. The format you will use for query uses SOQL as follows: {"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, CaseNumber, Subject, Description, Status, CreatedDate FROM Case WHERE CaseNumber = \'00001002\'"}. When a succesfull DML operation is issued, the user will return the Id of the record. When a successfull QUERY is performed, the data will be returned by the user as a CSV string.'),
            new RoleContent('user' , 'Let\'s start! I want to know all the cases for a contact identified by its Email asong@uog.com or Phone (212) 842-5500 , in the last year'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, CaseNumber, Subject, Description, Status, CreatedDate FROM Case WHERE ContactId IN ( SELECT Id FROM Contact WHERE Email = \'asong@uog.com\' OR Phone = \'(212) 842-5500\' ) AND CreatedDate >= LAST_N_DAYS:365"}'),
            //new RoleContent('user' , 'Let\'s start! I want to know all the closed won opportunities and its related order products in the last year for a given Account identified by its unique Account Number 00012321'),
            //new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Id, Name, StageName, CloseDate, (SELECT Id, Name, Product2.Name, Quantity, TotalPrice FROM OpportunityLineItems) FROM Opportunity WHERE  Account.AccountNumber = \'00012321\' AND StageName = \'Closed Won\' AND CloseDate >= LAST_N_DAYS:365"}'),
            new RoleContent('user' , 'Id,CaseNumber,Subject,Description,Status,CreatedDate\n5007R00003XpYf9QAF,00001002,Seeking guidance on electrical wiring installation for GC5060,,New,2023-05-23T15:04:02.000+0000'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"I found one Case with number 00001002."}'),
            new RoleContent('user' , 'Excellent. What more can you tell me about the case?'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"The case 00001002 is in the \'New\' state. It was created on May 23, 2023, at 15:04 with the subject \'Seeking guidance on electrical wiring installation for GC5060\'."}.'),
            new RoleContent('user' , 'Thanks!. Please give me the related case description.'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"The case 00001002 has no description. Would you like more information about the case?"}'),
            new RoleContent('user' , 'Yes!. Give me contact and account information related to this case.'),
            new RoleContent('assistant' , '{"recipient":"SERVER", "action":"QUERY", "message":"SELECT Contact.Id, Contact.Name, Contact.Email, Contact.Phone, Account.Id, Account.Name, Account.BillingAddress FROM Case WHERE Id = \'5007R00003XpYf9QAF\'"}'),
            new RoleContent('user' , 'Contact.Id,Contact.Name,Contact.Email,Contact.Phone,Account.Id,Account.Name,Account.BillingAddress.city,Account.BillingAddress.country,Account.BillingAddress.geocodeAccuracy,Account.BillingAddress.latitude,Account.BillingAddress.longitude,Account.BillingAddress.postalCode,Account.BillingAddress.state,Account.BillingAddress.street\n0037R00003JDJo7QAH,Stella Pavlova,spavlova@uog.com,(212) 842-5500,0017R00002wgqvxQAA,United Oil & Gas Corp.,New York,,,,,,NY,"1301 Avenue of the Americas New York, NY 10019 USA"'),
            new RoleContent('assistant' , '{"recipient": "USER", "message":"The case belongs to Stella Pavlova. She can be reached via email at spavlova@uog.com or by phone at (212) 842-5500. Stella is associated with an account named United Oil & Gas Corp. The account is located at 1301 Avenue of the Americas in New York, with a ZIP code of 10019."}')
            
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