global class CC_CartExtension_Shruthi extends ccrz.cc_api_CartExtension {
  // private boolean isValidated = true; 
   private boolean isAllowCheckout = true; 
   private final List<ccrz.cc_bean_Message> retMessages = new List<ccrz.cc_bean_Message>();

    global override boolean allowCheckout(Map<String, Object> inputData){ 
         validate((ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN)); 
        return isAllowCheckout; 
        
    }
    
    
    global override List<ccrz.cc_bean_Message> getCartMessages(Map<String, Object> inputData){ 
        //validate((ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN)); 
        return retMessages;
        
    }
    
    private void validate(ccrz.cc_bean_CartSummary cartSummary){
        Decimal subTotalVal = cartSummary.subtotal;
        Account acct = ccrz.cc_CallContext.currAccount;
        Account acctData = [SELECT credit_limit__c FROM Account WHERE Id =: acct.Id LIMIT 1];
        if(acctData.credit_limit__c != null && acctData.credit_limit__c < subTotalVal){
            isAllowCheckout = false;
            //isValidated=false;
            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message('You do not have enough credit to purchase these items check.',ccrz.cc_bean_Message.MessageSeverity.ERROR);
            msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msg.classToAppend = 'messagingSection-Error';
            retMessages.add(msg);
            
        }
    }
}