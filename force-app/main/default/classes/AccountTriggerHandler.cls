public with sharing class AccountTriggerHandler extends triggerHandler {

    private override void beforeInsert(){
        //logic here
        System.debug('before Insert');

        

    }

    private override void afterInsert(){
        //logic here
        System.debug('after Insert');
    }
}
