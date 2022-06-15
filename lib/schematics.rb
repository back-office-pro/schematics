# frozen_string_literal: true

require 'array'
require 'object'
require 'json_web_token'
require 'zeitwerk'
require 'schematics/engine' if defined?(Rails)

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.enable_reloading
loader.setup

module Schematics
end
