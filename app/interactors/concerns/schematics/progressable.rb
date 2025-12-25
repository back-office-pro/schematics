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
  module Progressable
    extend ActiveSupport::Concern

    included do
      include Interactor

      after :update_progress!
    end

    class_methods do
      # :reek:Attribute
      attr_accessor :resource_name, :progress

      def progressable(options)
        self.resource_name, self.progress = options.first
      end
    end

    def update_progress!(progress = self.class.progress)
      resource.reload.update!(progress:) if resource&.persisted?
    end

    private

    def resource
      context.public_send(self.class.resource_name)
    end
  end
end
