trigger TicketTransitionTrigger on Ticket__c (before update) {

    TicketTransitionService.transitionTicket(Trigger.oldMap,Trigger.newMap);
}