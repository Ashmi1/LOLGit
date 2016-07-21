global class invoice_Piyali extends ccrz.cc_hk_Invoice {

private String PARAM_INVOICE = ccrz.cc_hk_Invoice.PARAM_INVOICE_PAYMENTS;

    global Override Map<String, Object> applyPayment(Map<String,Object> inputData) {
    Map<String, Object> retData = super.applyPayment(inputData);
    

     Account acct = ccrz.cc_CallContext.currAccount;

        Account acctData = [SELECT credit_limit__C FROM Account WHERE Id =: acct.Id LIMIT 1];
        
        acctData.credit_limit__C = acctData.credit_limit__C;
        //add the amount of the invoice to the account 
        return retData;
    }
}