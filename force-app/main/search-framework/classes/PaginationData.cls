/**
 * Created by Dasha Mitina on 05.09.2019.
 */

public with sharing class PaginationData {
    @AuraEnabled public Integer allRecordsCount;
    @AuraEnabled public Integer pagesCount;
    @AuraEnabled public Integer pagesRecordsCount;
    @AuraEnabled public Integer currentPage;
    @AuraEnabled public Integer currentPageCount;
    @AuraEnabled public Integer offset;
    @AuraEnabled public Integer endOffset;

    public PaginationData() {
        currentPage = 1;
        pagesRecordsCount = 5;
    }

    public void setRecordsCount(Integer allRecordsCount) {
        this.allRecordsCount = allRecordsCount;
        recalc();
    }

    public void recalc() {
        Decimal allRecordsCountDecimal = allRecordsCount;
        Decimal pagesRecordsCountDecimal = pagesRecordsCount;
        Decimal allPagesDecimal = allRecordsCountDecimal/pagesRecordsCountDecimal;
        allPagesDecimal = allPagesDecimal.round(System.RoundingMode.UP);
        pagesCount = allRecordsCount == 0 ? 1 : allPagesDecimal.intValue();
        if(currentPage > allPagesDecimal) currentPage = pagesCount;

        offset = (currentPage - 1) * pagesRecordsCount;
        endOffset = offset + pagesRecordsCount;
        if(endOffset > allRecordsCount) endOffset = allRecordsCount;

        currentPageCount = endOffset - offset;
    }
}