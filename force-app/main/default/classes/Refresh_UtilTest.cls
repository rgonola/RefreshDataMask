@isTest
public class Refresh_UtilTest {

    static testmethod void testdata(){
        
		Contact c = new Contact();
		C.LastName = 'Test'; 
        C.Email = 'Test@gmail.com';
        
        insert c;
        
        Refreshutility.process(Schema.DisplayType.EMAIL, 1,'Contact','test@washingtonprime.net');
    }
}