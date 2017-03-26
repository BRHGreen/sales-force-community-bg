public class SlackLeadPublisher {

     
    private static final String slackURL = 'https://hooks.slack.com/services/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';
     
    public class NewLead {
        @InvocableVariable(label='Name:')
        public String LeadName;
        @InvocableVariable(label='Twitter ID:')
        public String TwitterID;
    }
     
    @InvocableMethod(label='Post to Slack')
    public static void postToSlack(List<Newlead> Leads) {
              
        NewLead l = Leads[0]; // If bulk, only post first to avoid overloading Slack channel
        Map<String,Object> msg = new Map<String,Object>();
        msg.put('text', 'Whoop whoop we have a new lead :\n Name: ' + l.LeadName + '\n Twitter ID: *' + l.TwitterID + '*');
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