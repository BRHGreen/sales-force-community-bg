public class SlackCasePublisherClass {

     
    private static final String slackURL = 'https://hooks.slack.com/services/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';
     
    public class NewCase {
        @InvocableVariable(label='CaseID:')
        public String CaseID;
        @InvocableVariable(label='CaseNumber:')
        public String CaseNumber;
        @InvocableVariable(label='Description:')
        public String Description;
    }
     
    @InvocableMethod(label='Post to Slack')
    public static void postCaseToSlack(List<NewCase> Cases) {
              
        NewCase C = Cases[0]; // If bulk, only post first to avoid overloading Slack channel
        Map<String,Object> msg = new Map<String,Object>();
        msg.put('text', 'New P1 Case : <https://cs88.salesforce.com/' + C.CaseID +'|'  + C.CaseNumber +'> \n Description : *' + c.Description  + '*');
        msg.put('mrkdwn', true);
        String body = JSON.serialize(msg);    
        System.enqueueJob(new QueueableSlackCall(slackURL, 'POST', body));
    }
     
    public class QueueableSlackCall implements System.Queueable, Database.AllowsCallouts {
         
        private final String url;
        private final String method;
        private final String body;
         
        public QueueableSlackCall(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
        }
         
        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
        }
 
    }
    

}