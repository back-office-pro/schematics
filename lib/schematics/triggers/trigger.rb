# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'action_view'

module Schematics
  module Triggers
    # :reek:Attribute
    class Trigger
      include Behaviours::Specifiable
      include ::ActiveModel::API
      include ::ActionView::Helpers::TranslationHelper

      ACTIONS = %w[
        after_create
        after_destroy
        after_save
        before_create
        before_destroy
        before_save
      ].freeze

      validates :callback,
                presence: true,
                format: { with: Tokens::Tokenizer.parser, message: :function }
      validates :action,
                presence: true,
                inclusion: { in: ACTIONS }
      attr_accessor :id, :entity, :action, :callback

      class << self
        def to_proc = -> { new(**it) }
      end

      def method_name = [action, id]
        .join('_')
        .underscore
        .to_sym

      def to_str
        case [action, callback]
        in ['before_create', *] | ['before_save', *] | ['before_destroy', *]
          <<~RUBY
            #{action} :#{method_name}
            def #{method_name}
              #{method_body}
            rescue StandardError => e
              raise Triggers::Errors::StandardError, Triggers::Errors::StandardError.build(e)
            end
          RUBY
        in ['after_create', *] | ['after_save', *] | ['after_destroy', *]
          <<~RUBY
            #{action}_commit :#{method_name}
            def #{method_name}
              #{method_body}
              save
            rescue StandardError => e
              raise Triggers::Errors::StandardError, Triggers::Errors::StandardError.build(e)
            end
          RUBY
        in [*, nil]
          <<~RUBY
            def #{action}; end
          RUBY
        else
          <<~RUBY
            def #{action}
              #{method_body}
              save
            rescue StandardError => e
              raise Triggers::Errors::StandardError, Triggers::Errors::StandardError.build(e)
            end
          RUBY
        end
      end

      private

      def method_body
        return unless callback

        Tokens::Tokenizer
          .tokenize(callback)
          .map(&:value)
          .join
      end

      def spec_interpolations = super.merge(
        callback:,
        action: translate(
          action,
          scope: %i[activemodel attributes schematics/triggers/trigger actions],
          default: action.delete_suffix('_event')
        )
      )
    end
  end
end
