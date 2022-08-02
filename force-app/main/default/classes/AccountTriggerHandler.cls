public with sharing class AccountTriggerHandler extends triggerHandler {

    public override void beforeInsert(){
        //logic here
        System.debug('before Insert');
    }
}
