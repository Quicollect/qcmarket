module AgencyReviewsHelper
	def stars_review(stars, size = :large)
		output = "<div class=\"rating text-#{size.to_s} read-only\">"
		active = (5-stars).round(0)
		(0..4).each do |i|
			if i == active
				output += '<span class="star active"></span>'
			else
				output += '<span class="star"></span>'
			end
		end
			        
	   output += "</div>"
	   output.html_safe
	end

	def level_value(val)
		val.nil? ? 3 : val
	end

	def stars_review_select(f, review, member)
		output = "<div class='row-fluid'><div class='span4' style='margin-top: 6px;'> #{member.to_s.humanize} </div>"
		output += "<div class='span8'><div class='rating text-medium read-only'>"
        active = 5-level_value(review[member])
        (0..4).each do | i |
			output += "<span class='star star-selectable#{i == active ? ' active' : ''}'></span>"
        end
		output += f.input member, as: :hidden, input_html: {value: level_value(review[member]).to_s}	
        output += "</div></div></div>"
	   	output.html_safe
	end
end
