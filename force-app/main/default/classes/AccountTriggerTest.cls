@isTest
private class AccountTriggerTest {
    
    @testSetup static void accountsCreation() {
        
        //Create common test accounts
        List<Account> newAccs = TestDataFactory.createAccounts(201);
        insert newAccs;
        List<User> users = new List<User>();
        
        
        // Users data setup
        //Create a new User with a fav color
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        User u = new User(Alias = 'sysUser', Email='sysuser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='sysuser@graytestUserorg.com', Favorite_Color__c = 'Blue');
        users.add(u);        
        
        //Create a new User without a fav color
        User uu = new User(Alias = 'sysUser1', Email='sysuser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='sysuser1@graytestUserorg.com');
        users.add(uu);
        
        insert users;
        
    }
    
    @isTest static void testOneAccount() {
        
        User u = [SELECT Id, Favorite_Color__c FROM User WHERE Email='sysuser@testorg.com' LIMIT 1];
        
        Account acc = [SELECT Name, user_favorite_color__c FROM Account WHERE Name='testName0' LIMIT 1];
        
        acc.OwnerId = u.Id;
        update Acc;
        
        // Test that the trigger correctly updated the favorite color to Blue
        System.assertEquals('Blue', acc.user_favorite_color__c, 'The user favorite color was not blue');
    }
    
    
    @isTest static void testMultipleAccounts() {
        // Test data setup
        List<Account> newAccs =  [SELECT Name, user_favorite_color__c FROM Account WHERE Name LIKE 'testName%'];
        
        User u = [SELECT Id, Favorite_Color__c FROM User WHERE Email='sysuser@testorg.com' LIMIT 1];
        
        for(Account ac: newAccs){
            ac.OwnerId = u.Id;
        } 
        
        Test.startTest();
        
        update newAccs;
        
        Integer accountsUpdated =  [SELECT COUNT() FROM Account WHERE user_favorite_color__c='blue'];
        
        // Test that the trigger correctly updated the favorite color to Blue of all accounts
        
        System.assertEquals(201, accountsUpdated, 'The accounts were not updated');
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void testExeptionMessage() {
        
        // arrange
        Boolean exceptionThrown = false;
        User u = [SELECT Id, Favorite_Color__c FROM User WHERE Email='sysuser1@testorg.com' LIMIT 1];
        
        Account acc = [SELECT Name, user_favorite_color__c FROM Account WHERE Name='testName0' LIMIT 1];
        
        acc.OwnerId = u.Id;
        
        
        try {
            update Acc;            
        } catch (Exception e) {
            exceptionThrown = true;
            
            // assert
            Boolean expectedExceptionThrown =  (e.getMessage().contains('Account Owner does not have a favorite color')) ? true : false; 
            System.AssertEquals(true, expectedExceptionThrown, e.getMessage()); 
        } 
        
        System.assertEquals(true, exceptionThrown, 'No exception was thrown');
    }
    
    
}