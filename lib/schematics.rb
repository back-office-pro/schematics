# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require_relative 'active_model/nested_attributes'
require_relative 'active_model/validations/associated_validator'
require_relative 'active_model/validations/uniqueness_validator'
require_relative 'array'
require_relative 'hash'
require_relative 'numeric'
require_relative 'object'
require_relative 'validators/singular_validator'
require 'zeitwerk'

Regexp.timeout = 1
$stdin.timeout = 1

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
loader.ignore("#{__dir__}/omniauth")
loader.ignore("#{__dir__}/onelogin")
loader.ignore("#{__dir__}/rails")
loader.ignore("#{__dir__}/solid_queue")
loader.ignore("#{__dir__}/validators")
loader.ignore("#{__dir__}/array.rb")
loader.ignore("#{__dir__}/hash.rb")
loader.ignore("#{__dir__}/numeric.rb")
loader.ignore("#{__dir__}/object.rb")
loader.setup

module Schematics
end
