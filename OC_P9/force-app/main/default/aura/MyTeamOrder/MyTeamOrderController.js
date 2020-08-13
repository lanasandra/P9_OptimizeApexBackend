({
    init: function (component, event, helper) {
        
        var actionGetSumOrders = component.get("c.GetSumOrdersBySalesPeople");
        
        actionGetSumOrders.setCallback( this, (result) => {
            if( result.getState() === "SUCCESS"){
            
            var salesPeople = [];
            var sumOrders = result.getReturnValue();
            
            for(var key in sumOrders) {
            salesPeople.push({value:sumOrders[key], key:key});
    			}
    	component.set('v.sales', salesPeople);
			}
 
 		})

		$A.enqueueAction(actionGetSumOrders);

}
})