# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Entities
    class Receptor
      REGEX = /(non_)?([a-zA-Z_]+)_(attributes|virtuals|associations|fields|elements)/

      delegate :public_send, :id_attribute, :created_at_attribute, to: :@entity, private: true

      def initialize(entity)
        @entity = entity
      end

      def method_missing(method_name, *, &) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        predicate, constant, mod = parse_method_name(method_name)
        with_id_and_created_at_attrs = mod != :Associations && constant != :Migratable
        return super unless mod || constant

        elements = public_send(mod.to_s.underscore)
        if Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)
          elements.public_send(predicate, Schematics.const_get(mod).const_get(constant))
        elsif Behaviours.const_defined?(constant)
          elements = [id_attribute, *elements, created_at_attribute] if with_id_and_created_at_attrs
          elements = elements.public_send(predicate, Behaviours.const_get(constant))
          case constant
          when :Migratable, :Validatable
            elements
          when :Fillable
            elements
              .reject(&:hidden?)
              .reject(&:readonly?)
          else
            elements.reject(&:hidden?)
          end
        end
      end

      def receptor_respond_to_missing?(method_name, *)
        _predicate, constant, mod = parse_method_name(method_name)
        return false unless mod || constant

        (Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)) ||
          Behaviours.const_defined?(constant)
      end

      def respond_to_missing? = receptor_respond_to_missing?

      private

      def parse_method_name(method_name)
        method_name
          .to_s
          .scan(REGEX)
          .flat_map do |(non, constant, mod)|
            [non ? :grep_v : :grep, constant&.camelize&.to_sym, mod&.camelize&.to_sym]
          end
      end
    end
  end
end
