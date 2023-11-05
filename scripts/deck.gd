extends Node

var cards = Array()
var discarded = Array()
var textures = {
	"Annointed": preload("res://media/cards/graphics/AnnointedCard.svg"),
	"Bishop": preload("res://media/cards/graphics/BishopCard.svg"),
	"ButterFingers": preload("res://media/cards/graphics/ButterFingersCard.svg"),
	"Castle": preload("res://media/cards/graphics/CastleCard.svg"),
	"Divorce": preload("res://media/cards/graphics/DivorceCard.svg"),
	"FalseProphet": preload("res://media/cards/graphics/FalseProphetCard.svg"),
	"HighHeels": preload("res://media/cards/graphics/HighHeelsCard.svg"),
	"Knight": preload("res://media/cards/graphics/KnightCard.svg"),
	"Martyrdom": preload("res://media/cards/graphics/MartyrdomCard.svg"),
	"NuclearWarfare": preload("res://media/cards/graphics/NuclearWarfareCard.svg"),
	"ParkFeeding": preload("res://media/cards/graphics/ParkFeedingCard.svg"),
	"Pawn": preload("res://media/cards/graphics/PawnCard.svg"),
	"Queen": preload("res://media/cards/graphics/QueenCard.svg"),
	"RaceAccident": preload("res://media/cards/graphics/RaceAccidentCard.svg"),
	"RainingMen": preload("res://media/cards/graphics/RainingMenCard.svg"),
	"Revert": preload("res://media/cards/graphics/RevertCard.svg"),
	"Rook": preload("res://media/cards/graphics/RookCard.svg"),
	"Turducken": preload("res://media/cards/graphics/TurduckenCard.svg"),
	"WetConcrete": preload("res://media/cards/graphics/WetConcreteCard.svg")
}
var card_counts = {
	"Annointed": 1,
	"Bishop": 10,
	"ButterFingers": 2,
	"Castle": 2,
	"Divorce": 1,
	"FalseProphet": 1,
	"HighHeels": 2,
	"Knight": 10,
	"Martyrdom": 2,
	"NuclearWarfare": 1,
	"ParkFeeding": 1,
	"Pawn": 25,
	"Queen": 5,
	"RaceAccident": 1,
	"RainingMen": 2,
	"Revert": 2,
	"Rook": 10,
	"Turducken": 1,
	"WetConcrete": 1
}
# Called when the node enters the scene tree for the first time.
func _ready():
	cards = Array()
	for key in card_counts.keys():
		for i in range(card_counts[key]):
			cards.append(key)
	shuffle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shuffle():
	for i in range(len(cards)-1, 0, -1):
		var idx = randi_range(0, i+1)
		var temp = self.cards[idx]
		self.cards[idx] = self.cards[i]
		self.cards[i] = temp

func draw(num):
	var drawn = Array()
	for i in range(num):
		if(len(cards) >= 1):
			drawn.append(cards.pop_front())
		else:
			while len(discarded) > 0:
				cards.append(discarded.pop_front())
			shuffle()
			drawn.append(cards.pop_front())
		
	return drawn

func discard(array):
	for card in array:
		discarded.append(card)
