# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class Server
  DEFAULT_PORT = 3000

  class << self
    def domain
      return 'localhost.me' if Rails.env.development?

      ENV.fetch('HOST', 'back-office.pro')
    end

    def ssl? = Pathname
      .new("/etc/letsencrypt/live/#{domain}")
      .exist?
  end
end
