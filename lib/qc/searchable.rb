module Searchable

	def search(search)
	    if search
	    	where("name like '%#{search.downcase}%'")
	    else
	    	all
	    end
  	end

end
