class User < ActiveRecord::Base
  rolify
  devise :ldap_authenticatable, :rememberable, :trackable
end
