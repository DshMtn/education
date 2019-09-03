/**
 * Created by user on 03.09.2019.
 */

public with sharing class Batch_SetAccountDescription implements Database.Batchable<sObject>, Database.Stateful {
    public  Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
                SELECT Id,
                        Name,
                        BillingCity,
                        BillingCountry,
                        BillingStreet,
                        BillingState
                FROM Account]);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) {
            acc.Description = acc.Name;
            if (acc.BillingState != null) acc.Description = acc.Description + ' ' + acc.BillingState;
            if (acc.BillingStreet != null) acc.Description = acc.Description + ' ' + acc.BillingStreet;
            if (acc.BillingCountry != null) acc.Description = acc.Description + ' ' + acc.BillingCountry;
            if (acc.BillingCity != null) acc.Description = acc.Description + ' ' + acc.BillingCity;
        }
        insert scope;
        }

    public void finish(Database.BatchableContext bc) {
    }
    public static void run() {
        Database.executeBatch(new Batch_SetAccountDescription(), 1);
    }
}