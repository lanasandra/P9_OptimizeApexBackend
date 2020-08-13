@isTest
public class TestDataFactory {
    
    public static Account createAccount(String name) {
        Account a = new Account( Name=name);
        insert a;
        return a;
    }
    
    
    public static Contract createContract(Id accountId) {
        Contract c = New Contract(Name = 'ContractTest', AccountId= accountId, StartDate= System.today(), ContractTerm=24, Status='Draft');
        insert c;
        c.Status = 'Activated';
        update c;
        return c;
    }

    public static Product2 createProduct() {
        Product2 product = new Product2(
            IsActive=true,
            Name= 'Test Product',
            Description='Description for test Product',
            CurrencyIsoCode='EUR');
        insert product;
        return product;
    }
    
     public static PricebookEntry createPricebookEntry(Id productId, Decimal amount) {
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id= Test.getStandardPricebookId(),
            Product2Id= productId,
            UnitPrice= amount,
            IsActive= true
        );
        insert pbEntry;
        return pbEntry;
        
     }
    
    public static User createUser(String lastName) {
        User user = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Custom: Sales Profile'].Id,
     		LastName = lastName,
     		Email = 'puser000@test.com',
     		Username = 'puser000@fasha.com' + System.currentTimeMillis(),
     		CompanyName = 'Fasha',
            IsActive=true,
            Title = 'title',
     		Alias = 'alias',
     		TimeZoneSidKey = 'America/Los_Angeles',
     		EmailEncodingKey = 'UTF-8',
     		LanguageLocaleKey = 'en_US',
     		LocaleSidKey = 'en_US',
     		UserRoleId = [Select Id FROM UserRole WHERE Name ='VP, International Sales'].Id
        	);
        insert user;
        return user;
    }
           
   public static Order createOrder(Id accountId, Id contractId){
         
        Order order = New Order (
        AccountId= accountId,
        ContractId= contractId,
        Status='Draft',
        EffectiveDate= Date.today(),
        Pricebook2Id= Test.getStandardPricebookId()
        );
        
        insert order;
        return order;
    	      
    }
      
     public static OrderItem createOrderItem(Id orderId, Id productId, Double quantity, Decimal unitPrice, Id pbEntryId) {
        OrderItem orderItem = new OrderItem(
        OrderId=orderId,
        Product2Id= productId,
        Quantity= quantity,
        UnitPrice=unitPrice,
        PricebookEntryId= pbEntryId
          );
        insert orderItem;
        return orderItem;
    }
    
    public static List <Order> createOrdersForOneAccount (Integer numberOfOrders) {
        List<Order> orderList = new List<Order> ();
        
        // Create the account, contract, product and PricebookEntry needed for the order
        Account a = TestDataFactory.createAccount('Test Account');
        Contract c = TestDataFactory.createContract(a.Id);
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pbEntry = TestDataFactory.createPricebookEntry(product.Id, 1000);
        
        // Create the list of orders 
        for(Integer i=0; i<numberOfOrders; i++) {
            Order order = TestDataFactory.createOrder(a.Id, c.Id);
            orderList.add(order);
        }
        // Create the orderItems for each order               
        for(Integer i=0; i<numberOfOrders; i++) {
            for(Order order : orderList) {
            OrderItem orderItem = TestDataFactory.createOrderItem(order.Id, product.Id, 4, 1000, pbEntry.Id);
            }
         
                
       update orderList;
        }
        return orderList;
          
}
    
   
     public static List<Order> UpdatePriceOfOrderItems(List<Id> ordersId) {
        
        List<OrderItem> orderItemsList = [SELECT OrderId, Product2Id, Quantity, UnitPrice FROM OrderItem WHERE OrderId IN:ordersId];
         
         for(OrderItem orderItem: orderItemsList) {
             orderItem.UnitPrice+= 100;
         }
         update orderItemsList;
         
         List<Order> ordersListUpdated = [SELECT Id, TotalAmount FROM Order WHERE Id IN: ordersId];
         
         update ordersListUpdated;
         
         return ordersListUpdated;
         
      
}
    
     public static List<Order> createOrderWithDedicatedOwnerId(Integer numberOfOrders) {
        List<Order> orderList = new List<Order>();
       
        // Create the account, contract, product and PricebookEntry and an User needed for the order
        Account a = TestDataFactory.createAccount('Test Account');
        Contract c = TestDataFactory.createContract(a.Id);
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pbEntry = TestDataFactory.createPricebookEntry(product.Id, 1000);
  		
        
        for(Integer i=0; i<numberOfOrders; i++) {
            Order order = TestDataFactory.createOrder(a.Id, c.Id);
            orderList.add(order);
        }
                
        // Create the orderItems for each order               
        for(Integer i=0; i<numberOfOrders; i++) {
            for(Order order : orderList) {
            OrderItem orderItem = TestDataFactory.createOrderItem(order.Id, product.Id, 4, 1000, pbEntry.Id);
            }
            
        }
        
        update orderList;
		return orderList;      
               
    }
    
}