class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :confirmable

  include RoleModel

  roles :admin, :account_admin, :user, :agency, :creditor

  validates :name, presence: true
  
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  after_create  :post_create
    
  def original_user=(user)
    @original_user = user
  end

  def original_user
    @original_user ? @original_user : self
  end

  def is_admin_origin?
    self.is_admin? || (@original_user && @original_user.is_admin?)
  end

  def post_create
    SystemMailer.new_user_email(self).deliver
  end

  def self.search(search)
      if search
        User.where("name like '%#{search.downcase}%'")
      else
        all
      end
    end
end
