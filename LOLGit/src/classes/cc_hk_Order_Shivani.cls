global class cc_hk_Order_Shivani extends ccrz.cc_hk_Order {

private final Map<String, Object> inputData = new Map<String, Object> ();
private String PARAM_PLACE_STEP = ccrz.cc_hk_Order.STEP_CREATE_ORDER_ITEMS_POST;

global override Map<String,Object> place(Map<String, Object> inputData) {
ccrz__E_Cart__c cart= (ccrz__E_Cart__c )inputData.get(PARAM_CART);
Account acct = ccrz.cc_CallContext.currAccount;
Account acctData = [SELECT credit_limit__C FROM Account WHERE Id =: acct.Id LIMIT 1];
acctData.credit_limit__c=acctData.credit_limit__c- cart.ccrz__SubtotalAmount__c;

UPDATE acctData;
return inputData;  
  

}




}