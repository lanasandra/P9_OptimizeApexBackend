public class AccountManager {
    
    public static void updateChiffreAffaire(Map<Id, Decimal> TotalAmountByAccountId){
     
       List<Account> listAccountUptaded = new List<Account>();
             
       List<Account> listAccountToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :TotalAmountByAccountId.keySet()];
             
        for(Account a : listAccountToUpdate) {
           Decimal ca = a.Chiffre_d_affaire__c;
           ca+= TotalAmountByAccountId.get(a.Id);
           listAccountUptaded.add(new Account(Id=a.Id, Chiffre_d_affaire__c=ca));
        }
                
        update listAccountUptaded;
    }
          
}