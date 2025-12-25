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

module Schematics
  module SortLink
    class Component < ApplicationComponent
      delegate :name, to: :field
      option :field
      option :model_class

      def attribute_name
        model_class.human_attribute_name(name)
      end

      def icon
        return :sort_down if asc?
        return :sort_up   if desc?

        field.icon
      end

      def icon_text_class
        return :danger  if asc?
        return :success if desc?

        :secondary
      end

      def link_params = request
        .query_parameters
        .merge(sort: new_sorted_params)

      private

      def asc?
        sorted_params&.include?(name)
      end

      def sorted_params
        params.extract_value(:sort, delimiter: ',')
      end

      def desc?
        sorted_params&.include?("-#{name}")
      end

      def new_sorted_params
        return name unless sorted_params

        new_params = revert_sorted_params
        new_params << name if new_param?
        new_params.join(',')
      end

      def revert_sorted_params
        sorted_params.map do |sorted_param|
          next "-#{name}" if sorted_param == name
          next name if sorted_param == "-#{name}"

          sorted_param
        end
      end

      def new_param?
        !asc? && !desc?
      end
    end
  end
end
