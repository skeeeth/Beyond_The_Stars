##Strategy resource refers to Strategy Pattern
##see (https://www.youtube.com/watch?v=sZDJJeDNe_M) for more info
@abstract extends Resource
class_name BaseCardStrategy


@warning_ignore("unused_signal")
signal applied

@abstract func apply(card:CardData,lane:Lane,active_cards:Array[CardDisplay])
