# frozen_string_literal: true

module Schematics
  module Footer
    module HelpCenter
      class Component < ApplicationComponent
        delegate :domain, to: ::Tenant, private: true
        delegate :live_support?, :email_support?, to: '::Licence.instance', private: true

        def support_email = "support@#{domain}"

        def documentation_url = ::URI::HTTPS
          .build(host: "www.#{domain}", path: '/docs')
          .to_s
      end
    end
  end
end
