module AgencyHelper

	def score_display(agency)
		score = agency.score
		score == -1 ? 'N/A' : score.round(1)
	end
end
