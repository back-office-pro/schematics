# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'capybara/cuprite'

Capybara.disable_animation = true
Capybara.javascript_driver = :cuprite
Capybara.app_host = 'http://default.localhost.me'
Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(
    app,
    process_timeout: 30,
    timeout: 30,
    browser_options: { 'no-sandbox': nil, 'disable-setuid-sandbox': nil }
  )
end
