global class UpdateAccountTurnoverScheduled implements Schedulable {
        
    global void execute(SchedulableContext sc) {
        UpdateAccountTurnover uat = new UpdateAccountTurnover(); 
        Id batchId = Database.executeBatch(uat);  
   }

}