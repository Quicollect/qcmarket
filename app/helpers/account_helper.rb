module AccountHelper
	def account_edit_path(id)
		account = Account.find(id)
		eval("edit_" + account.accountable_type.downcase + "_path #{account.id}")
	end

	def account_show_path(id)
		account = Account.find(id)
		eval(account.accountable_type.downcase + "_path(#{account.id})")
	end
end
