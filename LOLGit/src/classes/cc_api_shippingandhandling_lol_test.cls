@isTest
private class cc_api_shippingandhandling_lol_test{
@isTest public static void setuptestdata(){
list<ccrz.cc_ctrl_hlpr_ShippingOption> exalist1=new list<ccrz.cc_ctrl_hlpr_ShippingOption>();
cc_api_ShippingAndHandling_lol ex=new cc_api_ShippingAndHandling_lol(); 
ccrz__E_Cart__c cart = new ccrz__E_Cart__c();//creating cart
custom_shippingoptions__c sampletest=new custom_shippingoptions__c();//creating custom setting record and creating smaple test data
sampletest.Name='Amazon';
sampletest.provider__c='Amazon';
sampletest.serviceName__c='hello';
sampletest.price__c=909;
insert sampletest; 
test.startTest(); 
exalist1=ex.getShippingOptions('1234','4567','9876',cart.id,'9887');//invoking the class method
test.stopTest();
System.assertEquals('Amazon',exalist1[0].provider);
System.assertEquals('hello',exalist1[0].serviceName);
System.assertEquals(909,exalist1[0].price);
}
}