module SimpleForm 
  module Components 
    module ContainedInput 
      def contained_input 
        '<div class="controls">' + input + (error.nil? ? '' : error) + '</div>'
      end 
    end 
  end 
  module Inputs 
    class Base 
      include SimpleForm::Components::ContainedInput
    end 
  end 
end