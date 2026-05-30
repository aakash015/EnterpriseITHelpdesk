import getMyTickets from '@salesforce/apex/TicketWorkspaceService.getMyTickets';
import getQueueTickets from '@salesforce/apex/TicketWorkspaceService.getQueueTickets';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, wire } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import { subscribe } from 'lightning/empApi';

const actions = [
    {label : "Assign To Me" , name : 'assign_to_me'}
]

const COLUMNS = [
    {label: 'Title', fieldName: 'Title__c' },
    {label: 'Status', fieldName: 'Status__c'},
    {label: 'Priority', fieldName: 'Priority__c'},
    {label: 'Description', fieldName: 'Description__c'}
];

const QueueColumns = [...COLUMNS , {
    type : 'action',
    typeAttributes : {
        rowActions : actions
    }
}]; 




export default class TicketWorkspace extends LightningElement {
    columns = COLUMNS;
    queueColumns = QueueColumns;
    myTickets = [];
    queueTickets = [];

    connectedCallback(){
        this.subscribeToTicketUpdates();
    }

    subscribeToTicketUpdates(){
        console.log('Subscribing to ticket updates');
        subscribe('/data/Ticket__ChangeEvent', -1, (message) => {
            console.log('Received ticket update:', message);
            this.handleStatusChange();
        }).then((response) => {
            console.log('Subscribed to channel ', response.channel);
            this.subscription = response;
        });
    
    }

    @wire(getMyTickets)
    wiredMyTickets(getMyTickets){
        console.log('Wired My Tickets:', getMyTickets);
        this.wiredMyTickets = getMyTickets;
        const {error,data} = getMyTickets;
        if(error){
            this.dispatchEvent(new ShowToastEvent({
                title : 'Error loading tickets',
                message : error.message,
                variant : 'error'
            }))
        }else if(data){
            console.log('My Tickets:', data);
            this.myTickets = data;
        }
    }


    @wire(getQueueTickets)
    wiredQueueTickets(queueTickets){
        console.log('Wired Queue Tickets:', queueTickets);
        this.wiredQueueTickets = queueTickets;
        const {error,data} = queueTickets;
        if(error){
            this.dispatchEvent(new ShowToastEvent({
                title : 'Error loading tickets',
                message : error.message,
                variant : 'error'
            }))
        }else if(data){
            console.log('Queue Tickets:', data);
            this.queueTickets = data;
        }
    }

    handleRowAction(event){
        const actionName = event.detail.action.name; 
        
        switch(actionName){
            case 'assign_to_me' : 
                this.assignToMe(event.detail.row);
                break;
        }
    }

    assignToMe(row){
        let inputVariables = [
            {
                name : 'recordId',
                type:'String',
                value : row.Id
            }
        ];

        this.template.querySelector('lightning-flow').startFlow('Assign_To_Me', inputVariables);
    }

    handleStatusChange(){
        console.log("Status changed, refreshing queues");
        refreshApex(this.wiredQueueTickets);
        refreshApex(this.wiredMyTickets);
    }

    
}