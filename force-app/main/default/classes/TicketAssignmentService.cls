/**
 * WHY WE USE THE REQUEST INNER CLASS:
 * 1. It Allows Multiple Input Fields: If your Apex method only needed an ID, 
 *    you could technically write public static void assignTicketToUser(List<Id> ticketIds).
 * 
 *    But what happens tomorrow if the business logic changes, and you also need to pass 
 *    a Reason__c string or an IsUrgent__c boolean from the Flow?
 * 
 * 2. Easy Expansion: By using an inner class like Request, you can easily expand 
 *    your inputs without breaking the method signature.
 */
public with sharing class TicketAssignmentService {
    
    /**
     * @description Wrapper class acting as a data container for input parameters 
     *              passed dynamically from a Salesforce Flow.
     */
    public class Request {
        /**
         * @description The Salesforce ID of the Ticket record to be processed.
         */
        @InvocableVariable(label='Ticket Id' required=true)
        public Id ticketId; 
    }

    /**
     * @description Invocable method called by Salesforce Flow to automatically assign 
     *              a list of tickets to the current context user executing the flow.
     * @param requests A list of Request objects containing the target Ticket IDs.
     */
    @InvocableMethod(label='Assign Ticket to User' description='Assigns the specified tickets to the current running user.')
    public static void assignTicketToUser(List<Request> requests){

        List<Id> ticketIds = new List<Id>();

        for(Request req : requests){
            if (req.ticketId != null) {
                ticketIds.add(req.ticketId);
            }
        }
       
        List<Ticket__c> ticketsToUpdate = new List<Ticket__c>();

        for(Ticket__c ticket : [SELECT Id, OwnerId FROM Ticket__c WHERE Id IN :ticketIds WITH USER_MODE]){
            ticket.OwnerId = UserInfo.getUserId();
            ticketsToUpdate.add(ticket);
        }

        if(!ticketsToUpdate.isEmpty()) {
            update as user ticketsToUpdate;
        }

        
    }
}