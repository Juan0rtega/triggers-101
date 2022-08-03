@isTest
private class AccountTestClass {

         @isTest static void TestInsertOneAccount() {

            // Test data setup
            Account newAcc = TestDataFactory.createAccount('NewAcc');
            insert newAcc;
         
            Account acc = [SELECT Name, user_favorite_color__c FROM Account WHERE Id =:newAcc.Id LIMIT 1];

            // Test that the trigger correctly updated the favorite color to Blue
             System.assertEquals('Blue', acc.user_favorite_color__c);

        }
    
         @isTest static void TestUpdateOneAccount() {

            // Test data setup
            Account newAcc = TestDataFactory.createAccount('NewAcc');
            insert newAcc;
         
            Account acc = [SELECT Name, user_favorite_color__c, OwnerId FROM Account WHERE Id =:newAcc.Id];
        	acc.Name = 'UpdateAcc';
			
        	Test.startTest();
           	 update acc;
        	Test.stopTest();
          
        }

         @isTest static void TestInsertMultipleAccounts() {
            // Test data setup
            List<Account> newAccs = TestDataFactory.createAccounts(201);
            
          	Test.startTest();
           	 insert newAccs;
        	Test.stopTest();
         
             }


    }