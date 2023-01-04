# frozen_string_literal: true

require 'active_model/nested_attributes'
require 'array'
require 'json_web_token'
require 'object'
require 'tenant'
require 'validators/english_validator'
require 'validators/singular_validator'
require 'zeitwerk'
require 'schematics/engine' if defined?(Rails::Engine)

Regexp.timeout = 1.0

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.ignore("#{__dir__}/active_model")
loader.ignore("#{__dir__}/active_record")
loader.ignore("#{__dir__}/active_storage")
loader.ignore("#{__dir__}/backend")
loader.ignore("#{__dir__}/generators")
loader.ignore("#{__dir__}/i18n")
loader.ignore("#{__dir__}/open_api")
loader.ignore("#{__dir__}/rails")
loader.ignore("#{__dir__}/simple_form")
loader.ignore("#{__dir__}/validators")
loader.ignore("#{__dir__}/view_component")
loader.ignore("#{__dir__}/array.rb")
loader.ignore("#{__dir__}/json_web_token.rb")
loader.ignore("#{__dir__}/object.rb")
loader.ignore("#{__dir__}/tenant.rb")
loader.setup

module Schematics
end
