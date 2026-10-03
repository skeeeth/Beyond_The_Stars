##Gameplay Resource Management Singleton, handles the reading and writing of resource values through
##wrapper functions to manage signal bussing of listeners of resource value
extends Node
#Resource Manager


signal value_changed(type:RM.types, amount:int)

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
##NOTE: do not add negative values to spend, instead use spend_resource()
func add_resource(type:types,amount:int):
	current[type] += amount
	value_changed.emit(type, amount)
