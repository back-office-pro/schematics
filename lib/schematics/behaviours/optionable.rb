# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Behaviours
    # :reek:Attribute
    module Optionable
      extend ActiveSupport::Concern

      include ::ActiveModel::API
      include ::ActiveModel::NestedAttributes

      attr_writer :options

      delegate :hidden?, to: :options
      delegate :keys, to: :options, prefix: true, private: true

      included do
        accepts_nested_attributes_for :options
        validates :options_keys, inclusion: { in: :allowed_options_names }
      end

      def available_options = []

      def options = Options::Wrapper.new(options: @options)

      protected

      def allowed_options_names = available_options.map(&:option_name)
    end
  end
end
