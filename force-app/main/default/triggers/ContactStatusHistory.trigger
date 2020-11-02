/**
 * Iterate over all Trigger.new records and we will be considering 2 scenarios -
 * 1. If it's INSERT - create a new Contact Status History and populate Begin Date - End Date will be empty
 * 2. If it's UPDATE - query existing Contact Status History filtered by End Date = null and order by CreatedDate DESC -
*  - Update End Date AND create a new Contact Status History and populate Begin Date
 */
trigger ContactStatusHistory on Contact (after insert, after update) {
    // I'll need 2 structures, one for update existing History records and a another to create the new ones.
    Map<Id, String> contactsToUpdate = new Map<Id, String>();
    List<ContactStatusHistory__c> history = new List<ContactStatusHistory__c>();
    for(Contact c : Trigger.New) {
        //If it's after insert or after update I'll need to create a Contect Status History
        if(String.isNotEmpty(c.Status__c)) {
            history.add(ContactStatusHistoryUtil.createStatusHistory(c.Id, c.Status__c, System.now(), null));
        }
        if (Trigger.isUpdate && Trigger.oldMap.get(c.Id).Status__c != c.Status__c) {
            // Bulkify records to be updated into a map
            contactsToUpdate.put(c.Id, Trigger.oldMap.get(c.Id).Status__c);    
        }
    } 
    
    // Update End Date in existing Contact Status History records
    List<ContactStatusHistory__c> updateExistingHistory = ContactStatusHistoryUtil.retrieveLastStatusHistory(contactsToUpdate.keySet());
    if (!updateExistingHistory.isEmpty()) {
        for (ContactStatusHistory__c c :updateExistingHistory) {
            c.EndDate__c = System.now();
        }
    }

    update updateExistingHistory;
    insert history;
}