class User < ActiveRecord::Base
  devise :ldap_authenticatable, :rememberable, :trackable, :validatable
end
