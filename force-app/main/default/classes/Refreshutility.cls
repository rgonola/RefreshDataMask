public class Refreshutility {
    
    public static void process(Schema.DisplayType fieldType,Integer batchsize,String Objectname,String maskedvalue){
        
        Set < String > listsObjs = new Set < String > {Objectname}; //'Account', 'Lead','Opportunity','Contact'};      
            
        Map<String, Schema.SObjectType > globalDescription = Schema.getGlobalDescribe();   
        Map<String,List<String>> objecttofields = new Map<String,List<String>> ();
        
        for ( String obj : listsObjs ) {  
            
            Schema.sObjectType objType = globalDescription.get( obj );  
            Schema.DescribeSObjectResult r1 = objType.getDescribe();   
            Map<String , Schema.SObjectField > mapFieldList = r1.fields.getMap();    
            
            if(!objecttofields.Containskey(obj)){
                
                objecttofields.put(obj,new List<String>{});
            }
            
            for ( Schema.SObjectField field : mapFieldList.values() ) {    
                
                Schema.DescribeFieldResult fieldResult = field.getDescribe();    
                String fieldLabel = fieldResult.getLabel().toLowerCase();  
                Schema.DisplayType fielddataType = fieldResult.getType();  
                
                if ( fielddataType == fieldType ) { //Schema.DisplayType.Email ) {  
                    
                    System.debug( objType + '.' + fieldResult.getName() );  
                    
                    objecttofields.get(obj).add(fieldResult.getName());
                    
                    
                } /* else if ( fieldLabel.contains( 'email' ) && ! fieldResult.isCalculated() ) {  
                    
                    //System.debug ( objType + '.' + fieldResult.getName() );  
                    
                } */ 
                
            }   
        }  
        system.debug('objecttofields'+ objecttofields);
        
        for ( String obj : listsObjs ) {  
            String query;
            if(objecttofields.get(obj).size() > 0){
                query = 'Select '+String.join(objecttofields.get(obj),',')+' From '+obj+' Where' ;
                
                for(Integer i=0 ; i <  objecttofields.get(obj).size() ; i++  ){
                    String fld = objecttofields.get(obj)[i];
                    if(i == 0 ){
                        query = query+' ( ('+fld+' <> null AND '+fld+' <> maskedvalue ) OR' ;
                    }else if(i < (objecttofields.get(obj).size()-1)){
                        query = query+' ('+fld+' <> null AND '+fld+' <> maskedvalue ) OR' ;
                    } else {
                        query = query+' ('+fld+' <> null AND '+fld+' <> maskedvalue ))';
                    }
                }
            }
            System.debug('query'+query);
            RefreshUtil_ScheduleJobfordataupdate rs = new RefreshUtil_ScheduleJobfordataupdate(query,objecttofields.get(obj),maskedvalue);
            Database.executeBatch(rs, batchsize);
            
        }
    }
}
