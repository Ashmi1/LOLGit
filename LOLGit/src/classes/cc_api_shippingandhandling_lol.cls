global class cc_api_shippingandhandling_lol extends ccrz.cc_api_ShippingAndHandling{



private final String str='your shipping options ';

public override  List<ccrz.cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName)//overriding method of shipping
{
List<custom_shippingoptions__c> mcs = custom_shippingoptions__c.getall().values();//giving the given shipping options on the shipping page
 
list<ccrz.cc_ctrl_hlpr_ShippingOption> exalist=new list<ccrz.cc_ctrl_hlpr_ShippingOption>();

for(custom_shippingoptions__c si:mcs)
{ccrz.cc_ctrl_hlpr_ShippingOption exam=new ccrz.cc_ctrl_hlpr_ShippingOption(si.provider__c,si.serviceName__c,si.price__c);//creating object of type shippingoption from customsetting object
	exalist.add(exam);//adding object to list
}
return exalist;

}


}