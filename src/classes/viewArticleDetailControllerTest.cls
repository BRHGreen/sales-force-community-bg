@isTest public class viewArticleDetailControllerTest
{

	@IsTest(SeeAllData=true) 
	static void testviewArticles()
	{


list<Tool_Box__kav> toolBoxArticles=[SELECT ArticleNumber,ArticleType,Article_Link_Title__c,Featured_Article__c,Filter_Page_Image__c,Filter_Page_Summary__c,Id,IsVisibleInCsp,KnowledgeArticleId,PublishStatus,Step_by_step__c,Summary,Title,UrlName, Language FROM Tool_Box__kav where PublishStatus ='Online' and Language = 'en_US' limit 1];



		id testId= toolBoxArticles[0].id;

		Test.startTest();
		Test.setCurrentPageReference(new PageReference('Page.ViewArticleDetails')); 
		System.currentPageReference().getParameters().put('Id', testId);

		viewArticleDetailController testView=new viewArticleDetailController();
		test.StopTest();
	}
}