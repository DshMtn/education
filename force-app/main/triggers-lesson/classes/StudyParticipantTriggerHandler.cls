/**
 * Created by user on 02.09.2019.
 */

public with sharing class StudyParticipantTriggerHandler {
        public static void updateStudyParticipantKey(List<Study_Participant__c> spList) {
            Set<Id> clinicalStudyIds = new Set<Id>();
            for(Study_Participant__c sp : spList) clinicalStudyIds.add(sp.Clinical_Study__c);

            List<Clinical_Study__c> clinicalStudies = [
                    SELECT Id, Name
                    FROM Clinical_Study__c
                    WHERE Id IN :clinicalStudyIds
            ];

            //var1
            Map<Id, Clinical_Study__c> clinicalStudyMap = new Map<Id, Clinical_Study__c>();
            for(Clinical_Study__c clinicalStudy : clinicalStudies) clinicalStudyMap.put(clinicalStudy.Id, clinicalStudy);

            //var2
            //clinicalStudyMap = new Map<Id, Clinical_Study__c>(clinicalStudies);

            for(Study_Participant__c sp : spList) {
                String studyName = clinicalStudyMap.get(sp.Clinical_Study__c).Name;
            sp.Study_Participant_Key__c = sp.Contact__c + ' ' + studyName;
            }
        }
    public static void updateCurrentStudyParticipant(List<Id> contactIds) {
        List<Study_Participant__c> studyParticipants = [
                SELECT Id, Name, Status__c
                FROM Study_Participant__c
                WHERE Id = :contactIds AND Status__c = 'Open'
        ];
        Map<Id, List<Id>> studyParticipantsByContactMap = new Map<Id, List<Id>>();

        for (Study_Participant__c studyParticipant : studyParticipants){
            List<Id> studyParticipantsForContacts = studyParticipantsByContactMap.get(studyParticipant.Contact__c);
            if (studyParticipantsForContacts == null) studyParticipantsForContacts = new List<Id>();
            studyParticipantsForContacts.add(studyParticipant.Id);
            studyParticipantsByContactMap.put(studyParticipant.Contact__c, studyParticipantsForContacts);
        }

        List<Contact> contacts = [SELECT Id, Current_Study__c FROM Contact WHERE Id IN: contactIds];

        for (Contact contact : contacts) {
            List<Id> studyParticipantsForContacts = studyParticipantsByContactMap.get(contact.Id);
            if (studyParticipantsForContacts == null) studyParticipantsForContacts = new List<Id>();
            if(contact.Current_Study__c == null || !studyParticipantsForContacts.contains(contact.Current_Study__c)) {
                if(studyParticipantsForContacts.size() > 0) {
                    contact.Current_Study__c = studyParticipantsForContacts.get(0);
                } else {
                    contact.Current_Study__c = null;
                }
            }
        }

        update contacts;

    }

    public static void updateStudyParticipant(Map<Id, Study_Participant__c> oldMap, List<Study_Participant__c> newList){
        List<Id> contactIds = new List<Id>();
        for(Study_Participant__c sp : newList) {
            if(oldMap == null || (oldMap.get(sp.Id).Status__c != sp.Status__c && sp.Status__c == 'Closed')) {
                contactIds.add(sp.Contact__c);
            }
        }

        updateCurrentStudyParticipant(contactIds);
    }
}


