global class cc_hk_Order_Piyali extends ccrz.cc_hk_Order {

private String PARAM_PLACE_STEP = ccrz.cc_hk_Order.STEP_UPDATE_ORDER_STATUS_POST;

global override Map<String,Object> place(Map<String, Object> inputData) { 

    ccrz__E_Cart__c cartValue = ((ccrz__E_Cart__c)inputData.get(PARAM_CART));
    Account acct = ccrz.cc_CallContext.currAccount;

        Account acctData = [SELECT credit_limit__C FROM Account WHERE Id =: acct.Id LIMIT 1];
        ccrz.cclog.log(System.LoggingLevel.INFO,'M:X',cartValue.ccrz__SubtotalAmount__c);
        acctData.credit_limit__c = acctData.credit_limit__C - cartValue.ccrz__SubtotalAmount__c;
        ccrz.cclog.log(System.LoggingLevel.INFO,'M:X',acctData.credit_limit__c);

        update acctData ;
  
     
  return null;  

}


}