global class cc_api_CartExtension_Azeem extends ccrz.cc_api_CartExtension {

private boolean isValidated;
private boolean isAllowCheckOut;
private final List<ccrz.cc_bean_Message> restMessagees = new List<ccrz.cc_bean_Message>();
//deploying

global override boolean allowCheckout(Map<String,Object> inputData) {
ccrz.cc_bean_CartSummary cartData = (ccrz.cc_bean_CartSummary) inputData.get(PARAM_CARTBEAN);
validate(cartData);
return isAllowCheckOut ;
}


global override List<ccrz.cc_bean_Message> getCartMessages(Map<String,Object> inputData) {
return restMessagees;
}

private void validate(ccrz.cc_bean_CartSummary cartData){
    Account acct = ccrz.cc_CallContext.currAccount;
    Account acctData = [SELECT credit_limit__c FROM Account WHERE Id =: acct.Id LIMIT 1];
    isAllowCheckOut = true;
    Decimal sumTotal = cartData.subTotal;
    if (acctData.credit_limit__c != null && acctData.credit_limit__c  < sumTotal){
        isAllowCheckOut = false;
            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message('You do not have enough credit to purchase these items.',ccrz.cc_bean_Message.MessageSeverity.ERROR);
            msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msg.classToAppend = 'messagingSection-Error';
            restMessagees.add(msg);
    }else{
        ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message('You do have enough credit to purchase these items.',ccrz.cc_bean_Message.MessageSeverity.ERROR);
            msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msg.classToAppend = 'messagingSection-Error';
            restMessagees.add(msg);
    }
    
}
}