class SimpleFormReadonlyBuilder < SimpleForm::FormBuilder                                                                                          
  def input(attribute_name, options={}, &block)                                 
    options[:readonly] = true
    super(attribute_name, options, &block)                                                          
  end
end