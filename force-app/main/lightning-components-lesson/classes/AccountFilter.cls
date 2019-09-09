/**
 * Created by Dasha Mitina on 09.09.2019.
 */

public with sharing class AccountFilter implements SearchFilter{

    public List<String> getFields() {
        return new List<String>{
                'Name',
                'Billing_Country__c',
                'Billing_City__c',
                'Billing_State__c',
                'Billing_Street__c'
        };
    }

    public SObjectType getSObjectType() {
        return Account.getSObjectType();
    }

    public String getFilterString() {
        return '';
    }

}