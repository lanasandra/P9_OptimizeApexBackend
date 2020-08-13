global class UpdateAccountTurnover implements Database.Batchable<sObject> {
      
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')]); 
        
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        
        List<Account> lAccsToUpdate = new List<Account>();
        
        AggregateResult[] groupedResults = [SELECT AccountId, SUM(TotalAmount) total FROM Order WHERE Status='Activated' AND AccountId IN :scope GROUP BY AccountId ];
  
            for(AggregateResult ar : groupedResults) {
                lAccsToUpdate.add(new Account(Id= (Id)ar.get('AccountId'), Chiffre_d_affaire__c= (decimal)ar.get('total')));
        }
   
                      
        update lAccsToUpdate;
    } 
    
    global void finish(Database.BatchableContext bc){
        
    }    
}