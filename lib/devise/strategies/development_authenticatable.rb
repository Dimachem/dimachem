require 'devise/strategies/authenticatable'

# https://github.com/hassox/warden/wiki/Strategies#what-is-a-strategy
module Devise
  module Strategies
    class DevelopmentAuthenticatable < Authenticatable

      def valid?
        Rails.env.development? && super
      end

      def authenticate!
        resource = mapping.to.where(authentication_hash).first

        return fail(:invalid) unless resource

        if password == 'dev123'
          remember_me(resource)
          success!(resource)
        end

        fail(:not_found_in_database) unless resource
      end

      private

    end
  end
end

Warden::Strategies.add(:development_authenticatable, Devise::Strategies::DevelopmentAuthenticatable)
