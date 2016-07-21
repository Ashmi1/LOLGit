global class cc_hk_Order_Azeem extends ccrz.cc_hk_Order{

    global override virtual Map<String,Object> place(Map<String,Object> inputData){
        Account acct = ccrz.cc_CallContext.currAccount;
        Account acctData = [SELECT credit_limit__c FROM Account WHERE Id =: acct.Id LIMIT 1];
        ccrz__E_Cart__c cart = (ccrz__E_Cart__c)inputData.get(PARAM_CART);
        
        Decimal sumTotal = cart.ccrz__SubtotalAmount__c;
        acctData.credit_limit__c = acctData.credit_limit__c - sumTotal;
        
        update acctData;
        
        return super.place(inputData);
        
    }

}