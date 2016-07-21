global class cartPageControllerShivani{
@RemoteAction
global static ccrz.cc_RemoteActionResult createCreditCase(final ccrz.cc_RemoteActionContext ctx, final String cartId){
ccrz.cc_CallContext.initRemoteContext(ctx);
ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
res.success = false;
try{ //Create the case here
String newCartId;
Case caseObj =new Case();
            Account currentAcc = ccrz.cc_CallContext.currAccount;
            Contact currentContact = ccrz.cc_CallContext.currContact;
            caseObj.Account = currentAcc;
            caseObj.Contact = currentContact;
            newCartId= [SELECT ID FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c=:cartId LIMIT 1].ID;
            
            caseObj.Cart__c= newCartId;
            
            insert caseObj;
res.success = true;
}catch(Exception e){
res.data = e;
System.debug(System.LoggingLevel.ERROR, e.getMessage());
System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
}
return res;
}
}