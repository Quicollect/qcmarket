class SystemMailer < ActionMailer::Base
  default from: ENV["SYSTEM_FROM_EMAIL"]

  def new_user_email(user)
  	@user = user
  	mail(to: ENV["SYSTEM_EMAIL"], subject: 'New user registration')
  end

  def request_for_proposal(debt, proposal, agency)
  	@debt = debt
  	@proposal = proposal
  	@agency = agency
  	mail(to: agency.email, bcc: ENV["SYSTEM_EMAIL"], subject: 'New debt available')
  end

  def debt_details(debt, agency)
  	@debt = debt
  	@agency = agency
  	mail(to: agency.email, bcc: ENV["SYSTEM_EMAIL"], subject: "Debt details (#{@debt.title})")
  end
end
