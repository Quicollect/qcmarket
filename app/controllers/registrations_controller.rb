class RegistrationsController < Devise::RegistrationsController
	def new
		super
  	end

	# TODO: 'normalize' this method. too much code and if/else
	def create

		# check first if captcha is needed (not a user / captcha is disabled)
		if (!current_user && Rails.application.config.captcha)
			if (!verify_recaptcha)
				build_resource
		        clean_up_passwords resource
		        flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."      
		        flash.delete :recaptcha_error
		        render :new
		        return
			end
		end

		
		build_resource(sign_up_params)

		if (current_user)
			resource.account_id |= current_user.account_id
		end

		# now verify this user can create such user under this account
		authorize! :create, resource

		# if created by admin for its own account
		if current_user
			# chage this to limit only the roles the parent user have and receive it as parameter
			# inherit roles from parent user accept admin and account_admin
			current_user.roles.each do |role|
				if (role != :admin && role != :account_admin)
					resource.roles << role
				end
			end
			
			resource.skip_confirmation!
			
		# new user registered - we need to create an account to it & give it roles 
		else
			resource.roles << [:account_admin, :user, (params[:roles] == 'Agency' ? :agency : :creditor)]
			
			# now we create the accout to connect the user to
			if resource.has_role? :agency
				new_account = Agency.new(name: resource.name)	
			else
				new_account = Creditor.new(name: resource.name)
			end

			new_account.resolve_address

			if !new_account.save
				clean_up_passwords resource
	      		return respond_with resource
			end

			resource.account_id = new_account.id
		end
		
		if resource.save
			if resource.active_for_authentication?
				set_flash_message :notice, :signed_up if is_navigational_format?
				sign_up(resource_name, resource)
				respond_with resource, :location => after_sign_up_path_for(resource)
			else
				set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
				expire_session_data_after_sign_in!
				respond_with resource, :location => after_inactive_sign_up_path_for(resource)
			end
	    else
			clean_up_passwords resource
			respond_with resource
	    end
	end

	def update
		authorize! :update, User.find_by_id(params[:id])
    	super
    end

    def edit
    	authorize! :update, User.find_by_id(params[:id])
    	super
    end

private
	def sign_up_params
	  params.require(:user).permit(:name, :email, :password, :password_confirmation, :account_id)
	end

	def after_inactive_sign_up_path_for(resource)
    	sign_in_path
  	end
end