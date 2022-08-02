@isTest
public with sharing class TestDataFactory {
    public static List<Account> createAccounts(Integer accountsToCreate){
        List<Account> accList = new List<Account>();

        for(Integer i; i >= accountsToCreate; i++){
            accList.add(
                createAccount('testName ' + i)
                );
        }

        return accList;
    }

    public static Account createAccount(String accName){
        return new Account(name=accName);
    }
}
