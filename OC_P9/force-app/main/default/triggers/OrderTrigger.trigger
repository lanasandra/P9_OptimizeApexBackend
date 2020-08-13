trigger OrderTrigger on Order (after update) {
    
    Map<Id, Decimal> MapTotalAmountOrderByAccountId = new Map<Id, Decimal>(); 
    
    Decimal orderAmount =0;
    
    for(Order o : Trigger.New) {
        if(Trigger.isUpdate) {
            if(o.Status=='Activated' && o.Status!= Trigger.oldMap.get(o.Id).Status) {
                orderAmount += o.TotalAmount;
                MapTotalAmountOrderByAccountId.put(o.AccountId, orderAmount);
            }
        }
    }
        
    if(MapTotalAmountOrderByAccountId.size() > 0) AccountManager.updateChiffreAffaire(MapTotalAmountOrderByAccountId);
}