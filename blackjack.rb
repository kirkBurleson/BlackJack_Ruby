class Game

def initialize num_decks = 1
	cards = [2,3,4,5,6,7,8,9,10,'J','Q','K','A']
	suits = 4
	@shoe = (cards * suits) * num_decks
	@playing = true
	@next = -1
	@player = []
	@dealer = []
	@bet = 0
	@money = 50.00
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

def has_soft_17? hand
	total = total hand
	if total == 17 && hand.index('A') != nil && hand.index(6) != nil
		true
	end

	false
end

def collect dealer_total
	puts '------------------------'
	won = 0
	i = 0
	@player.each do |hand|
		score = total hand
		
		if score == 'BUST' && dealer_total == 'BUST'
			#tie
		elsif score == 'BUST'
			won = won - @bet
		elsif dealer_total == 'BUST'
			won = won + @bet

		elsif score == 'BLACKJACK' && dealer_total == 'BLACKJACK'
			#tie
		elsif score == 'BLACKJACK'
			won = won + (@bet + (@bet / 2))
		elsif dealer_total == 'BLACKJACK'
			won = won - @bet

		elsif score == dealer_total
			#tie
		elsif score > dealer_total
			won = won + @bet
		elsif score < dealer_total
			won = won - @bet
		end
	end

	if won == 0
		puts 'Push'
	elsif won > 0
		puts 'Winner'
	else
		puts 'Loser'
	end

	@money = @money + won
end

def start
	shuffle
	while @playing == true
		if @money < 1 then @playing = false; break end

		print "#{@money} | Bet: "
		@bet = gets.chomp.to_i
		if @bet == -1 then Process.exit end
		if @bet < 1 || @bet > @money then next end

		@player.push([next_card, next_card])
		@dealer.push(next_card)
		@dealer.push('?')
		
		puts '******************'
		puts "Dealer: #{@dealer.join ' '}"

		# loop through each hand, one at a time.
		@player.each do |hand|
			# this hand is from a split, needs second card
			if hand.length == 1 then hand.push(next_card) end

			# loop until finished with this hand
			while true
				
				# show previous hands
				start = 0
				while @player[start] != hand
					# show swapped aces as 'A' instead of 1
					tmp_hand = @player[start].collect {|x| x == 1 ? 'A' : x}
					puts "Hand #{start + 1}: #{tmp_hand.join ' '} ----> #{total @player[start]}"
					start = start + 1
				end
				puts "Hand #{start + 1}: #{hand.join ' '} ----> #{total hand}"

				print "\n(H)it (S)tand (D)ouble Down s(P)lit (Q)uit >>"
				command = gets.chomp.downcase

				if command == 'h'
					hand.push(next_card)

				elsif command == 's'
					break

				elsif command == 'd'
					# can only double down on 9, 10, or 11
					total = total hand
					if hand.length == 2 && total > 8 && total < 12 && @money >= (@bet * 2)
						hand.push(next_card)
						@bet = @bet * 2
						break
					else
						puts 'Can only double down with 9, 10, or 11 on first 2 cards.'
						puts 'Must have money to cover a loss'
					end

				elsif command == 'p'
					# can split pairs only
					if hand.length == 2 && hand[0] == hand[1] && @player.length < 4
						new_hand = [hand[1]]
						hand[1] = next_card
						hand.unshift('s')
						@player.push(new_hand)
					else
						puts 'Can only split if first 2 cards are the same'
					end

				elsif command == 'q'
					Process.exit

				else
					puts 'Invalid option'
				end

				if (total hand) == 'BUST' then break end
			end
		end

		# show players final scores
		i = 0
		@player.each do |hand|
			i = i + 1
			puts "Hand #{i}: #{hand.join ' '} #{'----'*i}> #{total hand}"
		end

		# DEALER'S TURN
		# -------------

		# Deal second card
		@dealer[1] = next_card
		
		# Must hit if total < 17 or soft 17 (A6)
		while true
			puts "Dealer: #{@dealer.join(' ')} >> #{total @dealer}"
			total = total @dealer
			if total == 'BLACKJACK' || total == 'BUST'
				collect total
				break
			elsif total > 16 && has_soft_17?(@dealer) == false
				puts "Dealer stands at #{total}"
				collect total
				break
			elsif total < 17 || has_soft_17?(@dealer)
				@dealer.push next_card
			end
		end

		# prepare for next round
		@player.clear
		@dealer.clear
	end
end

end

# RUN
game = Game.new
game.start