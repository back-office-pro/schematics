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
  module Attachment
    class Component < ApplicationComponent
      class << self
        def avatar(user:, width: 32, height: 32, size: :avatar, title: nil)
          new(
            attachment: user.avatar,
            width:,
            height:,
            replacement: { icon: :circle_user, size: },
            class: 'align-middle rounded-circle',
            title:
          )
        end

        # :reek:ControlParameter
        def company_logo(icon:)
          new(
            attachment: ::Configuration.with_attached_company_logo.company_logo,
            width: 300,
            height: 150,
            replacement: { icon: }
          )
        end
      end

      def initialize(attachment:, width: 300, height: 300, replacement: {}, **kwargs)
        super
        @attachment = attachment
        @width = width
        @height = height
        @replacement = replacement
        @kwargs = kwargs
      end

      def attachment
        @attachment.representation(resize_to_fit: [@width, @height])
      end

      def data = { controller: 'attachment tooltip' }

      def icon
        @replacement.fetch(:icon, :triangle_exclamation)
      end

      def size
        @replacement.fetch(:size, '7x')
      end
    end
  end
end
