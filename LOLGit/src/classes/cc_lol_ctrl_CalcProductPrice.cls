global with sharing class cc_lol_ctrl_CalcProductPrice extends ccrz.cc_api_PriceAdjustment {

private Map<String, Object> productPriceMap = new Map<String, Object>();
private List<String> productIdList = new List<String> ();

/*  
    @author pimukherjee
    The service computes the product price in the cart summary.
    It retrieves the best price for the product from the pricelist.
*/
global override Map<String, Object> computePricingCart(Map<String, Object> inputData){
        
        System.debug('computePricingCart -->');
        
        ccrz.cc_bean_CartSummary cartBean;
        cartBean = (ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN);
      
              //Query cart items
              ccrz__E_Cart__c cart = [Select c.ccrz__Storefront__c, c.ccrz__User__c, c.ccrz__Contact__c, c.ccrz__Account__c, c.OwnerId, c.Name, c.Id, 
              c.ccrz__TotalQuantity__c, c.ccrz__TotalDiscount__c, c.ccrz__TotalAmount__c, c.ccrz__TaxAmount__c, c.ccrz__SubtotalAmount__c, 
              (Select Id,ccrz__AbsoluteDiscount__c,ccrz__PercentDiscount__c, ccrz__ItemTotal__c, ccrz__Price__c, ccrz__Product__r.ccrz__ShortDesc__c, 
              ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.ccrz__Quantityperunit__c, ccrz__Product__r.ccrz__ProductType__c, ccrz__Product__r.ccrz__ProductId__c, 
              ccrz__Product__r.ccrz__LongDesc__c, ccrz__Product__r.Name, ccrz__Quantity__c, ccrz__SubAmount__c From ccrz__E_CartItems__r) 
                                  From ccrz__E_Cart__c c
                                  Where c.ccrz__EncryptedId__c =: cartBean.encryptedId][0];
              
              System.debug('\n\n\n Cart in cartpricing ---------->'+cart);
                            
              Map<String,Decimal> cartPriceMap = new Map<String,Decimal>();
                  
                  System.debug('\n\n cartPriceMap -->'+cart.ccrz__E_CartItems__r);
                  
                  List<ccrz__E_CartItem__c> itemList = cart.ccrz__E_CartItems__r;
                  
                  for(ccrz__E_CartItem__c cartItem : itemList){                    
                        cartPriceMap.put((String)cartItem.ccrz__Product__r.ccrz__ProductId__c,cartItem.ccrz__Price__c);
                        System.debug('\n\n Actual ID Value-->'+cartItem+'--cartItem.ID -->'+cartItem.ccrz__Product__r.ccrz__ProductId__c);
                    }
                                      
                    System.debug('\n\n cartPriceMap-->'+cartPriceMap);
                                        
                    for(ccrz.cc_bean_CartItem cartItem : cartBean.cartItems){
                        System.debug('\n\n cartItem-->'+cartItem+'--cartItem.mockProduct.sku -->'+cartItem.ItemId);
                                              
                      if(cartPriceMap!= null && !cartPriceMap.isEmpty() && cartPriceMap.containsKey(cartItem.ItemId)){
                          if(cartPriceMap.get(cartItem.ItemId) != null){
                                cartItem.price = (Decimal)cartPriceMap.get(cartItem.ItemId);
                                cartItem.subAmount = cartItem.price * cartItem.quantity;
                          }
                      }
                    }

                    inputData.put(ccrz.cc_api_CartExtension.PARAM_CARTBEAN,cartBean);
                    ccrz.ccLog.log(System.LoggingLevel.INFO,'Price details',inputData);
                    System.debug('\n\n Return Result-->'+inputData);
        return inputData;
    }

}