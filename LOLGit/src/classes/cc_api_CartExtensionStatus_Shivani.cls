global class cc_api_CartExtensionStatus_Shivani extends ccrz.cc_api_CartExtension {

private boolean isValidated = false;

global override boolean allowCheckout(Map<String,Object> inputData) {
return validate((ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN));

}

private Boolean validate(ccrz.cc_bean_CartSummary inputData) {

     String cartId = inputData.sfid;
     boolean isAllowCheckout =true;
     List<ccrz__E_CartItem__c> cartItemList = [SELECT ccrz__Product__r.ccrz__ProductId__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId];
     List<ID> productIdList = new List<ID>();
     for (ccrz__E_CartItem__c item :cartItemList)
     {
     productIdList.add(item.ccrz__Product__c);
     }
     System.debug('Price'+productIdList);
       List<ccrz__E_PriceListItem__c> itemPriceList = [SELECT ccrz__Price__c FROM ccrz__E_PriceListItem__c WHERE  ccrz__Pricelist__r.Name='Enterprise' AND ccrz__Product__c IN: (productIdList)];
       for(ccrz__E_PriceListItem__c cartItem: itemPriceList ){
         if(cartItem.ccrz__Price__c < 500){
         isAllowCheckout=false; 
         return isAllowCheckout ;
        }
     }    
     return isAllowCheckout ;
}
}