public class RefreshUtil_ScheduleJobfordataupdate implements Database.Batchable<sObject> {
  
    public String query;
    public String maskedval;
    public List<String> fieldlst;
    
    public RefreshUtil_ScheduleJobfordataupdate(String query,List<String> fields,String maskedvalue) {
        this.query = query;
        this.fieldlst = fields;
        this.maskedval = maskedvalue;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        //do necessary operations
        //
        List<sObject> sobjectupdates = new List<sObject>();
        
        for(sObject s : scope){
            for(String sl: fieldlst){
                if( null <> s.get(sl) &&  s.get(sl) <> maskedval){
                    s.put(sl,maskedval);
                sobjectupdates.add(s);
                }
            }
           
        }
        if(sobjectupdates.size() > 0) Database.update (sobjectupdates,false);
    }

    public void finish(Database.BatchableContext bc) {
        //do necessary operations
    }
}
