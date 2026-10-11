##Strategy resource refers to Strategy Pattern
##see (https://www.youtube.com/watch?v=sZDJJeDNe_M) for more info
@abstract extends Resource
class_name BaseCardStrategy


@warning_ignore("unused_signal")
signal applied

@abstract func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay])

func find_display(data:CardData, list:Array[CardDisplay]) -> CardDisplay:
	for k in list:
		if k.data == data:
			return k
	
	return null


func add_stats(card:CardData,color:Dictionary[RM.types,int],
		grey:Dictionary[int,int], temp:bool = false):
	
	var color_array = card.temp_color_mod if temp else card.static_color_mod
	var rel_array = card.temp_grey_mod if temp else card.static_grey_mod
	
	for c in color: 
		#if temp:
			#card.temp_color_mod[c] += color[c]
		color_array[c] += color[c]
	
	for i in grey:
		rel_array[i] += grey[i]
