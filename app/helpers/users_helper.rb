module UsersHelper
	def status_icon(user)
		if user.locked_at.nil? 
		    if user.failed_attempts == 0
		        if user.confirmed_at
		          'icon-thumbs-up-alt'
		        else
		          'icon-question'
		        end 
		    else
		        'icon-warning-sign'
		    end
		else
		    'icon-lock'
		end
	end

	def user_name_ex(element)
		element.user_id ? User.find(element.user_id).name : "anonymous user"
	end
end
