# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Core
  module Imports
    class ValidateData
      include Schematics::Progressable

      delegate :import, :data, :fail!, to: :context, private: true
      delegate :model_class, to: :import, private: true

      progressable import: 90

      before { @errors = Concurrent::Hash.new }

      # :reek:UncommunicativeVariableName
      def call
        context.data = data.flat_map do |line, attributes|
          resource = model_class.new(attributes)
          resource.validate!
          resource
            .attributes
            .symbolize_keys
            .compact
        rescue StandardError => e
          @errors[line] = e
        ensure
          update_progress!(line.to_f / data.size * self.class.progress)
        end
        fail!(errors: @errors) if @errors.any?
      end
    end
  end
end
