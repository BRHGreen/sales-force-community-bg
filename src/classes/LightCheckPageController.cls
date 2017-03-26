public global with sharing class LightCheckPageController {


 public string leadid {get; set;}
     
    public String  firstComparison { get; set; }
   public String   secondComparison{ get; set; }
   public String   thirdComparison{ get; set; }
   public String   firstemail{ get; set; }
    public String  secondemail{ get; set; }
   public String   thirdemail{ get; set; }
     

     

@RemoteAction
global static Lightcheck_ref__c	createLightRef(string firstComparison, string secondComparison, string thirdComparison, string firstemail, string secondemail, string thirdemail, string twitterHandle, string leadid){
     Lightcheck_ref__c light = new Lightcheck_ref__c();
        light.lead__c = leadid;
    light.Website_address_for_first_comparison__c = firstComparison;
	light.Website_address_for_second_comparison__c = secondComparison;
 	light.Website_address_for_third_comparison__c = thirdComparison;
 	light.First_email_referral__c = firstemail;
 	light.Second_email_referral__c = secondemail;
	light.Third_email_referral__c = thirdemail;
light.twitter_handle__c = twitterHandle;
 insert light;


 return light;

}
}