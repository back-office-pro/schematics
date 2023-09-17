# frozen_string_literal: true

module Schematics
  module Button
    module Help
      class Component < ApplicationComponent
        ALLOWLIST = [::Migration, ::Import, ::Stat, ::Chart, ::Configuration, ::Role].freeze

        delegate :domain, to: ::Tenant, private: true
        delegate :model_name, to: :model_class, allow_nil: true, private: true
        delegate :singular_route_key, to: :model_name, allow_nil: true, private: true
        delegate :icon, to: '::Documentation.entity'

        option :wrapper_css_classes, default: proc { 'btn btn-sm btn-icon-split' }
        option :text_css_classes, default: proc { 'd-none d-lg-inline' }
        option :icon_css_classes, optional: true
        option :model_class, optional: true

        class << self
          def dropdown_item = new(
            wrapper_css_classes: 'dropdown-item',
            icon_css_classes: 'fa-fw me-3',
            text_css_classes: ''
          )
        end

        def url = ::URI::HTTPS
          .build(host: "www.#{domain}", path:)
          .to_s

        def render?
          !model_class || ALLOWLIST.include?(model_class)
        end

        private

        def path = File.join(['/docs', singular_route_key].compact)
      end
    end
  end
end
