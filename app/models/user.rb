class User < ActiveRecord::Base
  rolify
  devise :ldap_authenticatable, :rememberable, :trackable

  has_many :users_roles

  accepts_nested_attributes_for :users_roles, allow_destroy: true

end
