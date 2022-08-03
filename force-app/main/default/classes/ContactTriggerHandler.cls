public with sharing class ContactTriggerHandler extends TriggerHandler{

    public override void afterInsert(){
        System.debug('afterInsert');
        Set<Id> accountIds;

        for(Contact ct : (List<Contact>) Trigger.new){

            if(ct.status__c == 'Active'){
                accountIds.add(ct.accountId);
            }
        }
        updateActiveContacts(accountIds);

    }

    public override void afterUpdate(){
        System.debug('afterUpdate');
        Contact oldContact;
        
        Set<Id> accountIds = new Set<Id>();
        
        for(Contact ct : (List<Contact>) Trigger.new){
            oldContact = (Contact) Trigger.oldMap.get(ct.Id);
            
            if(ct.status__c != oldContact.status__c){
                accountIds.add(ct.accountId);
            }
        }

        if(!accountIds.isEmpty()){
            updateActiveContacts(accountIds);
        }
    }
    

    private void updateActiveContacts(Set<Id> accountIds){

        List<AggregateResult> filteredResults = [
            SELECT AccountId, Count(Id) activeContacts
            FROM Contact
            WHERE AccountId IN : accountIds AND Status__c = 'Active' GROUP BY AccountId];

        List<Account> accListToUpdate = new List<Account>();
        Account acc;
        
        for(AggregateResult ag : filteredResults){
            acc = new Account();
            acc.Id = (Id) ag.get('accountId');
            acc.Active_Contacts__c = (Integer) ag.get('activeContacts');

            accListToUpdate.add(acc);
        }

        if(accListToUpdate.size() > 0){
            update accListToUpdate;
        }
    }

}
