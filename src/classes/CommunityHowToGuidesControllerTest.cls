@isTest public class CommunityHowToGuidesControllerTest
{

	@IsTest(SeeAllData=true) 
	static void testMethod1()
	{
		
		test.starttest();
        CommunityHowToGuidesController c = new CommunityHowToGuidesController();
	    c.currentUserId='00524000005TlAq';   
		c.currentUser=[select id,name,firstname,lastname,contactid,fullphotourl,phone from user where id= :c.CurrentUserId];
        
        System.assertEquals(true, c.currentUser.contactID != null);
        c.con=[select id,name,accountId from contact where id= '0032400000TXuWM'];
        c.acc=[select id,name from account where id=: c.con.accountid];
        system.assertEquals(true,c.con.id != null);
        system.assertEquals(true,c.acc.id != null);
        
      //  c.searchHelpArticleTerm='test';
        c.searchArticles();
        system.debug(c.searchHelpArticlesList);
        
      //  c.searchToolboxArticleTerm='test';
        c.searchArticles();
        system.debug(c.searchToolBoxArticlesList);
        
		test.stoptest();

	}
    @IsTest(SeeAllData=true)
    static void testHelp()
	{
		
		test.starttest();
        CommunityHowToGuidesController c = new CommunityHowToGuidesController();
	    c.currentUserId='00524000005TlAq';   
		c.currentUser=[select id,name,firstname,lastname,contactid,fullphotourl,phone from user where id= :c.CurrentUserId];
        
        System.assertEquals(true, c.currentUser.contactID != null);
        c.con=[select id,name,accountId from contact where id= '0032400000TXuWM'];
        c.acc=[select id,name from account where id=: c.con.accountid];
        system.assertEquals(true,c.con.id != null);
        system.assertEquals(true,c.acc.id != null);
        
        c.currenttab='Getting Started';
        c.showBasedonTopic();
        
        c.currenttab='About Lightful';
        c.showBasedonTopic();
        
        c.currenttab='Settings';
        c.showBasedonTopic();
		test.stoptest();

	}
    @IsTest(SeeAllData=true)
    static void testProfile()
	{
		
		test.starttest();
        CommunityHowToGuidesController c = new CommunityHowToGuidesController();
	    c.currentUserId='00524000005TlAq';   
		c.currentUser=[select id,name,firstname,lastname,contactid,fullphotourl,phone from user where id= :c.CurrentUserId];
        
        System.assertEquals(true, c.currentUser.contactID != null);
        c.con=[select id,name,accountId,phone from contact where id= '0032400000TXuWM'];
        c.acc=[select id,name from account where id=: c.con.accountid];
        system.assertEquals(true,c.con.id != null);
        system.assertEquals(true,c.acc.id != null);
        
        c.showEditProfile();
        system.assertEquals(true, c.editProfileFlag);
        system.assertEquals(false, c.viewProfileflag);
        
        c.cancelEdit();
        system.assertEquals(false, c.editProfileFlag);
        system.assertEquals(true, c.viewProfileflag);
        
         c.showEditProfile();
        c.con.phone='12344556';
        c.updateProfile();
        
		test.stoptest();

	}
    @IsTest(SeeAllData=true)
    static void testPagination()
	{
		
		test.starttest();
        CommunityHowToGuidesController c = new CommunityHowToGuidesController();
	    c.currentUserId='00524000005TlAq';   
		c.currentUser=[select id,name,firstname,lastname,contactid,fullphotourl,phone from user where id= :c.CurrentUserId];
        
       //for home page
       c.showFeaturedNext();
        c.showFeaturedFirst();
        c.showFeaturedLast();
        c.showFeaturedPrevious();
        
        //for toolbox articles tab
        c.showToolboxNext();
        c.showToolboxLast();
        c.showToolboxPrevious();
        c.showToolboxFirst();
        
        //for help page tab
        c.showHelpNext();
        c.showHelpPrevious();
        c.showHelpLast();
        c.showHelpFirst();
        
     	test.stoptest();

	}
}