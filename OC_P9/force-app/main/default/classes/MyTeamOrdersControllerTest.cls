@isTest
private class MyTeamOrdersControllerTest {
    
     @TestSetup
    static void testData() {
        User user1 = TestDataFactory.createUser('User1');
        System.runAs(user1) {
             TestDataFactory.createOrderWithDedicatedOwnerId(4);
        }
        User user2 = TestDataFactory.createUser('User2');
         System.runAs(user2) {
             TestDataFactory.createOrderWithDedicatedOwnerId(3);
        }
        
		User user3 = TestDataFactory.createUser('User3');
         System.runAs(user3) {
             TestDataFactory.createOrderWithDedicatedOwnerId(5);
        }       
        
    }
    
    @isTest
    static void TestGetSumOrdersBySalesPeople() {
        
        List<Order> orderList = [SELECT Status FROM Order];
        
        for(Order o : orderList) {
            o.Status = 'Activated';
        }
        update orderList; 
       
		List<Order> orderListUpdated = [SELECT OwnerId, TotalAmount FROM Order WHERE Status='Activated'];
        Test.startTest();
        Map<String, Decimal> totalOrdersByOwnerFullName = MyTeamOrdersController.GetSumOrdersBySalesPeople();
        Test.stopTest();
       
        // after the testing stops, assert records habe been retreived properly
        Decimal totalOrderAmountUser1 = totalOrdersByOwnerFullName.get('User1');   // Retrieve the Total Amount, given a particular key  
        
        System.assert(totalOrdersByOwnerFullName.size()> 0); // Assert that the map is not empty
        System.assert(totalOrdersByOwnerFullName.containsKey('User1'));  // Assert that the map contains 3 keys
		System.assertEquals(64000, totalOrderAmountUser1);        
              
    }
    

}