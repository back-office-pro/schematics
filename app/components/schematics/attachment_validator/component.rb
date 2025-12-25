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
  module AttachmentValidator
    class Component < ApplicationComponent
      with_collection_parameter :validator

      def initialize(validator:)
        super
        @validator = validator
      end

      def css_classes = class_names('text-danger': antivirus_missing?)

      def title
        return t('.antivirus_missing') if antivirus_missing?

        @validator
      end

      def icon
        return :triangle_exclamation if antivirus_missing?

        :info_circle
      end

      private

      def antivirus?
        @validator == Validators.human_attribute_name('antivirus')
      end

      memoize def antivirus_missing?
        antivirus? && !Clamby::Command.new.run(Clamby::Command.scan_executable, '--ping 0')
      end
    end
  end
end
