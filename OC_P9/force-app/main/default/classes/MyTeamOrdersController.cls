public without sharing class MyTeamOrdersController {
   
    @AuraEnabled
    public static Map<String,Decimal> GetSumOrdersBySalesPeople() { 
        
       Map<String, Decimal> totalOrdersByOwnerFullName = new Map<String,Decimal>();
       Map<Id, Decimal> totalOrdersByOwnerId = new Map<Id,Decimal>();
       
        AggregateResult [] groupedResults = [SELECT OwnerId, SUM(TotalAmount) total FROM Order WHERE Status='Activated' GROUP BY OwnerId];
       
        for(AggregateResult ar: groupedResults) {
            totalOrdersByOwnerId.put((Id)ar.get('OwnerId'), (decimal)ar.get('total'));  
        }
        List<User> ownerOrder = [SELECT Id, Name FROM User WHERE Id IN: totalOrdersByOwnerId.keySet()];
        for(User u: ownerOrder) {
            totalOrdersByOwnerFullName.put(u.Name, totalOrdersByOwnerId.get(u.Id));
        }       
        return totalOrdersByOwnerFullName;
    }
}