# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'uri'

class Server
  DEFAULT_PORT = 3000

  class << self
    def domain
      return 'localhost.me' if Rails.env.development?

      ENV.fetch('HOST', 'back-office.pro')
    end

    def url(path: nil) = URI::HTTPS
      .build(host: "www.#{domain}", path:)
      .to_s

    def ssl? = Pathname
      .new("/etc/letsencrypt/live/#{domain}")
      .exist?
  end
end
