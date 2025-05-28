# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_model/nested_attributes'
require 'active_model/validations/associated'
require 'active_model/validations/uniqueness'
require 'array'
require 'hash'
require 'numeric'
require 'object'
require 'schema_cache'
require 'server'
require 'validators/singular_validator'
require 'zeitwerk'
require defined?(Rails::Engine) ? 'schematics/engine' : 'debug/prelude'

Regexp.timeout = 1
$stdin.timeout = 1

Warning[:deprecated] = true

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.ignore("#{__dir__}/active_model")
loader.ignore("#{__dir__}/active_record")
loader.ignore("#{__dir__}/active_storage")
loader.ignore("#{__dir__}/arel")
loader.ignore("#{__dir__}/bootstrap-email")
loader.ignore("#{__dir__}/generators")
loader.ignore("#{__dir__}/i18n")
loader.ignore("#{__dir__}/mobility")
loader.ignore("#{__dir__}/onelogin")
loader.ignore("#{__dir__}/open_api")
loader.ignore("#{__dir__}/puma")
loader.ignore("#{__dir__}/rails")
loader.ignore("#{__dir__}/solid_queue")
loader.ignore("#{__dir__}/spec")
loader.ignore("#{__dir__}/validators")
loader.ignore("#{__dir__}/array.rb")
loader.ignore("#{__dir__}/hash.rb")
loader.ignore("#{__dir__}/numeric.rb")
loader.ignore("#{__dir__}/object.rb")
loader.ignore("#{__dir__}/rubygems_plugin.rb")
loader.ignore("#{__dir__}/schema_cache.rb")
loader.ignore("#{__dir__}/server.rb")
loader.ignore("#{__dir__}/tenant.rb")
loader.setup

module Schematics
end
