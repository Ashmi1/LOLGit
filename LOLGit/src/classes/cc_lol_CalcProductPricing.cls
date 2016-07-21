global class cc_lol_CalcProductPricing extends ccrz.cc_hk_Pricing {

private Map<String, Object> productPriceMap = new Map<String, Object>();
private List<String> productIdList = new List<String> ();

global override Map<String,Object> constructPricingProducts(Map<String,Object> inputData) {
productPriceMap = calcProductPrice((List<ccrz__E_CartItem__c>)inputData.get(ccrz.cc_hk_Pricing.PARAM_CART_ITEMS));
return productPriceMap;
}

private Map<String, Object> calcProductPrice(List<ccrz__E_CartItem__c> cartItemsList) {
   for(ccrz__E_CartItem__c cartItem : cartItemsList) {
       productIdList.add(cartItem.ccrz__Product__r.ccrz__ProductId__c);
   }
   
   List<ccrz__E_PriceListItem__c> priceList= 
               [SELECT ccrz__Price__c, ccrz__Product__r.ccrz__ProductId__c FROM ccrz__E_PriceListItem__c 
               WHERE ccrz__Product__r.ccrz__ProductId__c IN :productIdList];
                   
   for(ccrz__E_PriceListItem__c productPrice : priceList) {
           productPriceMap.put(String.valueOf(productPrice.ccrz__Product__r.ccrz__ProductId__c), productPrice.ccrz__Price__c);
   }
   
   ccrz.ccLog.log(System.LoggingLevel.INFO,'Price details',productPriceMap);
   
   return productPriceMap;

}


}