@isTest
private class UpdateAccountCATest {
    
    @TestSetup
    static void testData() {
        Account a = TestDataFactory.createAccount('Test Account');
        a.Chiffre_d_affaire__c=0;
        update a;
        Contract c = TestDataFactory.createContract(a.Id);
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product.Id, 1000);
        Order order = TestDataFactory.createOrder(a.Id, c.Id);
        OrderItem orderItem = TestDataFactory.createOrderItem(order.Id, product.Id, 4, 1000, pbe.Id);
        update order;
    }
        
    
    @isTest
    static void TestUpdateAccountWhenOrderActivated() {
   
        Account a = [SELECT Id, Chiffre_d_affaire__c FROM Account LIMIT 1];
        Order o = [SELECT Id, TotalAmount FROM Order WHERE AccountId=: a.Id];
               
        o.Status = 'Activated';
        update o;
       
        // Verify that the turnover of the related account has been updated
        o = [SELECT Id, TotalAmount FROM Order WHERE AccountId=: a.Id];
               
        a = [SELECT Id, Chiffre_d_affaire__c FROM Account LIMIT 1];
        
        System.assertEquals(4000, a.Chiffre_d_affaire__c);
        
    }

}