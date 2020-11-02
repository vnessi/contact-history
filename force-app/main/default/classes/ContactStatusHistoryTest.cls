@isTest
private class ContactStatusHistoryTest {

    private static final String STATUS_PROSPECT = 'Prospect';
    private static final String STATUS_ACTIVE = 'Active';
    private static final String STATUS_SUSPENDED = 'Suspended';
    @TestSetup
    static void makeData(){
        
    }
    @isTest
    static void validateInsertSingleContact () {
        Test.startTest();
        insert new Contact(LastName = 'Doe', Status__c = STATUS_PROSPECT);
        Test.stopTest();

        Contact contactResult = [Select Id, Status__c, CreatedDate from Contact limit 1];
        ContactStatusHistory__c historyResult = [Select Contact__c, BeginDate__c, EndDate__c, Status__c from ContactStatusHistory__c limit 1];

        System.assertEquals(contactResult.Id, historyResult.Contact__c, 'The unique history record should be assigned to the contact insertd in test');
        System.assertEquals(contactResult.CreatedDate, historyResult.BeginDate__c, 'Beging Date should be equals to the created Contact record');
        System.assertEquals(null, historyResult.EndDate__c, 'End Date should be empty');
        System.assertEquals(contactResult.Status__c, historyResult.Status__c, 'Status should be the same as Contact Status');
    }

    @isTest
    static void validateInsertMultipleContacts () {
        Integer recordsToInsert = 1000;
        List<Contact> contactsToInsert = new List<Contact>();
        for (Integer i = 0; i < recordsToInsert; i++) {
            contactsToInsert.add(new Contact(LastName = 'Doe' + i, Status__c = STATUS_PROSPECT));
        }

        Test.startTest();
        insert contactsToInsert;
        Test.stopTest();

        List<Contact> contactsResult = [Select Id, Status__c, CreatedDate from Contact];
        List<ContactStatusHistory__c> historyResult = [Select Contact__c, BeginDate__c, EndDate__c, Status__c from ContactStatusHistory__c];

        System.assertEquals(recordsToInsert, contactsResult.size(), 'Validate that all contacts has been inserted correctly');
        System.assertEquals(recordsToInsert, historyResult.size(), 'Validate that all Contact Status History records has been inserted correctly');

        DateTime contactDate = contactsResult.get(0).CreatedDate;
        for (ContactStatusHistory__c historyRecord :historyResult) {
            System.assertEquals(null, historyRecord.EndDate__c, 'End Date should be empty');
        }
    }

    @isTest
    static void validateUpdateSingleContact () {
        Contact c = new Contact(LastName = 'Doe', Status__c = STATUS_PROSPECT);
        insert c;
        
        Test.startTest();
        update new Contact(Id = c.Id, Status__c = STATUS_ACTIVE);
        Test.stopTest();

        Contact contactResult = [Select Id, Status__c, CreatedDate from Contact where Id = :c.Id limit 1];
        List<ContactStatusHistory__c> historyResult = [Select Contact__c, BeginDate__c, EndDate__c, Status__c from ContactStatusHistory__c order by CreatedDate ASC];

        //First History record should have populated Begin and End Date
        System.assert(historyResult[0].BeginDate__c != null, 'First record should have populated Beging Date');
        System.assert(historyResult[0].EndDate__c != null, 'First record should have populated End Date');
        System.assertEquals(STATUS_PROSPECT, historyResult[0].Status__c, 'First record should have populated Prospect on Status');

        //Next History record should have populated Begin, but End Date should be empty
        System.assert(historyResult[1].BeginDate__c != null, 'Second record should have populated Beging Date');
        System.assert(historyResult[1].EndDate__c == null, 'Second record should have empty value on End Date');
        System.assertEquals(STATUS_ACTIVE, historyResult[1].Status__c, 'Second record should have populated Active on Status');

    }

    @isTest
    static void validateUpdateMultipleContacts () {
        Integer recordsToInsert = 1000;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < recordsToInsert; i++) {
            contacts.add(new Contact(LastName = 'Doe' + i, Status__c = STATUS_PROSPECT));
        }
        insert contacts;

        Test.startTest();
        for (Contact c: contacts) {
            c.Status__c = STATUS_ACTIVE;
        }
        update contacts;
        Test.stopTest();

        List<Contact> contactsResult = [Select Id, Status__c, CreatedDate from Contact];
        List<ContactStatusHistory__c> historyResult = [Select Contact__c, BeginDate__c, EndDate__c, Status__c from ContactStatusHistory__c];

        for (ContactStatusHistory__c history :historyResult) {
            if (history.Status__c == STATUS_PROSPECT) {
                System.assert(history.BeginDate__c != null, 'Prospect record should have populated Beging Date');
                System.assert(history.EndDate__c != null, 'Prospect record should have populated End Date because we updated to Active');
            } else {
                System.assert(history.BeginDate__c != null, 'Active record should have populated Beging Date');
                System.assert(history.EndDate__c == null, 'Active record should not have End Date populated because is was just updated to this state');
            }
        }
    }
}
