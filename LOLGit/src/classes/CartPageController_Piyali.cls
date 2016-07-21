global class CartPageController_Piyali {
    @RemoteAction
    global static ccrz.cc_RemoteActionResult createCreditCase(final ccrz.cc_RemoteActionContext ctx, final String cartId) {
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult(); res.success = false;
        try{ 
            Contact cc=ccrz.cc_CallContext.currContact;
            Account currentAcc = ccrz.cc_CallContext.currAccount;
 
            Case newCase = new Case();
            newCase.Account = currentAcc;
            newCase.contact = cc;
            newCase.Cart__c = [SELECT id FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =: cartId LIMIT 1].id;

            insert newCase;            
              
            }
            catch(Exception e){
            res.data = e;
            System.debug(System.LoggingLevel.ERROR, e.getMessage()); System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
            }
        return res;
        }

    
}