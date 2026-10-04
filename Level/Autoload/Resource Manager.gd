##Gameplay Resource Management Singleton, handles the reading and writing of resource values through
##wrapper functions to manage signal bussing of listeners of resource value
extends Node
#Resource Manager


signal resource_added(type:RM.types, amount:int)
signal resource_spend(type:RM.types, amount:int)

#hard set names, so that actual interpretation of each slot can be changed later
enum types{RED,GREEN,BLUE}


## The Current values of each resource
var current:Dictionary[types,int] = {
	types.RED: 0,
	types.GREEN: 0,
	types.BLUE: 0,
}

const names:Dictionary[types,String] = {
	types.RED: "Money",
	types.GREEN: "Food",
	types.BLUE: "Cultists"
}

##add an amount of resource to current and fire a coprresponding signal
##NOTE: do not add negative values to spend, instead use try_spend()
func add_resource(type:types,amount:int):
	current[type] += amount
	resource_added.emit(type, amount)
	

##attempts to spend an amount of a resource and returns the result
func try_spend(type:types,amount:int)->bool:
	if current[type] >= amount:
		current[type] -= amount
		resource_spend.emit(type,amount)
		return true
	return false
