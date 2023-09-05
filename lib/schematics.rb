# frozen_string_literal: true

require 'active_model/nested_attributes'
require 'active_model/validations/associated'
require 'active_model/validations/uniqueness'
require 'array'
require 'hash'
require 'object'
require 'tenant'
require 'uuid/shortener'
require 'validators/singular_validator'
require 'zeitwerk'
require defined?(Rails::Engine) ? 'schematics/engine' : 'debug'

Regexp.timeout = 1
$stdin.timeout = 1

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.ignore("#{__dir__}/active_model")
loader.ignore("#{__dir__}/active_record")
loader.ignore("#{__dir__}/active_storage")
loader.ignore("#{__dir__}/arel")
loader.ignore("#{__dir__}/backend")
loader.ignore("#{__dir__}/generators")
loader.ignore("#{__dir__}/i18n")
loader.ignore("#{__dir__}/jwt")
loader.ignore("#{__dir__}/mobility")
loader.ignore("#{__dir__}/open_api")
loader.ignore("#{__dir__}/puma")
loader.ignore("#{__dir__}/rails")
loader.ignore("#{__dir__}/search_engine")
loader.ignore("#{__dir__}/uuid")
loader.ignore("#{__dir__}/validators")
loader.ignore("#{__dir__}/view_component")
loader.ignore("#{__dir__}/array.rb")
loader.ignore("#{__dir__}/hash.rb")
loader.ignore("#{__dir__}/object.rb")
loader.ignore("#{__dir__}/rubygems_plugin.rb")
loader.ignore("#{__dir__}/tenant.rb")
loader.setup

module Schematics
end
