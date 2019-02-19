class Game

def initialize num_decks = 1
	cards = [2,3,4,5,6,7,8,9,10,'J','Q','K','A']
	suits = 4
	@shoe = (cards * suits) * num_decks
	@playing = true
	@next = -1
	@player = [['A',3],['5','K'],['A','10']]
	@dealer = []
	@bet = 0
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
	if @next >= (@shoe.length - 8)
		@next = -1
		shuffle
	end

	@next = @next + 1
	@shoe[@next]
end

def get_card_value card
	if card == 'J' || card == 'Q' || card == 'K'
		10
	elsif card == 'A'
		11
	else
		card.to_i
	end
end

def total hand
	total = 0
	hand.each do |card|
		total = total + get_card_value(card)
		if total > 21
			# use ace as 1 instead of 11
			has_ace = hand.index('A')
			if has_ace != nil
				hand[has_ace] = 1
				total = total - 10
			end
		end
	end

	if total == 21 && hand.length == 2
		total = 'BLACKJACK'
	elsif total > 21
		total = 'BUST'
	end

	total
end

def start
	shuffle
	while @playing == true
		print "Bet: "
		@bet = gets.chomp.to_i
		if @bet < 1 then next end

		@player.push([next_card, next_card])
		@dealer.push(next_card)
		@dealer.push('?')
		
		puts '******************'
		puts "Dealer: #{@dealer.join ' '}"

		# loop through each hand, one at a time.
		current_hand = 0
		@player.each do |hand|
			current_hand = current_hand + 1

			# loop until finished with this hand
			while true
				# show previous hands
				prev_hand = 0
				while prev_hand < current_hand
					# show swapped aces as 'A' instead of 1
					tmp_hand = @player[prev_hand].collect {|x| x == 1 ? 'A' : x}
					puts "Hand #{prev_hand + 1}: #{tmp_hand.join ' '} #{'----'*current_hand}> #{total @player[prev_hand]}"
					prev_hand = prev_hand + 1
				end
				
				print "\n(H)it (S)tand (D)ouble Down s(P)lit (Q)uit >>"
				command = gets.chomp.downcase

				if command == 'h'
					hand.push(next_card)
				elsif command == 's'
					break
				elsif command == 'd'
					
				elsif command == 'p'

				elsif command == 'q'
					Process.exit
				end

				if (total hand) == 'BUST' then break end
			end
		end

		# show players final scores
		i = 0
		@player.each do |hand|
			i = i + 1
			puts "Hand #{i + 1}: #{hand.join ' '} #{'----'*i}> #{total hand}"
		end

		# Dealers turn
		puts
		

	end
end
end

# RUN
game = Game.new
game.start