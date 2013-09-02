module SwitchUser
  module Provider
    class Base
      def original_user
        current_user.class.find(@controller.session[:original_user]) if current_user && @controller.session[:original_user]
      end

      def remember_current_user(remember)
        if remember
          @controller.session[:original_user] = current_user.id
        else
          @controller.session.delete(:original_user)
        end
      end
    end
  end
end