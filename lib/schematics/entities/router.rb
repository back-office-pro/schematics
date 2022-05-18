# frozen_string_literal: true

require 'active_support/core_ext/string/indent'
require 'active_support/core_ext/array/access'

module Schematics
  module Entities
    class Router
      delegate :name, :class_name, :actions, :events, :can?, to: :@entity

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
        actions
          .excluding(:archive)
          .tap { _1.push(:new) if can?(:create) }
          .tap { _1.push(:edit) if can?(:update) }
      end

      def resource = name
        .split('/')
        .last

      def namespace = name
        .split('/')
        .reverse[1]

      def route
        case @entity
        when Singleton # rubocop:disable Lint/ConstantResolution
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
        [
          delete_route,
          archive_routes,
          autocomplete_route,
          duplicate_route,
          events.map(&:to_route),
          import_routes
        ].compact.join.indent(2).chomp
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

      def duplicate_route
        return unless can?(:create)

        <<~RUBY
          post :duplicate, on: :member
        RUBY
      end

      def import_routes
        return unless can?(:create)

        <<~RUBY
          collection do
            resources :imports, only: %i[new create], as: '#{resource}_imports'
          end
        RUBY
      end
    end
  end
end
