global class RemoteClassShruthi {
    @RemoteAction
    global static ccrz.cc_RemoteActionResult createCase( ccrz.cc_RemoteActionContext ctx,final String cartId){
        ccrz.ccLog.log(System.LoggingLevel.INFO, cartId);
        ccrz.cc_CallContext.initRemoteContext(ctx); 
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        try{ 
            Case caseObj =new Case();
            String currCartIdVal = ccrz.cc_CallContext.currCartId;
            String cartSfId = [select id from ccrz__E_Cart__c where ccrz__EncryptedId__c = :currCartIdVal limit 1].id;
            Account currentAcc = ccrz.cc_CallContext.currAccount;
            Contact currentContact = ccrz.cc_CallContext.currContact;
            caseObj.Account = currentAcc;
            caseObj.Contact = currentContact;
            caseObj.Cart__c = cartSfId;
            caseObj.Subject = 'created for credit limit from cart';
            
            insert caseObj;
            res.success = true; 
            }catch(Exception e){
                res.data= e; System.debug(System.LoggingLevel.ERROR, e.getMessage()); 
                System.debug(System.LoggingLevel.ERROR, e.getStackTraceString()); 
                
            } 
            return res;

    }
}