global class cc_api_CartExtension_Shivani extends ccrz.cc_api_CartExtension {

private boolean isValidated = false;
private boolean isAllowCheckout = false;
private final List<ccrz.cc_bean_Message> retMessages = new List<ccrz.cc_bean_Message>();
private final List<ccrz.cc_bean_Message> retMessagesCredit = new List<ccrz.cc_bean_Message>();

global override boolean allowCheckout(Map<String,Object> inputData) {
validate((ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN));
return isAllowCheckout ;
}

private void validate(ccrz.cc_bean_CartSummary inputData) {
     Account acct = ccrz.cc_CallContext.currAccount;

        Account acctData = [SELECT credit_limit__C FROM Account WHERE Id =: acct.Id LIMIT 1];

        isAllowCheckout = true;

        Decimal sumTotal = 0;

        if (acctData.credit_limit__c != null && acctData.credit_limit__c < inputData.subtotal){

            isAllowCheckout = false;

            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message('You do not have enough credit to purchase these items.',ccrz.cc_bean_Message.MessageSeverity.ERROR);

            msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;

            msg.classToAppend = 'messagingSection-Error';

            retMessages.add(msg);

        } 
        
       isValidated = isAllowCheckout;    
    
}

global override List<ccrz.cc_bean_Message> getCartMessages(Map<String,Object> inputData) {
if(!isValidated) {
    return retMessages;
}
     ccrz.cc_bean_Message message= new ccrz.cc_bean_Message('You do have enough credit to purchase these items.',ccrz.cc_bean_Message.MessageSeverity.ERROR);

            message.type = ccrz.cc_bean_Message.MessageType.CUSTOM;

            message.classToAppend = 'messagingSection-Error';

    retMessagesCredit .add(message);
    return retMessagesCredit;
}
}