public with sharing class AccountTriggerHandler extends TriggerHandler {

    public override void beforeInsert(){
        updateAccountFavoriteColor(Trigger.new);
    }

    public override void beforeUpdate(){
        updateAccountFavoriteColor(Trigger.new);
    }

    private void updateAccountFavoriteColor(List<Account> accounts){

        Set<Id>accountOwnersId = new Set<Id>();
        for (Account ac : accounts){
            accountOwnersId.add(ac.OwnerId);
        } 

        Map<Id,User> usersFavoriteColors = new Map<Id,User>([SELECT Id, Favorite_Color__c FROM User WHERE Id IN :accountOwnersId]);
       
        User userFavColor;

        for(Account acc : accounts){ 
            userFavColor = usersFavoriteColors.get(acc.OwnerId);

            if(!(String.isBlank(userFavColor.Favorite_Color__c))){
                acc.user_favorite_color__c = userFavColor.Favorite_Color__c;
            }else {
                acc.addError('Account Owner does not have a favorite color');
            }
        }

    }
}