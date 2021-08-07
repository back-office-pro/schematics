# frozen_string_literal: true

require 'array'
require 'json_web_token'
require 'zeitwerk'
require 'schematics/engine' if defined?(Rails)

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.ignore("#{__dir__}/generators")
loader.setup

module Schematics
end
