# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'uri'

class Server
  DEFAULT_PORT = 3000

  class << self
    def application_record_class
      return ApplicationRecord if defined?(ApplicationRecord)

      ActiveRecord::Base
    end

    def application_controller_class
      return ApplicationController if defined?(ApplicationController)

      ActionController::Base
    end

    def application_job_class
      return ApplicationJob if defined?(ApplicationJob)

      ActiveJob::Base
    end

    def application_mailer_class
      return ApplicationMailer if defined?(ApplicationMailer)

      ActionMailer::Base
    end

    def domain
      ENV.fetch('HOST', 'back-office.pro')
    end

    def support_email = "support@#{domain}"

    def no_reply_email = "no-reply@#{domain}"

    def url(path: nil) = URI::HTTPS
      .build(host: "www.#{domain}", path:)
      .to_s

    def organization
      domain.parameterize
    end

    def ssl_path
      Pathname.new("/etc/letsencrypt/live/#{domain}")
    end

    def ssl?
      ssl_path.exist?
    end

    def port
      DEFAULT_PORT unless Rails.env.production?
    end
  end
end
