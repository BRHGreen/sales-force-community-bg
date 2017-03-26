public class viewArticleDetailController
{

    public Tool_Box__kav toolBoxArticles {get;set;}
    public Help__kav helpArticle {get;set;}
    public id articleId {get;set;}

    public CommunityArticleView__c updateViewCount {get;set;}
    public List<CommunityArticleView__c> viewsCount {get;set;}
    public string articleType {get;set;}
    public id currentUserId {get;set;}

    public viewArticleDetailController()
    {

      currentUserId=UserInfo.getUserID();

        toolBoxArticles = new Tool_Box__kav();
        helpArticle=new Help__kav();
        
        updateViewCount=new CommunityArticleView__c();
        viewsCount=new List<CommunityArticleView__c>();

         articleId=ApexPages.currentPage().getParameters().get('Id');
         articleType=ApexPages.currentPage().getParameters().get('Type');
         System.debug('Article ID ' +articleId +articleType);

         if(articleType == 'Tool_Box__kav')
         { 
             toolBoxArticles=[SELECT ArticleNumber,VersionNumber ,ArticleType,Article_Link_Title__c,Featured_Article__c,Filter_Page_Image__c,Filter_Page_Summary__c,Id,IsVisibleInCsp,KnowledgeArticleId,PublishStatus,Step_by_step__c,Summary,Title,UrlName FROM Tool_Box__kav where id=: articleId];
            
            //gather records based on user based, article details with respect to version
             viewsCount=[select id,ArticleID__c,ViewsCount__c,Version__c,User__c,ArticleType__c  FROM CommunityArticleView__c where ArticleID__c=: articleId and Version__c =: toolBoxArticles.VersionNumber and User__c =: currentUserId];  

            if(viewsCount.size() >0){ 
                for(CommunityArticleView__c v: viewsCount)
                {
                  //updateViewCount=[SELECT ArticleID__c,Id,Name,Version__c,ViewsCount__c FROM CommunityArticleView__c where id=: v.id];
                  updateViewCount.id=v.id;
                  updateViewCount.ViewsCount__c=v.ViewsCount__c+1;
                }
                
            } 
            else{
                    updateViewCount.ArticleID__c=toolBoxArticles.id;
                    updateViewCount.Version__c=toolBoxArticles.VersionNumber;
                    updateViewCount.ArticleType__c=toolBoxArticles.ArticleType;
                    updateViewCount.User__c=currentUserId;
                    updateViewCount.ViewsCount__c=1;
                }
          
              
         }

         /*if(articleType == 'Help__kav')
         {
            helpArticle=[SELECT ID, KnowledgeArticleId, VersionNumber, Title, Summary,Question__c,Article_Views__c,Filter_Section__c,Answer__c,PublishStatus,IsVisibleInCsp FROM HELP__kav where id=: articleId ];

            viewsCount=[select id,ArticleID__c,ViewsCount__c,Version__c,User__c FROM CommunityArticleView__c where ArticleID__c=: articleId and Version__c =: helpArticle.VersionNumber];  

            if(viewsCount.size() >0){ 
                for(CommunityArticleView__c v: viewsCount)
                {
                  //updateViewCount=[SELECT ArticleID__c,Id,Name,Version__c,ViewsCount__c,User__c FROM CommunityArticleView__c where id=: v.id];
                    updateViewCount.add(v);
                    updateViewCount.ViewsCount__c++;
                }
                
            } 
            else{
                    updateViewCount.ArticleID__c=helpArticle.id;
                    updateViewCount.Version__c=helpArticle.VersionNumber;
                    updateViewCount.ArticleType__c=helpArticle.ArticleType;
                    updateViewCount.User__c=currentUserId;
                    
                    updateViewCount.ViewsCount__c=1;
                }
          

         }*/
         System.debug('Article Id: '+articleId);
    }
    public void updateViewCounts()
    {
        if(updateViewCount.id == null)
            insert updateViewCount;
        else
            update updateViewCount;

        System.debug('CommunityArticleView__c updateViewCount values: ' + updateViewCount);
        
    }
}