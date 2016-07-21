public with sharing class cc_lol_TestData {
    // General Constants
    public static final String STOREFRONT_NAME                            = 'CHStore';
    public static final String ACCOUNT_NAME                               = 'TestAccount';
    public static final String ACCOUNTGROUP_NAME                          = 'TestAccountGroup';
    public static final String ANON_ACCOUNT_NAME                               = 'CCAnonymous';
    public static final String ANON_ACCOUNTGROUP_NAME                          = 'Anonymous';
    public static final String CLOUDCRAZE_CUSTOMER_COMMUNITY_PROFILE_NAME = 'CloudCraze Customer Community User';
    public static final String USER_LANGUAGE                              = 'en_US';
    public static final Decimal DEFAULT_PRICE                             = 100.00;

    // Category Name Constants
    public static final String STOREFRONT_CATEGORY_ROOT        = 'BP Root';
    public static final String STOREFRONT_CATEGORY_ROOT_IR     = 'IR Root';
    public static final String STOREFRONT_CATEGORY_ROOT_EXT_ID = 'LOLRootExtId';
    public static final String PRODUCT_TYPE_CATEGORY_1         = 'ProductType1';
    public static final String PRODUCT_TYPE_CATEGORY_2         = 'ProductType2';
    public static final String BRAND_CATEGORY_1                = 'Brand1';
    public static final String BRAND_CATEGORY_2                = 'Brand2';
    public static final String BRAND_CATEGORY_3                = 'Brand3';
    public static final String BRAND_CATEGORY_4                = 'Brand4';
    public static final String SUB_BRAND_CATEGORY_1            = 'SubBrand1';
    public static final String SUB_BRAND_CATEGORY_2            = 'SubBrand2';
    public static final String SUB_BRAND_CATEGORY_3            = 'SubBrand3';
    public static final String SUB_BRAND_CATEGORY_4            = 'SubBrand4';

    private static Boolean catalogSetupIsComplete = false;


    public static ccrz__E_AccountGroup__c testAccountGroup {
        get {
            if (testAccountGroup == null) {
                testAccountGroup = new ccrz__E_AccountGroup__c( Name = ACCOUNTGROUP_NAME );
                insert testAccountGroup;
            }
            return testAccountGroup;
        }
        private set;
    }

    public static ccrz__E_AccountGroup__c anonAccountGroup {
        get {
            if (anonAccountGroup == null) {
                anonAccountGroup = new ccrz__E_AccountGroup__c( Name = ANON_ACCOUNTGROUP_NAME );
                insert anonAccountGroup;
            }
            return anonAccountGroup;
        }
        private set;
    }
    
    public static Account testAccount {
        get {
            if (testAccount == null) {
                testAccount = new Account(
                        Name                    = ACCOUNT_NAME,
                        ccrz__E_AccountGroup__c = testAccountGroup.Id,
                        OwnerId                 = UserInfo.getUserId(),
                        Type                    = 'Customer',
                        BillingStreet           = generateRandomString(32),
                        BillingCity             = generateRandomString(32)
                );
                insert testAccount;
            }
            return testAccount;
        }
        private set;
    }

    public static Account anonAccount {
        get {
            if (anonAccount == null) {
                anonAccount = new Account(
                        Name                    = ANON_ACCOUNT_NAME,
                        ccrz__E_AccountGroup__c = anonAccountGroup.Id,
                        OwnerId                 = UserInfo.getUserId(),
                        Type                    = 'Customer',
                        BillingStreet           = generateRandomString(32),
                        BillingCity             = generateRandomString(32)
                );
                insert anonAccount;
            }
            return anonAccount;
        }
        private set;
    }

    public static User testUser {
        get {
            if (testUser == null) {
                setupTestUser();
            }
            return testUser;
        }
        private set;
    }


    public static ccrz__E_ContactAddr__c billToAddress {
        get {
            if (billToAddress == null) {
                billToAddress = getContactAddress();
                insert billToAddress;
            }
            return billToAddress;
        }
        private set;
    }


    public static ccrz__E_ContactAddr__c shipToAddress {
        get {
            if (shipToAddress == null) {
                shipToAddress = getContactAddress();
                insert shipToAddress;
            }
            return shipToAddress;
        }
        private set;
    }

    public static List<ccrz__E_Product__c> products {
        get {
            if (products == null || products.isEmpty()) {
                setupCatalog();
            }
            return products;
        }
        private set;
    }

    public static Map<String,ccrz__E_Category__c> categoryMap {
        get {
            if (categoryMap == null) {
                categoryMap = new Map<String,ccrz__E_Category__c>();
                setupCatalog();
            }
            return categoryMap;
        }
        private set;
    }

    public static List<ccrz__E_ProductCategory__c> productCategories {
        get {
            if (productCategories == null) {
                setupCatalog();
            }
            return productCategories;
        }
        private set;
    }


    /*------------------------------------------------------------
    Description:   Create a Test User, Contact, Account,
                   and Account Group
    ------------------------------------------------------------*/
    public static void setupTestUser() {

        Contact contactCC = new Contact(
                FirstName = 'CloudCraze',
                LastName  = 'TestUser',
                AccountId = testAccount.Id,
                MailingStreet = 'abc'
        );
        insert contactCC;

        Profile profile = [SELECT Id
        FROM Profile
        WHERE Name = :CLOUDCRAZE_CUSTOMER_COMMUNITY_PROFILE_NAME LIMIT 1];

        User testOwner = [SELECT TimeZoneSidKey, UserRoleId
        FROM User
        WHERE Id = :UserInfo.getUserId()];

        String emailAddress = String.valueOf(System.now().getTime() + '@cc-test.mail');
        testUser = new User(
                Alias                    = 'cctest',
                Email                    = emailAddress,
                EmailEncodingKey         = 'UTF-8',
                LastName                 = 'TestUser',
                LanguageLocaleKey        = 'en_US',
                LocaleSidKey             = 'en_US',
                ProfileId                = profile.Id,
                TimeZoneSidKey           = testOwner.TimeZoneSidKey,
                Username                 = emailAddress,
                isActive                 = true,
                ContactId                = contactCC.Id,
                Contact                  = contactCC,
                //UserRoleId               = testOwner.UserRoleId,
                ccrz__CC_CurrencyCode__c = 'USD'
        );
        insert testUser;

        update testUser.Contact;
    }


    /*------------------------------------------------------------
    Description:   Create CC Cart
    ------------------------------------------------------------*/
    public static ccrz__E_Cart__c createCart() {
        Account anonAcc = anonAccount;
        ccrz__E_AccountGroup__c anonAccGrp = anonAccountGroup;
        return createCarts(1).get(0);
    }

    /*------------------------------------------------------------
    Description:   Create CC Carts
    ------------------------------------------------------------*/
    public static List<ccrz__E_Cart__c> createCarts(Integer numberOfCarts) {

        final List<ccrz__E_Cart__c> testCarts = new List<ccrz__E_Cart__c>();
        System.assert(testUser != null);
        for (Integer i = 0; i < numberOfCarts; i++) {
            testCarts.add(
                    new ccrz__E_Cart__c(
                            ccrz__Account__c         = testAccount.Id,
                            ccrz__CartType__c        = 'Cart',
                            ccrz__CartStatus__c      = 'Open',
                            ccrz__User__c            = testUser.Id,
                            ccrz__Contact__c         = testUser.ContactId,
                            ccrz__Name__c            = 'cart',
                            OwnerId                  = testUser.Id,
                            ccrz__AnonymousID__c     = false,
                            ccrz__ActiveCart__c      = true,
                            ccrz__SessionId__c       = 'testing',
                            ccrz__CurrencyISOCode__c = 'USD',
                            ccrz__Storefront__c      = STOREFRONT_NAME,
                            ccrz__EncryptedId__c     = 'encid' + String.valueOf(Crypto.getRandomInteger()),//i
                            ccrz__BillTo__c          = billToAddress.Id,
                            ccrz__ShipTo__c          = shipToAddress.Id
                    ));
        }
        System.assertEquals(testCarts.size(), numberOfCarts);
        upsert testCarts;

        final List<ccrz__E_PaymentDetail__c> testPaymentDetails = new List<ccrz__E_PaymentDetail__c>();
        final List<String> cartIds                              = new List<String>();

        for (Integer i = 0; i < numberOfCarts; i++) {
            testPaymentDetails.add(
                    new ccrz__E_PaymentDetail__c(
                            ccrz__Cart__c           = testCarts.get(i).Id,
                            ccrz__Payment_Method__c = 'PO Number',
                            ccrz__Account_Number__c = 'PO' + String.valueOf(i)
                    ));
            cartIds.add(testCarts.get(i).Id);
        }
        insert testPaymentDetails;

        return [SELECT Id, ccrz__User__c, ccrz__EncryptedId__c
        FROM ccrz__E_Cart__c
        WHERE Id IN :cartIds];
    }


    /*------------------------------------------------------------
    Description:   Add Items to Test CC Cart
    ------------------------------------------------------------*/
    public static ccrz__E_CartItem__c addCartItem(ccrz__E_Cart__c testCart, Id prodId, Decimal qty, Decimal price) {
        return addCartItems(testCart,
                new Map<Id,Decimal> { prodId => qty },
                new Map<Id,Decimal> { prodId => price }).get(0);
    }
    public static List<ccrz__E_CartItem__c> addCartItems(ccrz__E_Cart__c testCart,
            Map<Id,Decimal> productQuantityMap,
            Map<Id,Decimal> productPriceMap
    ) {
        final List<ccrz__E_CartItem__c> items = new List<ccrz__E_CartItem__c>();
        final Map<Id,Decimal> itemPrices      = (null == productPriceMap) ? new Map<Id,Decimal>() : productPriceMap;

        for (Id productId : productQuantityMap.keySet()) {
            final Decimal itemPrice = itemPrices.containsKey(productId) ? itemPrices.get(productId) : DEFAULT_PRICE;
            items.add(
                    new ccrz__E_CartItem__c(
                            ccrz__Cart__c         = testCart.Id,
                            ccrz__Quantity__c     = productQuantityMap.get(productId),
                            ccrz__Product__c      = productId,
                            ccrz__Price__c        = itemPrice,
                            ccrz__SubAmount__c    = productQuantityMap.get(productId)*itemPrice,
                            ccrz__cartItemType__c = 'Major'
                    ));
        }
        insert items;
        return items;
    }


    /*------------------------------------------------------------
    Description:   Setup CloudCraze Catalog
    ------------------------------------------------------------*/
    public static void setupCatalog() {
        if (catalogSetupIsComplete) {
            return;
        }
        catalogSetupIsComplete = true;

        //******************************************************************************
        // INSERT STOREFRONT SETTINGS
        //******************************************************************************
        ccrz.cc_util_Reflection.createStorefrontSetting(STOREFRONT_NAME);
        ccrz.cc_util_Reflection.updateStorefrontSettings(STOREFRONT_NAME, 'ccrz__DefaultLanguage__c', USER_LANGUAGE);

        System.debug('@@Created storefront setting: ' + STOREFRONT_NAME);

        //ccrz.cc_util_Reflection.addFactoryEntry(string factoryName, string factoryClass, string apiName, string daoName, string serviceName);

        //******************************************************************************
        // INSERT PRICE LISTS
        //******************************************************************************
        final List<ccrz__E_PriceList__c> priceLists = new List<ccrz__E_PriceList__c> {
                new ccrz__E_PriceList__c(
                        Name                     = 'PL001',
                        ccrz__CurrencyISOCode__c = 'USD',
                        ccrz__Enabled__c         = true,
                        ccrz__Storefront__c      = STOREFRONT_NAME,
                        ccrz__StartDate__c       = Date.today().addDays(-7),
                        ccrz__EndDate__c         = Date.today().addDays(7)
                )
        };
        insert priceLists;

        final List<ccrz__E_AccountGroupPriceList__c> testAccountGroupPriceLists = new List<ccrz__E_AccountGroupPriceList__c>();

        for (ccrz__E_PriceList__c priceList : priceLists) {
            testAccountGroupPriceLists.add(
                    new ccrz__E_AccountGroupPriceList__c(
                            ccrz__AccountGroup__c = testAccountGroup.Id,
                            ccrz__PriceList__c    = priceList.Id,
                            ccrz__Enable__c       = true
                    ));
            testAccountGroupPriceLists.add(
                    new ccrz__E_AccountGroupPriceList__c(
                            ccrz__AccountGroup__c = anonAccountGroup.Id,
                            ccrz__PriceList__c    = priceList.Id,
                            ccrz__Enable__c       = true
                    ));
        }
        insert testAccountGroupPriceLists;

        //******************************************************************************
        // INSERT PRODUCTS
        //******************************************************************************
        products = new List<ccrz__E_Product__c>{
                new ccrz__E_Product__c(
                        Name                       = 'product001',
                        ccrz__SKU__c               = 'test001',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = '001',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product002',
                        ccrz__SKU__c               = 'test002',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = '002',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product003',
                        ccrz__SKU__c               = 'test003',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = '003',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product004',
                        ccrz__SKU__c               = 'test004',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = '004',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product005',
                        ccrz__SKU__c               = 'test005',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = '005',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product007',
                        ccrz__SKU__c               = 'test007',
                        ccrz__ProductStatus__c     = 'Blocked',
                        ccrz__UnitOfMeasure__c     = '007',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME
                ),
                new ccrz__E_Product__c(
                        Name                       = 'FILTER IN-LINE',
                        ccrz__SKU__c               = '023 20878 001',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = '006',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME                      
                )
        };
        insert products;

        
        /* CC_Storefront_ERP__c erpStorefrontSettings = new CC_Storefront_ERP__c(
            Storefront_Name__c = cc_lol_TestData.STOREFRONT_NAME
            , Name             = 'name'
            , ERP_Name__c      = 'erpname'
            , ERP_Id__c        = 'erpid'
        );
        insert erpStorefrontSettings;

        Id storefronterpId = erpStorefrontSettings.Id;
        Id productId = products.get(6).Id;
        CC_ERP_Number__c erpNumber = new CC_ERP_Number__c(
            ERP_Number__c = '023 20878 001',
            Storefront_ERP__c = storefronterpId,
            CC_Product__c = productId
        );
        insert erpNumber; */

        final List<ccrz__E_ProductMedia__c> productMedia    = new List<ccrz__E_ProductMedia__c>();
        final List<ccrz__E_ProductItemI18N__c> producti18ns = new List<ccrz__E_ProductItemI18N__c>();
        final List<ccrz__E_PriceListItem__c> priceListItems = new List<ccrz__E_PriceListItem__c>();

        for (ccrz__E_Product__c product : products) {
            productMedia.add(
                    new ccrz__E_ProductMedia__c(
                            ccrz__Product__c            = product.Id,
                            ccrz__FilePath__c           = generateRandomString(10),
                            ccrz__ProductMediaSource__c = 'static',
                            ccrz__StaticResourceName__c = generateRandomString(10)
                    ));

            producti18ns.add(
                    new ccrz__E_ProductItemI18N__c(
                            Name             = product.Name + '-de',
                            ccrz__Locale__c  = 'de',
                            ccrz__Product__c = product.Id
                    ));

            priceListItems.add(
                    new ccrz__E_PriceListItem__c(
                            ccrz__Pricelist__c = priceLists.get(0).Id,
                            ccrz__Product__c   = product.Id,
                            ccrz__StartDate__c = Date.today().addDays(-7),
                            ccrz__EndDate__c   = Date.today().addDays(7),
                            ccrz__Price__c     = DEFAULT_PRICE
                    ));
        }
        insert productMedia;
        insert producti18ns;
        insert priceListItems;

        //******************************************************************************
        // INSERT CATEGORIES
        //******************************************************************************

        // all root
        ccrz__E_Category__c testAllRoot = new ccrz__E_Category__c(
                Name                = 'Products',
                ccrz__CategoryID__c = '0',
                ccrz__StartDate__c  = Date.today().addDays(-1),
                ccrz__EndDate__c    = Date.today().addDays(1)
        );
        insert testAllRoot;
        categoryMap.put('testAllRoot', testAllRoot);

        // storefront root for BP
        ccrz__E_Category__c storefrontRoot = new ccrz__E_Category__c(
                Name                    = STOREFRONT_CATEGORY_ROOT,
                ccrz__CategoryID__c     = STOREFRONT_CATEGORY_ROOT_EXT_ID,
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = testAllRoot.Id
        );
        insert storefrontRoot;

        categoryMap.put(STOREFRONT_CATEGORY_ROOT, storefrontRoot);

        // product types
        List<ccrz__E_Category__c> productTypes = new List<ccrz__E_Category__c>();

        ccrz__E_Category__c productType1 = new ccrz__E_Category__c(
                Name                    = PRODUCT_TYPE_CATEGORY_1,
                ccrz__CategoryID__c     = PRODUCT_TYPE_CATEGORY_1 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = storefrontRoot.Id
        );
        ccrz__E_Category__c productType2 = new ccrz__E_Category__c(
                Name                    = PRODUCT_TYPE_CATEGORY_2,
                ccrz__CategoryID__c     = PRODUCT_TYPE_CATEGORY_2 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = storefrontRoot.Id
        );
        productTypes.add(productType1);
        productTypes.add(productType2);
        insert productTypes;
        categoryMap.put(PRODUCT_TYPE_CATEGORY_1, productType1);
        categoryMap.put(PRODUCT_TYPE_CATEGORY_2, productType2);

        // brands
        List<ccrz__E_Category__c> brands = new List<ccrz__E_Category__c>();

        ccrz__E_Category__c brand1 = new ccrz__E_Category__c(
                Name                    = BRAND_CATEGORY_1,
                ccrz__CategoryID__c     = BRAND_CATEGORY_1 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = productType1.Id,
                ccrz__Sequence__c       = 1
        );
        ccrz__E_Category__c brand2 = new ccrz__E_Category__c(
                Name                    = BRAND_CATEGORY_2,
                ccrz__CategoryID__c     = BRAND_CATEGORY_2 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = productType1.Id,
                ccrz__Sequence__c       = 1
        );
        ccrz__E_Category__c brand3 = new ccrz__E_Category__c(
                Name                    = BRAND_CATEGORY_3,
                ccrz__CategoryID__c     = BRAND_CATEGORY_3 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = productType2.Id,
                ccrz__Sequence__c       = 1
        );
        ccrz__E_Category__c brand4 = new ccrz__E_Category__c(
                Name                    = BRAND_CATEGORY_4,
                ccrz__CategoryID__c     = BRAND_CATEGORY_4 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = productType2.Id,
                ccrz__Sequence__c       = 1
        );
        brands.add(brand1);
        brands.add(brand2);
        brands.add(brand3);
        brands.add(brand4);
        insert brands;
        categoryMap.put(BRAND_CATEGORY_1, brand1);
        categoryMap.put(BRAND_CATEGORY_2, brand2);
        categoryMap.put(BRAND_CATEGORY_3, brand3);
        categoryMap.put(BRAND_CATEGORY_3, brand4);

        // sub-brands
        List<ccrz__E_Category__c> subBrands = new List<ccrz__E_Category__c>();

        ccrz__E_Category__c subbrand1 = new ccrz__E_Category__c(
                Name                    = SUB_BRAND_CATEGORY_1,
                ccrz__CategoryID__c     = SUB_BRAND_CATEGORY_1 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = brand1.Id,
                ccrz__Sequence__c       = 2
        );
        ccrz__E_Category__c subbrand2 = new ccrz__E_Category__c(
                Name                    = SUB_BRAND_CATEGORY_2,
                ccrz__CategoryID__c     = SUB_BRAND_CATEGORY_2 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = brand2.Id,
                ccrz__Sequence__c       = 2
        );
        ccrz__E_Category__c subbrand3 = new ccrz__E_Category__c(
                Name                    = SUB_BRAND_CATEGORY_3,
                ccrz__CategoryID__c     = SUB_BRAND_CATEGORY_3 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = brand1.Id,
                ccrz__Sequence__c       = 2
        );
        ccrz__E_Category__c subbrand4 = new ccrz__E_Category__c(
                Name                    = SUB_BRAND_CATEGORY_4,
                ccrz__CategoryID__c     = SUB_BRAND_CATEGORY_4 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = brand2.Id,
                ccrz__Sequence__c       = 2
        );
        subBrands.add(subBrand1);
        subBrands.add(subBrand2);
        subBrands.add(subBrand3);
        subBrands.add(subBrand4);
        insert subBrands;
        categoryMap.put(SUB_BRAND_CATEGORY_1, subbrand1);
        categoryMap.put(SUB_BRAND_CATEGORY_2, subbrand2);
        categoryMap.put(SUB_BRAND_CATEGORY_3, subbrand3);
        categoryMap.put(SUB_BRAND_CATEGORY_4, subbrand4);

        //******************************************************************************
        // INSERT PRODUCT CATEGORIES
        // TODO: needs to be updated with category structure for all products
        //******************************************************************************
        productCategories = new List<ccrz__E_ProductCategory__c>();
        ccrz__E_ProductCategory__c product001subbrand1 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(0).Id,
                ccrz__Category__c = subbrand1.Id
        );
        ccrz__E_ProductCategory__c product002subbrand2 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(1).Id,
                ccrz__Category__c = subbrand2.Id
        );

        ccrz__E_ProductCategory__c product003subbrand3 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(2).Id,
                ccrz__Category__c = subbrand3.Id
        );
        ccrz__E_ProductCategory__c product004subbrand4 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(3).Id,
                ccrz__Category__c = subbrand4.Id
        );
        ccrz__E_ProductCategory__c product005subbrand4 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(4).Id,
                ccrz__Category__c = subbrand4.Id
        );

        productCategories.add(product001subbrand1);
        productCategories.add(product002subbrand2);
        productCategories.add(product003subbrand3);
        productCategories.add(product004subbrand4);
        productCategories.add(product005subbrand4);
        insert productCategories;

        System.debug(Limits.getQueries() + ' of ' + Limits.getLimitQueries() + ' SOQL queries issued.');
    }


    /*------------------------------------------------------------
    Description:   Get test Contact Address
    ------------------------------------------------------------*/
    public static ccrz__E_ContactAddr__c getContactAddress() {
        return new ccrz__E_ContactAddr__c(
                ccrz__AddressFirstline__c = '100 Pine Street',
                ccrz__City__c             = 'SmallTown',
                ccrz__DaytimePhone__c     = '(847) 555-1212',
                ccrz__FirstName__c        = 'Test',
                ccrz__HomePhone__c        = '(847) 555-1212',
                ccrz__LastName__c         = 'User',
                ccrz__PostalCode__c       = '60601',
                ccrz__State__c            = 'Idaho',
                ccrz__StateISOCode__c     = 'ID',
                ccrz__CountryISOCode__c   = 'USA'
        );
    }

    /*------------------------------------------------------------
    Description:   Generate random string
    ------------------------------------------------------------*/
    public static String generateRandomString(Integer len) {
        final String RANDOM_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        String returnValue = '';
        Integer random;
        do {
            random = Math.mod(Math.abs(Crypto.getRandomInteger()),RANDOM_CHARS.length());
            returnValue += RANDOM_CHARS.substring(random,random + 1);
        } while (returnValue.length() < len);

        return returnValue;
    }

    /*------------------------------------------------------------
    Description:   Setup LOL Specific Settings
    ------------------------------------------------------------*/
    /* public static void setupLOLSettings() {
        // setup LOL Integration Settings
        List<cc_LOL_Integration_Settings__c> lolIntegrationSettings = new List<cc_LOL_Integration_Settings__c> {
            new cc_LOL_Integration_Settings__c(
                Name     = 'CC_Portal_SSO_Login'
                , URL__c = 'http://www.lol.com'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'CC_Portal_SSO_Logout'
                , URL__c = 'http://www.lol.com'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'LOL_Freight_Service'
                , URL__c = 'http://www.lol.com'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'LOL_Address_Validation'
                , URL__c = 'https://apiqa.lol.com:10450/lolbe/v1/taxware_na/addressvalidation'
                , field_information__c = '?apikey=cSFGv2ifSmFlmMXlAOfX1ARt5Gs7BJsR'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'Paymetrics'
                , URL__c = 'https://qaapp02.XiSecurenet.com/DIeComm/'
                , field_information__c = 'https://ccrz.cs44.visual.force.com/apex'
                , Password__c = 'i!8YP5d+-S7wE2j_6{NtZg%3s9W$Qc}4'
                , Client__c ='c9bdabf4-d010-4032-9e2a-f6ef76787bae'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'LOL_Tax_Service'
                , URL__c = 'https://order-navigator-unit.herokuapp.com/api/v1/taxCharges'
                , Password__c = 'orderNavigator'
                , Client__c ='c9bdabf4-d010-4032-9e2a-f6ef76787bae'
                , username__c = 'ebal'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'JPM'
                , URL__c = 'https://apidev.lol.com:10450/lolcorp/v1/paymentmanager/transaction'
                , Password__c = 'w9g4FVhiGp9p8QKGmOe2zAkh6jPSG2E4'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'IRStore_ERP_Contact'
                , field_information__c = 'We were unable to process this order. Please contact customer service 1-800-336-7264.'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'CHStore_ERP_Contact'
                , field_information__c = 'We were unable to process this order. Please contact customer service 1-800-336-7264.'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'LOL_Place_Order'
                , URL__c = 'https://apidev.lol.com:10450/lolbe/v1/erp/orders'
                , field_information__c = '?apikey=w9g4FVhiGp9p8QKGmOe2zAkh6jPSG2E4'
            ),
            new cc_LOL_Integration_Settings__c(
                Name = 'CHStore_ERP_PDP_Contact'
                , field_information__c = 'Contact customer service for availability 1-800-932-1701.'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'IRStore_ERP_PDP_Contact'
                , field_information__c = 'Contact customer service for availability 1-800-336-7264.'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'LOL_Dev_ATP_Price'
                , URL__c = 'https://apidev.lol.com:10450/lolbe/v1/erp/atpprice'
                , field_information__c = '?apikey=w9g4FVhiGp9p8QKGmOe2zAkh6jPSG2E4'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'LOL_ERP_Customer_API'
                ,URL__c = 'https://apidev.lol.com:10450/lolbe/v1/erp/customers?apikey=w9g4FVhiGp9p8QKGmOe2zAkh6jPSG2E4'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'LOL_ORDER_ERP_ERROR'
                ,custom_order_status__c = 'Error : Contact Customer Service'
            ),
            new cc_LOL_Integration_Settings__c(
                Name     = 'CHStore_Cart_InvalidProduct'
                ,field_information__c = 'Invalid items must be removed from the cart prior to checkout.'
            )
        };
        insert lolIntegrationSettings;

        // setup LOL Options settings
        List<cc_LOL_Options__c> lolOptions = new List<cc_LOL_Options__c> {
            new cc_LOL_Options__c(
                Name       = 'QuoteValidDays'
                , Value__c = '30'
            ),
            new cc_LOL_Options__c(
                Name       = 'LOL_Order_Offset_Number'
                , Value__c = '0'
            ),
            new cc_LOL_Options__c(
                Name       = 'LOL_Product_Base_Price'
                , Value__c = '9999999.00'
            )
        };
        insert lolOptions;

        CC_Storefront_ERP__c erpStorefrontSettings = new CC_Storefront_ERP__c(
            Storefront_Name__c = cc_lol_TestData.STOREFRONT_NAME
            , Name             = 'name'
            , ERP_Name__c      = 'erpname'
            , ERP_Id__c        = 'erpid'
        );
        insert erpStorefrontSettings;

        List<cc_LOL_ShippingOptions__c> shippingOptions = new List<cc_LOL_ShippingOptions__c> {
            new cc_LOL_ShippingOptions__c(
                Name                 = 'testshippingoption'
                , Provider__c        = 'provider'
                , ServiceName__c     = 'servicename'
                , UniqueId__c        = 'uniqueid'
                , SystemReference__c = 'sysref'
                , Store__c           = cc_lol_TestData.STOREFRONT_NAME
                , Priority__c        = 1
            )
        };
        insert shippingOptions;

        Bill_To__c billTo = new Bill_To__c(
            ERP_Id__c           = 'erpid'
            , ERP_Name__c       = 'erpname'
            , AR_Nbr__c         = 'arnbr'
            , Acct__c           = testAccount.Id
            , Line_Of_Credit__c = true
        );
        insert billTo;
    } */

    /*------------------------------------------------------------
    Description:   Create CC Orders
    ------------------------------------------------------------*/
    public static List<ccrz__E_Order__c> createExternalOrders(Integer numberOfOrders) {

        final List<ccrz__E_Order__c> testOrders = new List<ccrz__E_Order__c>();
        System.assert(testUser != null);
        for (Integer i = 0; i < numberOfOrders; i++) {
            testOrders.add(
                    new ccrz__E_Order__c(
                            ccrz__Account__c         = testAccount.Id,
                            ccrz__Contact__c         = testUser.ContactId,
                            ccrz__OrderNumber__c     = i,
                            ccrz__Storefront__c      = STOREFRONT_NAME,
                            ccrz__ShipTo__c          = shipToAddress.Id,
                            ccrz__OrderDate__c       = Date.Today(),
                            ccrz__BillTo__c          = billToAddress.Id
                    ));
        }
        System.assertEquals(testOrders.size(), numberOfOrders);
        upsert testOrders;

        final List<ccrz__E_OrderItem__c> testOrderItems = new List<ccrz__E_OrderItem__c>();
        final List<String> orderIds                              = new List<String>();

        for (Integer i = 0; i < numberOfOrders; i++) {
            testOrderItems.add(
                    new ccrz__E_OrderItem__c(
                            ccrz__Order__c           = testOrders.get(i).Id,
                            ccrz__Price__c           = 50,
                            ccrz__Quantity__c        = 2,
                            ccrz__SubAmount__c       = 20
                    ));
            orderIds.add(testOrders.get(i).Id);
        }
        insert testOrderItems;

        return [SELECT Id from ccrz__E_Order__c WHERE Id IN :orderIds];
    }
    public static List<ccrz__E_Order__c> createOrders(Integer numberOfOrders) {

        final List<ccrz__E_Order__c> testOrders = new List<ccrz__E_Order__c>();
        System.assert(testUser != null);
        for (Integer i = 0; i < numberOfOrders; i++) {
            testOrders.add(
                    new ccrz__E_Order__c(
                            ccrz__Account__c         = testAccount.Id,
                            ccrz__Contact__c         = testUser.ContactId,
                            OwnerId                  = testUser.Id,
                            ccrz__OrderNumber__c     = i,
                            ccrz__Storefront__c      = STOREFRONT_NAME,
                            ccrz__ShipTo__c          = shipToAddress.Id,
                            ccrz__OrderDate__c       = Date.Today(),
                            ccrz__BillTo__c          = billToAddress.Id
                    ));
        }
        System.assertEquals(testOrders.size(), numberOfOrders);
        upsert testOrders;

        final List<ccrz__E_OrderItem__c> testOrderItems = new List<ccrz__E_OrderItem__c>();
        final List<String> orderIds                              = new List<String>();

        for (Integer i = 0; i < numberOfOrders; i++) {
            testOrderItems.add(
                    new ccrz__E_OrderItem__c(
                            ccrz__Order__c           = testOrders.get(i).Id,
                            ccrz__Price__c           = 50,
                            ccrz__Quantity__c        = 2,
                            ccrz__SubAmount__c       = 20
                    ));
            orderIds.add(testOrders.get(i).Id);
        }
        insert testOrderItems;

        return [SELECT Id from ccrz__E_Order__c WHERE Id IN :orderIds];
    }
    /*------------------------------------------------------------
    Description:   Create CC Root Categories
    ------------------------------------------------------------*/
    public static void createRootCategories() {
        // all root
        ccrz__E_Category__c testAllRoot = new ccrz__E_Category__c(
                Name                = 'Productsadfsafds',
                ccrz__CategoryID__c = 'askflkldsakjlfdskjl',
                ccrz__StartDate__c  = Date.today().addDays(-1),
                ccrz__EndDate__c    = Date.today().addDays(1)
        );
        insert testAllRoot;

        // storefront root for BP
        ccrz__E_Category__c storefrontRoot = new ccrz__E_Category__c(
                Name                    = STOREFRONT_CATEGORY_ROOT,
                ccrz__CategoryID__c     = STOREFRONT_CATEGORY_ROOT_EXT_ID,
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = testAllRoot.Id
        );
        insert storefrontRoot;
        // storefront root for IR
        ccrz__E_Category__c storefrontRootIR = new ccrz__E_Category__c(
                Name                    = STOREFRONT_CATEGORY_ROOT_IR,
                ccrz__CategoryID__c     = STOREFRONT_CATEGORY_ROOT_EXT_ID + 'IR',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = testAllRoot.Id
        );
        insert storefrontRootIR;
    }
}