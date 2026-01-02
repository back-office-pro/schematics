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
  module ResourceLinkTo
    class Component < ApplicationComponent
      renders_one :body
      option :resource

      def data = { turbo_frame: '_top' }

      def css_classes = %w[text-decoration-none]

      def human_name_with_icon
        fa_icon(icon, class: icon_css_classes) + human_name
      end

      def authorized?
        case resource
        when Class
          can?(ability, resource)
        when String
          can?(ability, resource.safe_constantize)
        else
          can?(ability, resource) && !resource.deleted?
        end
      end

      def path
        case resource
        when Class
          resources_path(resource)
        when String
          resources_path(resource.safe_constantize)
        else
          resource_path(resource)
        end
      end

      def render?
        resource.present?
      end

      protected

      def icon
        case resource
        when Class
          resource.entity.icon
        when String
          resource.safe_constantize&.entity&.icon || :question
        else
          resource.class.entity.icon
        end
      end

      def icon_css_classes = [
        'text-primary',
        "me-#{margin_size}"
      ]

      def margin_size = 2

      def human_name
        case resource
        when Class
          resource.model_name.human
        when String
          resource.safe_constantize&.model_name&.human || resource
        else
          resource.to_s
        end
      end

      def ability
        case resource
        when Class, String
          :index
        else
          :show
        end
      end
    end
  end
end
