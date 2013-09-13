
class RandomLookup
	def self.rand_id(cls)
		cls.all[Random.rand(cls.all.length)].id
	end
end