@isTest
private class cc_api_CartExtensionStatus_TestShivani {
    private static ccrz__E_Cart__c testCart;
    private static ccrz__E_CartItem__c testCartItem;
    private static ccrz.cc_bean_CartSummary cartSummary;
    /**
     *
     * description
     *
     * @result the key result
     */
    private static void setupTestData() {
        //cc_lol_TestData.setupLOLSettings();
        testCart = cc_lol_TestData.createCart();
        
        // setup test cart
        ccrz__E_Cart__c cart = [SELECT
                                    ccrz__EncryptedId__c
                                FROM
                                    ccrz__E_Cart__c
                                WHERE
                                    Id = :testCart.Id LIMIT 1];

        cart.ccrz__EncryptedId__c = testCart.ccrz__EncryptedId__c;
        update cart;
        cc_lol_TestData.setupCatalog();
        ccrz__E_Product__c prod= [SELECT ccrz__ProductId__c FROM ccrz__E_Product__c WHERE Name = 'product001'];
        cartSummary = new ccrz.cc_bean_CartSummary(cart);
        
        List<ccrz__E_CartItem__c> cartItems = new List<ccrz__E_CartItem__c>();
        testCartItem = cc_lol_TestData.addCartItem(cart,prod.ccrz__ProductId__c , 1.0, 50.5);
        
        cartItems.add(testCartItem);
        //cartSummary.cartItems = cartItems;
    }
    
    /**
     *
     * description
     *
     * @result the key result
     */
    @isTest 
    static void test_allowCheckout() {
        setupTestData();
        System.debug('\n\nTestCart --> ' +testCart.ccrz__EncryptedId__c);
        
        cc_api_CartExtensionStatus_Shivani cartExtension = new cc_api_CartExtensionStatus_Shivani();
        
        Map<String, Object> inputData = new Map<String, Object>();
        inputData.put(ccrz.cc_api_CartExtension.PARAM_CARTBEAN, cartSummary);
        boolean result = cartExtension.allowCheckout(inputData);
        System.assertEquals(result,false);
    }
}