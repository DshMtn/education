/**
 * Created by Dasha Mitina on 05.09.2019.
 */

@IsTest
private class Test_StudyParticipantFilter {
    @IsTest
    static void test1() {
        Test.startTest();
        Contact contact = new Contact(LastName = 'TestFil');
        insert contact;
        Clinical_Study__c clinicalStudy = new Clinical_Study__c(Title__c = 'MyTitleTest');
        insert clinicalStudy;

        Study_Participant__c studyParticipant = new Study_Participant__c(
                Contact__c = contact.Id,
                Clinical_Study__c = clinicalStudy.Id,
                Status__c = 'open'
        );
        insert studyParticipant;

        StudyParticipantFilter filter = new StudyParticipantFilter();
        filter.status = 'open';
        filter.studyTitleTerm = 'Title';

        PaginationData paginationData = new PaginationData();
        SearchResponse response = SearchService.search(filter, paginationData);
        filter.studyTitleTerm = 'Help';
        System.debug('>>>' + JSON.serializePretty(paginationData));
        PaginationData paginationData2 = new PaginationData();
        SearchResponse response2 = SearchService.search(filter, paginationData2);
        System.debug('>>>' + JSON.serializePretty(paginationData2));

        Test.stopTest();

        System.assert(response.paginationData.currentPageCount == 1, 'Wrong records count per current page');
        System.assert(response.pageRecords.size() == 1, 'Wrong records count per current page');

        System.assert(response2.pageRecords.size() == 0, 'Must be empty List');
    }


    @isTest
    private static void test2() {
        Clinical_Study__c clinicalStudy = new Clinical_Study__c(
                Title__c = 'TitleTest'
        );
        insert clinicalStudy;
        for (Integer i = 0; i < 7; i++) {
            Contact contact = new Contact(
                    LastName = 'TestContact ' + i
            );
            insert contact;
            Study_Participant__c studyParticipant = new Study_Participant__c(
                    Contact__c = contact.Id,
                    Clinical_Study__c = clinicalStudy.Id,
                    Status__c = 'open'
            );
            insert studyParticipant;
        }

        StudyParticipantPanelRemote.InitData initData = StudyParticipantPanelRemote.getInitData();
        System.assert(initData.pagination.pagesCount == 2, 'Wrong number of pages' + initData.pagination.pagesCount);

        initData.pagination.currentPage = 2;
        SearchResponse searchResponse = StudyParticipantPanelRemote.search(
                JSON.serialize(initData.filter),
                JSON.serialize(initData.pagination)
        );
        System.assert(searchResponse.pageRecords.size() == 2, 'Wrong record number' + searchResponse.pageRecords.size());
    }
}