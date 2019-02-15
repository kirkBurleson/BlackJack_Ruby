class BJ
	def initialize num_decks = 1
		cards = [	:H2,:H3,:H4,:H5,:H6,:H7,:H8,:H9,:H10,:HJ,:HQ,:HK,:HA,
					:C2,:C3,:C4,:C5,:C6,:C7,:C8,:C9,:C10,:CJ,:CQ,:CK,:CA,
					:S2,:S3,:S4,:S5,:S6,:S7,:S8,:S9,:S10,:SJ,:SQ,:SK,:SA,
					:D2,:D3,:D4,:D5,:D6,:D7,:D8,:D9,:D10,:DJ,:DQ,:DK,:DA]
		@shoe = cards * num_decks
	end

	def show
		puts "Cards: #{@shoe.length}"
		@shoe.each do |e|
			print "#{e} "
		end
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

end

