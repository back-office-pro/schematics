# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Entities
    class Router
      delegate :name, :class_name, :actions, :can?, to: :@entity

      def initialize(entity)
        @entity = entity
      end

      def to_str
        return route unless namespace

        <<~RUBY
          namespace :#{namespace} do
            #{route}
          end
        RUBY
      end

      private

      def routes
        actions - %i[archive import]
      end

      def resource
        name.split('/').last
      end

      def namespace
        name.split('/').reverse[1]
      end

      def route
        case @entity
        when Singleton
          <<~RUBY
            resource :#{resource.pluralize}, only: #{routes}
            resolve("#{class_name}") { [:#{resource.pluralize}] }
          RUBY
        when Entity
          <<~RUBY
            resources :#{resource.pluralize}, only: #{routes}, model_name: '#{class_name}' do
            #{resource_routes}
            end
          RUBY
        end
      end

      def resource_routes
        [delete_route, archive_routes, autocomplete_route, events_routes, import_routes]
          .compact
          .join
          .indent(2)
          .chomp
      end

      def delete_route
        return unless can?(:destroy)

        <<~RUBY
          get :delete, on: :member
        RUBY
      end

      def archive_routes
        return unless can?(:archive)

        <<~RUBY
          delete :archive, on: :member
          delete :restore, on: :member
        RUBY
      end

      def autocomplete_route
        return unless can?(:index)

        <<~RUBY
          get :autocomplete, on: :collection
        RUBY
      end

      def events_routes
        return unless can?(:update)

        @entity.events.map do |event|
          <<~RUBY
            patch :#{event.name}, action: :trigger, event: '#{event.name}', on: :member
          RUBY
        end
      end

      def import_routes
        return unless can?(:import)

        <<~RUBY
          collection do
            resources :imports, only: %i[new create], as: '#{resource}_imports', format: false do
              get :template, on: :collection, format: :csv
            end
          end
        RUBY
      end
    end
  end
end
