@isTest

public class SlackLeadPublisherTestClass {

    
    
    public static testmethod void slackpushtest(){
        
        lead l = new lead();
        
        l.LastName = 'sf test';
       l.Company = 'sf test';
       
        l.Twitter_ID__c = '12345';
        insert l;
        
        
        SlackLeadPublisher.NewLead sp = new SlackLeadPublisher.NewLead();

sp.LeadName = l.lastname;
        sp.twitterid = l.Twitter_ID__c;
        
       
  
    
        
      
        
    }
    
}