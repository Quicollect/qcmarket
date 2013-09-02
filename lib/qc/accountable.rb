module Accountable
	def self.included(base)
      base.has_one :account, :as => :accountable, :autosave => true
      base.validate :account_must_be_valid
      base.alias_method_chain :account, :autobuild
      base.extend ClassMethods
      base.define_account_accessors
    end
   
    def account_with_autobuild
      account_without_autobuild || build_account
    end

	def method_missing(meth, *args, &blk)
		puts "--- unable to find method #{meth}"
    account.send(meth, *args, &blk)
			rescue NoMethodError
		super
	end

	module ClassMethods
      def define_account_accessors
        all_attributes = Account.content_columns.map(&:name)
        ignored_attributes = ["created_at", "updated_at", "accountable_type"]
        attributes_to_delegate = all_attributes - ignored_attributes
        attributes_to_delegate.each do |attrib|
          class_eval <<-RUBY
            def #{attrib}
              account.#{attrib}
            end

            def #{attrib}=(value)
              self.account.#{attrib} = value
            end

            def #{attrib}?
              self.account.#{attrib}?
            end
          RUBY
        end
      end
    end

protected
    def account_must_be_valid
      unless account.valid?
        account.errors.each do |attr, message|
          errors.add(attr, message)
        end
      end
    end
end