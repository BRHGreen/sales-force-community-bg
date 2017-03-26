public class CommunityHowToGuidesController
{

	public id currentUserId {get;set;}
	public user currentUser {get;set;}
	public contact con {get;set;}
	public account acc {get;set;}

	public List<HELP__kav> helpArticlesList {get;set;} 

	public List<HELP__kav> helpArticlesEvenList {get;set;} 
	public List<HELP__kav> helpArticlesOddList {get;set;} 

	public List<KnowledgeArticleVersion> ArticlesList {get;set;} 
	transient public Set<String> HelpFilters {get;set;}
	transient public Set<String> ToolboxFilters {get;set;}
	public Set<id> ArticleId {get;set;}
	public map<String,List<HELP__kav>> filteredArticleList {get;set;}
	public map<String,List<Tool_Box__kav>> filteredArticleList2 {get;set;}
	public List<HELP__kav> dynamicList {get;set;}
		public List<Tool_Box__kav> dynamicList2 {get;set;}

	public boolean viewGettingStarted{Get;set;}
	public boolean showMessages{get; set;}

	public boolean viewSettings{get;set;}
	public boolean viewAbout {get;set;}
	public String currentTab {get;set;}

	public boolean viewProfileFlag {get;set;}
	public boolean editProfileFlag {get;set;}

	public List<KnowledgeArticleVersion> featureArticlesList {get;set;}
	public Set<id> featureArticleId {get;set;}
	public List<Tool_Box__kav> toolBoxArticlesList {get;set;} 
	public List<Tool_Box__kav> toolBoxFeaturedArticlesList {get;set;}

	// for pagination
    transient public Integer helpPageSize {get;set;}
    transient public Integer featuredPageSize {get;set;}
    transient public Integer toolBoxPageSize {get;set;}

    transient public Integer currentToolBoxPage  {get;set;}
    transient public Integer currentFeaturedPage  {get;set;}
    transient public Integer currentHelpPage  {get;set;}

    transient public String currentHelpPageInfo   {get;set;}
   transient  public String currentToolBoxPageInfo   {get;set;}
   transient  public String currentFeaturedPageInfo   {get;set;}

    public Boolean showHelpPrevious {get;set;}
    public Boolean showToolboxPrevious {get;set;}
    public Boolean showFeaturedPrevious {get;set;}

    public Boolean showHelpNext {get;set;}
    public Boolean showToolboxNext {get;set;}
    public Boolean showFeaturedNext {get;set;}

    transient private integer totalFeaturedRecords {get;set;}
    transient private integer totalHelpRecords {get;set;}
    transient private integer totalToolboxRecords {get;set;}

    transient private integer helpPageNumber {get;set;}
    transient private integer toolBoxPageNumber {get;set;}
   transient  private integer featuredPageNumber {get;set;}

    public String searchTerm {get;set;}
    public List<Help__kav> searchHelpArticlesTitleList {get;set;}
    public List<Help__kav> searchHelpArticlesSummaryList {get;set;}
    public List<Tool_Box__kav> searchToolBoxArticlesTitleList {get;set;}
    public List<Tool_Box__kav> searchToolBoxArticlesSummaryList {get;set;}

    public blob profilepicBlob {get;set;}
    public string profileContentType {get;set;}
    public string fileName {get;set;}

	//To display messaged on community home page

	public List<Community_Home_Page_Message__c> msgsList {get;set;}
	public boolean showingSearchResults {get;set;}

	public CommunityHowToGuidesController()
	{
		currentUserId=UserInfo.getUserID();

		currentUser=[select id,name,firstname,lastname,contactid,fullphotourl,phone from user where id= :CurrentUserId];
		con=new contact();
		acc=new account();
		showingSearchResults=false;

		if(currentUser.contactid != null)
		{
			con=[select id,name,firstname,lastname,CharityRegNum__c,phone,AccountId from Contact where id=: currentUser.contactid];
			acc=[select id,name from account where id=:con.AccountId];

			System.debug('Contact details : '+con);
		}
		viewAbout=false;
		viewSettings=false;
		viewGettingStarted=true;
		viewProfileFlag=true;
		editProfileFlag=false;
		
		searchTerm=null;

		ArticlesList=[SELECT CreatedDate,Id,IsVisibleInCsp,KnowledgeArticleId,Language,PublishStatus,Title FROM KnowledgeArticleVersion WHERE PublishStatus = 'online' AND Language = 'en_US' and IsVisibleInCsp=true];
		System.debug('List of all Articles : ' +ArticlesList);

		ArticleId= new set<id>();
		for(KnowledgeArticleVersion a: ArticlesList)
			ArticleId.add(a.KnowledgeArticleId);
		helpArticlesList = [SELECT ID, KnowledgeArticleId, Title, Summary,Filter_Section__c,Answer__c,PublishStatus,IsVisibleInCsp,VersionNumber FROM HELP__kav WHERE PublishStatus = 'online' and IsVisibleInCsp=true and KnowledgeArticleId in :ArticleId ORDER BY Title ASC NULLS FIRST];
		System.debug('List of Help Articles : ' +helpArticlesList);

	toolboxArticlesList = [SELECT ID, KnowledgeArticleId, Title,Filter_Section__c,Step_by_step__c,PublishStatus,IsVisibleInCsp,Summary FROM Tool_Box__kav WHERE PublishStatus = 'online' and IsVisibleInCsp=true and KnowledgeArticleId in :ArticleId];
		System.debug('List of Toolbox Articles : ' +toolboxArticlesList);


		HelpFilters= new Set<String>();
		filteredArticleList= new map<String,List<HELP__kav>>();

		For(HELP__kav filter: helpArticlesList){
			system.debug('List of Help filters : ' +filter.Filter_Section__c);
			HelpFilters.add(filter.Filter_Section__c);
			filteredArticleList.put(filter.Filter_Section__c,null);
		}

		
		//dynamically filter the list based on topic and add to map
		for(String s: HelpFilters)
		{
			//topic wise filtered list dynamically
			dynamicList = new List<HELP__kav>();
			for(HELP__kav h:helpArticlesList)
			{
				if(h.Filter_Section__c == s)
					dynamicList.add(h);
			}
			System.debug('dynamicList value : ' +dynamicList);

			filteredArticleList.put(s,dynamicList);
			
		}	

	ToolboxFilters= new Set<String>();
filteredArticleList2= new map<String,List<Tool_Box__kav>>();
for(String s: ToolboxFilters)
		{
			//topic wise filtered list dynamically
			dynamicList2 = new List<Tool_Box__kav>();
			for(Tool_Box__kav h:toolboxArticlesList)
			{
				if(h.Filter_Section__c == s)
					dynamicList2.add(h);
			}
			System.debug('dynamicList value : ' +dynamicList2);

			filteredArticleList2.put(s,dynamicList2);
			
		}	


		System.debug('List of filtered Toolbox Articles map: ' +filteredArticleList2);

		System.debug('currentTab value: '+this.currentTab);
	

		//for toolbox related articles
		toolBoxArticlesList = [SELECT ArticleNumber,ArticleType,Article_Views__c,Article_Link_Title__c,Featured_Article__c,Filter_Page_Image__c,Filter_Page_Summary__c,Id,KnowledgeArticleId,Language,Title,VersionNumber,Summary FROM Tool_Box__kav WHERE PublishStatus = 'online' and KnowledgeArticleId in :ArticleId];
		System.debug('List of toolbox Articles : ' +toolBoxArticlesList);

		//pull only featured articles
		toolBoxFeaturedArticlesList = [SELECT ArticleNumber,Article_Views__c,ArticleType,Article_Link_Title__c,Featured_Article__c,Filter_Page_Image__c,Filter_Page_Summary__c,Id,KnowledgeArticleId,Language,Title FROM Tool_Box__kav WHERE PublishStatus = 'online' and KnowledgeArticleId in :ArticleId and Featured_Article__c = true];
		System.debug('List of featured only toolbox Articles : ' +toolBoxFeaturedArticlesList);

		msgsList=[SELECT Display_Message__c,Id,Message__c,Name,OwnerId FROM Community_Home_Page_Message__c where Display_Message__c=true];
		system.debug('Home page msgs: '+msgsList);
		if(msgsList.size() > 0){

		showMessages = true;

		} else { showMessages = false;}


		//initiallisation for pagination of all tabs
		totalToolboxRecords=toolBoxArticlesList.size();
    	totalHelpRecords=helpArticlesList.size();
    	totalFeaturedRecords=toolBoxFeaturedArticlesList.size();

    	currentHelpPage=0;currentFeaturedPage=0;currentToolBoxPage=0;
		 helpPageSize=1;featuredPageSize=2;toolBoxPageSize=2;
		 helpPageNumber=1; toolBoxPageNumber=1; featuredPageNumber=1;

    	showFeaturedPrevious=false;showToolboxPrevious=false;showHelpPrevious=false;
    	
    	//for help page
    	if(totalhelpRecords > helpPageSize)
	            showHelpNext = true;
	        else
	            showHelpNext = false;
	    currentHelpPageInfo = 'Showing Page ' + helpPageNumber +   ' of ' + (Math.mod(totalhelpRecords, helpPageSize) == 0 ? totalhelpRecords/helpPageSize : (totalhelpRecords/helppageSize) + 1);
    	
    	//for tool box page
  		if(totalToolBoxRecords > toolboxPageSize)
	            showToolboxNext = true;
	        else
	            showToolboxNext = false;
	    currentToolboxPageInfo = 'Showing Page ' + toolboxPageNumber +   ' of ' + (Math.mod(totaltoolboxRecords, toolBoxPageSize) == 0 ? totaltoolboxRecords/toolboxPageSize : (totaltoolboxRecords/toolboxpageSize) + 1);
    
    	//for featured articles list on home page
   		 if(totalfeaturedRecords > helpPageSize)
	            showFeaturedNext = true;
	        else
	            showFeaturedNext = false;
	    currentfeaturedPageInfo = 'Showing Page ' + featuredPageNumber +   ' of ' + (Math.mod(totalfeaturedRecords, featuredPageSize) == 0 ? totalfeaturedRecords/featuredPageSize : (totalfeaturedRecords/featuredpageSize) + 1);


	    searchHelpArticlesTitleList=new List<Help__kav>();
	    searchHelpArticlesSummaryList=new List<Help__kav>();
	    searchToolBoxArticlesTitleList=new List<Tool_Box__kav>();
	    searchToolBoxArticlesSummaryList=new List<Tool_Box__kav>();

	    //to split and display the help articles in two columns
	    helpArticlesOddList = new List<Help__kav>();
	    helpArticlesEvenList = new List<Help__kav>();

	    integer i=1;
	    for(Help__kav h:helpArticlesList)
	    {
	    	if(math.mod(i, 2) == 0)
	    		helpArticlesEvenList.add(h);
	    	else
	    		helpArticlesOddList.add(h);
	    	i++;
	    	
	    }



    
	}


	public void showBasedonTopic()
	{
		System.debug('currentTab value: '+this.currentTab);

		if(this.currentTab == 'Getting Started')
		{
		viewGettingStarted=true;
		viewSettings=false;
		viewAbout=false;
		}
		else if(this.currentTab == 'Settings')
		{
		viewGettingStarted=false;
		viewSettings=true;
		viewAbout=false;
		}
		else if(this.currentTab == 'About Lightful')
		{
		viewGettingStarted=false;
		viewSettings=false;
		viewAbout=true;
		}
	}

public string filterArticles {get; set;}

public void filterHelpArticles()
{

helpArticlesList = [SELECT ID, KnowledgeArticleId, Title, Summary,Filter_Section__c,Answer__c,Article_Views__c,PublishStatus,IsVisibleInCsp FROM HELP__kav WHERE PublishStatus = 'online' and IsVisibleInCsp=true and KnowledgeArticleId in :ArticleId and Filter_Section__c =: filterArticles ORDER BY Title ASC NULLS FIRST];

}
	
	public void updateUserPic()
	{
        String communityId = null;
       
        // Set photo
        System.debug('profilepicBlob content :' +this.profilepicBlob);
        System.debug('profilepic content type & file name :' +this.profileContentType +this.fileName);
         ConnectApi.BinaryInput photoFileInput =
            new ConnectApi.BinaryInput(this.profilepicBlob, this.profileContentType, this.filename);
        
        ConnectApi.UserProfiles.setPhoto(communityId, currentUserId, photoFileInput);
       
       	currentUser=[select id,name,firstname,lastname,contactid,fullphotourl,phone from user where id= :CurrentUserId];
       	this.fileName=null;
       	this.profileContentType=null;
         //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'File uploaded successfully. It takes a moment to update. Please refresh the page ' ));
	}

	public void updateProfile()
	{
		//Update the values of the contact
		System.debug('Updated Contact details : ' +this.con);

		update this.con;

		editProfileFlag=false;
		viewProfileFlag=true;

	}
	public void showEditProfile()
	{
		editProfileFlag=true;
		viewProfileFlag=false;
	}

	public void cancelEdit()
	{
		editProfileFlag=false;
		viewProfileFlag=true;
	}


	private void updateHelpPageDetail()
    {
    	//for help page tab    	
    	if(currenthelpPage == 0)
            showhelpPrevious = false;
        else
            showhelpPrevious = true;
        if((totalhelpRecords - helppageSize) <= currenthelpPage)
            showhelpNext = false;
        else
            showhelpNext = true;

        totalhelpRecords=helpArticlesList.size();
    	currentHelpPageInfo = 'Showing Page ' + helpPageNumber +   ' of ' + (Math.mod(totalhelpRecords, helpPageSize) == 0 ? totalhelpRecords/helpPageSize : (totalhelpRecords/helppageSize) + 1);

     }

     private void updateToolboxPageDetail()
     {       
    	//for toolbox articles page tab    	
    	if(currentToolboxPage == 0)
            showToolboxPrevious = false;
        else
            showToolboxPrevious = true;
        if((totalToolboxRecords - toolboxpageSize) <= currentToolboxPage)
            showToolboxNext = false;
        else
            showToolboxNext = true;

        totalToolboxRecords=toolboxArticlesList.size();
    	currentToolboxPageInfo = 'Showing Page ' + toolboxPageNumber +   ' of ' + (Math.mod(totalToolboxRecords, toolboxPageSize) == 0 ? totalToolboxRecords/toolboxPageSize : (totalToolboxRecords/toolboxpageSize) + 1);
    }

     private void updateFeaturedPageDetail()
     {   
    	
    	//for featured articles - home page tab    	
    	if(currentFeaturedPage == 0)
            showFeaturedPrevious = false;
        else
            showFeaturedPrevious = true;
        if((totalFeaturedRecords - featuredpageSize) <= currentFeaturedPage)
            showFeaturedNext = false;
        else
            showFeaturedNext = true;

        totalFeaturedRecords=toolBoxFeaturedArticlesList.size();
    	currentFeaturedPageInfo = 'Showing Page ' + featuredPageNumber +   ' of ' + (Math.mod(totalFeaturedRecords, featuredPageSize) == 0 ? totalFeaturedRecords/featuredPageSize : (totalFeaturedRecords/featuredpageSize) + 1);

    }
    
    public void showHelpPrevious()
    {
	     currenthelpPage = currenthelpPage - helppageSize;
		helppageNumber--;

		 updateHelpPageDetail();    
    }
    public void showToolboxPrevious()
    {	 
		currentToolboxPage = currentToolboxPage - toolBoxPageSize;
		toolBoxPageNumber--;

		updateToolboxPageDetail();
	}

	public void showFeaturedPrevious()
	{
		currentFeaturedPage = currentFeaturedPage - featuredpageSize;
		featuredPageNumber--;

		updateFeaturedPageDetail();
	}

	 public void showHelpNext()
    {
	 	 currenthelpPage = currenthelpPage + helppageSize;
       helppageNumber++;

       updateHelpPageDetail();
     }

	public void showToolboxNext()
	{      
     
       currentToolboxPage=currentToolboxPage + toolBoxPageSize;
       toolBoxPageNumber++;

       updateToolboxPageDetail();
     }

     public void showFeaturedNext()
     {
       currentFeaturedPage=currentFeaturedPage + featuredPageSize;
       featuredPageNumber++;

       updateFeaturedPageDetail();
   	}

    public void showHelpFirst()
    {
       currenthelpPage = 0; 
       helppageNumber = 1; 

       updateHelpPageDetail();
    }

      public void showToolboxFirst()
    {
       currentToolboxPage=0; toolboxPageNumber=1;

       updateToolboxPageDetail();
    }

      public void showFeaturedFirst()
    {
       currentFeaturedPage=0;
       featuredPageNumber=1;

       updateFeaturedPageDetail();
    }

    public void showHelpLast()
    {
        currenthelpPage = (Math.mod(totalhelpRecords, helppageSize) == 0) ? totalhelpRecords - helppageSize : (totalhelpRecords / helppageSize) * helppageSize;
        helppageNumber = (Math.mod(totalhelpRecords, helppageSize) == 0 ? totalhelpRecords/helppageSize : (totalhelpRecords/helppageSize) + 1);
        
        updateHelpPageDetail();
    }

      public void showToolboxLast()
    {
        currentToolboxPage = (Math.mod(totalToolboxRecords, toolboxpageSize) == 0) ? totalToolboxRecords - toolboxpageSize : (totalToolboxRecords / toolboxpageSize) * toolboxpageSize;
        toolboxpageNumber = (Math.mod(totalToolboxRecords, toolboxpageSize) == 0 ? totalToolboxRecords/toolboxpageSize : (totalToolboxRecords/toolboxpageSize) + 1);
        
        updateToolboxPageDetail();
    }

      public void showFeaturedLast()
    {       
		currentfeaturedPage = (Math.mod(totalfeaturedRecords, featuredpageSize) == 0) ? totalfeaturedRecords - featuredpageSize : (totalfeaturedRecords / featuredpageSize) * featuredpageSize;
        featuredpageNumber = (Math.mod(totalfeaturedRecords, featuredpageSize) == 0 ? totalfeaturedRecords/featuredpageSize : (totalfeaturedRecords/featuredpageSize) + 1);
       
        updateFeaturedPageDetail();
    }

    public integer searchTListTitleSize {get;set;}
    public integer searchTListSumSize {get;set;}
    public integer searchHListTitleSize {get;set;}
    public integer searchHListSumSize {get;set;}

    public void searchArticles()
    {
    	showingSearchResults=true;

		searchTerm = ApexPages.currentPage().getParameters().get('searchTerm');
		
    	System.debug('Help ARticles search based on : '+ searchTerm);
    	
    	searchHelpArticlesTitleList.clear();searchHelpArticlesSummaryList.clear();
    	searchToolBoxArticlesTitleList.clear();searchToolBoxArticlesSummaryList.clear();

		for(Help__kav sh: helpArticlesList)
		{
			if(sh.title.containsIgnoreCase(searchTerm))
				searchHelpArticlesTitleList.add(sh);
			else if(sh.Answer__c.containsIgnoreCase(searchTerm))
				searchHelpArticlesSummaryList.add(sh);
		}

		for(Tool_Box__kav st: toolboxArticlesList)
		{
			if(st.title.containsIgnoreCase(searchTerm) || st.Article_Link_Title__c.containsIgnoreCase(searchTerm))
				searchToolBoxArticlesTitleList.add(st);
			else if(st.summary.containsIgnoreCase(searchTerm) || st.Filter_Page_Summary__c.containsIgnoreCase(searchTerm))
				searchToolBoxArticlesSummaryList.add(st);

		}

		searchHListSumSize=searchHelpArticlesSummaryList.size();
		searchHListTitleSize=searchHelpArticlesTitleList.size();

		searchTListSumSize=searchToolBoxArticlesSummaryList.size();
		searchTListTitleSize=searchToolBoxArticlesTitleList.size();


		System.debug('searchTListSumSize  searchTListTitleSize '+ searchTListSumSize +searchTListTitleSize);
		System.debug('searchHListSumSize searchHListTitleSize '+ searchHListSumSize +searchHListTitleSize);
		System.debug('searchHelpArticlesTitleList  searchHelpArticlesSummaryList '+ searchHelpArticlesTitleList +searchHelpArticlesSummaryList);
		System.debug('searchToolBoxArticlesTitleList searchToolBoxArticlesSummaryList '+ searchToolBoxArticlesTitleList +searchToolBoxArticlesSummaryList);
		
    }

}