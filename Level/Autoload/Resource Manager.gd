##Gameplay Resource Management Singleton, handles the reading and writing of resource values through
##wrapper functions to manage signal bussing of listeners of resource value
extends Node
#Resource Manager


signal resource_added(type:RM.types, amount:int)
signal resource_spend(type:RM.types, amount:int)

signal favor_scored_in_lane(type:RM.types, amount:int)

#hard set names, so that actual interpretation of each slot can be changed later
enum types{RED,GREEN,BLUE}


## The Current values of each resource
var current:Dictionary[types,int] = {
	types.RED: 3,
	types.GREEN: 3,
	types.BLUE: 0,
}

const names:Dictionary[types,String] = {
	types.RED: "Money",
	types.GREEN: "Food",
	types.BLUE: "Cultists"
}

var cumulative:Dictionary[types,int] = {
	types.RED: 0,
	types.GREEN: 0,
	types.BLUE: 0,
}

##add an amount of resource to current and fire a coprresponding signal
##NOTE: do not add negative values to spend, instead use try_spend()
func add_resource(type:types,amount:int):
	current[type] += amount
	cumulative[type] += amount
	resource_added.emit(type, amount)
	

##attempts to spend an amount of a resource and returns the result
func try_spend(type:types,amount:int)->bool:
	if current[type] >= amount:
		current[type] -= amount
		resource_spend.emit(type,amount)
		return true
	return false


func try_spend_all(dict:Dictionary[types,int]) -> bool:
	#var all_success = true
	for t in types.values():
		if current[t] < dict[t]: 
			return false #if we dont have enough of any resource abort the whole thing
	
	#we're calling try spend here but previous block confirms all will succeed
	for t in types.values():
		try_spend(t,dict[t])
	return true
	
	
func score_favor(lane:types, amount:int):
	favor_scored_in_lane.emit(lane, amount)
