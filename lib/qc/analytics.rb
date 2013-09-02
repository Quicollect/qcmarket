class Analytics
	
	# ranges is an array of numbers represting different points in ranges
	# e.g. [0, 10,50,100, 999] will result in backets of [0..10], [11-50], [51-100], [101+]
	def self.bucketize(ranges, values)
		buckets = []
		
		# create the buckets
		(0..ranges.length - 3).each do |i|
			buckets << {max: ranges[i+1], label: "#{ranges[i]}-#{ranges[i+1]-1}", count: 0}
		end

		buckets << {max: ranges.last, label: "#{ranges[ranges.length-2]}+", count: 0}

		# now map the values
		values.each do | value |
			buckets.each do | bocket |
				if (bocket[:max] >= value)
					bocket[:count] += 1
					break
				end
			end
		end

		buckets
	end
end