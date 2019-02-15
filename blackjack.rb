class Game

class Test
	def initialize
		@hand = []
	end

	def total
		first = @hand[0].to_int
	end
end

def initialize num_decks = 1
	cards = [	2,3,4,5,6,7,8,9,10,'J','Q','K','A',
				2,3,4,5,6,7,8,9,10,'J','Q','K','A',
				2,3,4,5,6,7,8,9,10,'J','Q','K','A',
				2,3,4,5,6,7,8,9,10,'J','Q','K','A']
	@shoe = cards * num_decks
	@playing = true
	@choice = nil
	@flip = false
	@next = -1
	@player = []
	@dealer = []
end


def shuffle
	last = @shoe.length
	while last > 1
		pick = rand(last)
		tmp = @shoe[last-1]
		@shoe[last-1] = @shoe[pick]
		@shoe[pick] = tmp
		last = last - 1
	end	
end

def next_card
	if @next == (@shoe.length - 1)
		@next = -1
		shuffle
	end

	@next = @next + 1
	@shoe[@next]
end

def deal
	@player.push(next_card)
	@player.push(next_card)
	@dealer.push(next_card)
	@dealer.push(next_card)
end


def play
	@playing = false
end


def show_cards
	print "\n"*5

	puts "Dealer: #{@dealer.join ' '} --> #{total @dealer}"
	puts "Player: #{@player.join ' '} --> #{total @player}"
end

def total hand
	total = 0
	hand.each do |rank|
		total = total + get_card_value(rank)
	end
	total
end

def get_card_value card
	if card == 'J' || card == 'Q' || card == 'K'
		10
	else
		if card == 'A'
			11
		else
			card.to_i
		end		
	end
end


def start
	shuffle
	while @playing == true
		deal
		show_cards
		play
	end
end
end

# RUN
game = Game.new
game.start