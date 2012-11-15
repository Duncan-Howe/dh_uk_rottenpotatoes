class Movie < ActiveRecord::Base
	def Movie.getRatings()
		return ['G','PG','PG-13','R']
	end

end
