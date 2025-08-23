# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class Server
  DEFAULT_PORT = 3000

  class << self
    def domain = ENV.fetch('HOST', 'localhost')

    def ssl? = Pathname
      .new("/etc/letsencrypt/live/#{domain}")
      .exist?
  end
end
