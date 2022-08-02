public with sharing class AccountTriggerHandler extends TriggerHandler {

    public override void beforeInsert(){
        System.debug('Before Insert');

        for(Account acc : (List<Account>) Trigger.new){
            acc.Name = 'Trigger override ' + acc.Name;
        }
    }

    public override void afterInsert(){


    }
}
