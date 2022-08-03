public with sharing class AccountTriggerHandler extends TriggerHandler {

    public override void beforeInsert(){
        System.debug('Before Insert');
        
        updateAccountFavoriteColor(Trigger.new);
    }

    public override void beforeUpdate(){
        System.debug('Before Update');
        
        updateAccountFavoriteColor(Trigger.new);

    }

    private void updateAccountFavoriteColor(List<Account> accounts){

        Map<Id,User> usersFavoriteColors = new Map<Id,User>([SELECT Id, Favorite_Color__c FROM User]);

        for(Account acc : accounts){ 
            User userFavColor = usersFavoriteColors.get(acc.OwnerId);

            if(!(String.isBlank(userFavColor.Favorite_Color__c))){
                acc.user_favorite_color__c = userFavColor.Favorite_Color__c;
            }else {
                acc.addError('Account Owner does not have a favorite color');
            }
        }

    }
}