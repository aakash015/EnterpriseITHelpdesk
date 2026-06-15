/**
 * MajorIncidentService is an Apex class that provides functionality to create a Major Incident record and associate it with existing Ticket records.
 */
public with sharing class MajorIncidentService {

    /**
     * Creates a Major Incident record and links it to the provided Ticket records.
     * @param ticketIds Id of the tickets to be associated with the Major Incident.
     * @return void
     */
    @AuraEnabled
    public static Id createMajorIncident(
        List<Id> ticketIds
    ){

        Major_Incident__c incident =
            new Major_Incident__c(
                Summary__c = 'Major Incident Created From Workspace',
                Status__c = 'Investigating',
                Impact_Level__c = 'Medium'
            );

        insert as user incident;

        List<Ticket__c> tickets = [
            SELECT Id
            FROM Ticket__c
            WHERE Id IN :ticketIds
            WITH USER_MODE
        ];

        for(Ticket__c ticket : tickets){
            ticket.Major_Incident__c = incident.Id;
        }

        update AS USER tickets;

        return incident.Id;
    }
}