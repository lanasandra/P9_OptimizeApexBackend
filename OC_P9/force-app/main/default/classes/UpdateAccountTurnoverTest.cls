@isTest
private class UpdateAccountTurnoverTest {
    
    @TestSetup
    static void testData() {
        List<Order> orderList = TestDataFactory.createOrdersForOneAccount(5);
        
    }
    
    @isTest
    static void TestUpdateAccountTurnover () {
        List<Order> orderList = [SELECT Id, AccountId, Status FROM Order];
        
        for(Order o : orderList) {
            o.Status = 'Activated';
        }
        update orderList; 
        
        List<Id> OrdersId = new List<Id>();
        
        for(Order o : orderList) {
            ordersId.add(o.Id);
        }
        
        List<Order> ordeListWithUnitPriceProductUpdated = TestDataFactory.UpdatePriceOfOrderItems(OrdersId); 
        
        Test.startTest();
        UpdateAccountTurnover uat = new UpdateAccountTurnover();
        Id batchId = Database.executeBatch(uat);
        Test.stopTest();
        
        // after the testing stops, assert records were updated properly
        
        Account a = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        List<Order> orderListUpdated = [SELECT AccountId, Status FROM Order WHERE AccountId=: a.Id];        
        
        System.assertEquals(110000, a.Chiffre_d_affaire__c);
    }
    
}