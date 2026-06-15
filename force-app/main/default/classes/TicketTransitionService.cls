public  class TicketTransitionService {
    
    
    public static void transitionTicket(Map<Id,Ticket__c> oldMap, Map<Id,Ticket__c> newMap){
        
        for(Id ticketId : newMap.keySet()){
            Ticket__c oldTicket = oldMap.get(ticketId);
            String oldStatus = oldTicket.Status__c;
            String newStatus = newMap.get(ticketId).Status__c;

            if(!isTransitionAllowed(oldStatus, newStatus)){
                newMap.get(ticketId).addError('Invalid status transition from ' + oldStatus + ' to ' + newStatus);
            }
        }
    }


    private static Boolean isTransitionAllowed(string oldStatus , string newStatus){

        if(oldStatus == newStatus){
          return true ;
        }
            
        if(oldStatus == 'Open' && newStatus == 'In Progress'){
            return true;
        } else if(oldStatus == 'In Progress' && newStatus == 'Closed'){
            return true;
        }

        return false;
    }
}