# frozen_string_literal: true

require 'capybara/cuprite'

Capybara.javascript_driver = :cuprite
Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(app, process_timeout: 30, timeout: 30)
end
