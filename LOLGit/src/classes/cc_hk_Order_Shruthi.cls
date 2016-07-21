global class cc_hk_Order_Shruthi extends ccrz.cc_hk_Order {
    
    private String PARAM_PLACE_STEP=ccrz.cc_hk_Order.STEP_UPDATE_ORDER_STATUS_POST;
    global override Map<String,Object> place(Map<String,Object> inputData){
        Account acct = ccrz.cc_CallContext.currAccount;
        Account acctData = [SELECT credit_limit__c FROM Account WHERE Id =: acct.Id LIMIT 1];
       ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','myMethod');
       ccrz__E_Cart__c cart = (ccrz__E_Cart__c)inputData.get(ccrz.cc_hk_Order.PARAM_CART);
       Decimal subTotalVal = cart.ccrz__SubtotalAmount__c;
       acctData.credit_limit__c = acctData.credit_limit__c-200;
       
       update acctData;
       return super.place(inputData);
    }

}