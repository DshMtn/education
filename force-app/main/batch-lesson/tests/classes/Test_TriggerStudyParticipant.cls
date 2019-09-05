/**
* Created by user on 04.09.2019.
*/

@IsTest
private class Test_TriggerStudyParticipant {
    @TestSetup
    static void loadDate() {
        Contact contact = new Contact(LastName = 'Test');
        List<Clinical_Study__c> clinicalStudy = new List<Clinical_Study__c>([
                SELECT Id
                FROM Clinical_Study__c
                LIMIT 2]);
        Study_Participant__c studyParticipant = new Study_Participant__c(
                Contact__c = contact.Id,
                Clinical_Study__c = clinicalStudy[0].Id
        );
        insert contact;
        insert  clinicalStudy;
        insert studyParticipant;
    }

    @isTest
    static void testUpdateStudyParticipantKey() {
        Contact contact = [
                SELECT Id, Name
                FROM Contact
                WHERE LastName = 'Test'
        ];


    }
}