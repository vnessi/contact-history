/**
 * Utility class to deal with ContactStatusHistory__c records
 */
public with sharing class ContactStatusHistoryUtil {
    public static ContactStatusHistory__c createStatusHistory(Id contactId, String status, DateTime beginDate, DateTime endDate) {
        return new ContactStatusHistory__c(Contact__c = contactId, Status__c = status, BeginDate__c = beginDate, EndDate__c = endDate);
    }

    public static List<ContactStatusHistory__c> retrieveLastStatusHistory(Set<Id> contactIds) {
        return [Select Status__c, BeginDate__c, EndDate__c from ContactStatusHistory__c where Contact__c IN :contactIds AND EndDate__c = null order by CreatedDate desc];
    }
}
