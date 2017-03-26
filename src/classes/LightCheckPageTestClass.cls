@isTest(SeeAllData=true)

private class LightCheckPageTestClass {

 static  testmethod void myUnitTest() {
     Test.startTest();
     lead l = new lead();
     
     l.lastname='test';
     l.company = 'tester';
     
     insert l;
     
     LightCheckPageController controller = new LightCheckPageController();
     
     controller.firstComparison = 'www.test.com';
      controller.secondComparison = 'www.test.com';
       controller.thirdComparison = 'www.test.com';
       
        controller.firstemail = 'test@test.com';
      controller.secondemail= 'test@test.com';
      controller.thirdemail = 'test@test.com';
      
      controller.leadid = l.id;
      
     LightCheckPageController.createLightRef('www.test.com','www.test.com','www.test.com','test@test.com','test@test.com','test@test.com','tester',l.id);


Lightcheck_ref__c[] a = [select twitter_handle__c from Lightcheck_ref__c where twitter_handle__c = 'tester'];
     System.assertEquals(a.size(), 1);
test.stoptest();

    }
}