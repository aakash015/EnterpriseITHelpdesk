/**
 * Service class responsible for fetching Ticket records
 * for Queue workspace and logged-in user workspace.
 */
public without sharing class TicketWorkspaceService {
    
    /**
     * Fetches all tickets assigned to the IT Support Queue.
     *
     * @return List<Ticket__c> List of tickets owned by IT Support Queue.
     */
    @AuraEnabled(cacheable=true)
    public static List<Ticket__c> getQueueTickets(){

        List<Group> queue = [
            SELECT Id,Name
            FROM Group
            WHERE Name = 'IT Support Queue'
            WITH USER_MODE
        ];
    
        List<Ticket__c> tickets = [
            SELECT Id, Name, Title__c,Description__c,Priority__c,Status__c
            FROM Ticket__c
            WHERE OwnerId = :queue[0].Id
            WITH USER_MODE
        ];

        return tickets;
    }

    /**
     * Fetches all tickets assigned to the currently logged-in user.
     *
     * WITH USER_MODE ensures records are returned
     * respecting user-level permissions and sharing.
     *
     * @return List<Ticket__c> List of tickets owned by current user.
     */
    @AuraEnabled(cacheable=true)
    public static List<Ticket__c> getMyTickets(){

        List<Ticket__c> tickets = [
            SELECT Id,Name ,Title__c,Description__c,Priority__c,Status__c
            FROM Ticket__c
            WHERE OwnerId = :UserInfo.getUserId()
            WITH USER_MODE
        ];

        return tickets;
    }
}