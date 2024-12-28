# frozen_string_literal: true

require 'active_support/core_ext/array/access'
require 'active_support/core_ext/string/indent'

module Schematics
  module Entities
    class Router # rubocop:disable Metrics/ClassLength
      delegate :name,
               :class_name,
               :actions,
               :events,
               :can?,
               to: :@entity,
               private: true

      def initialize(entity)
        @entity = entity
      end

      def to_str = [
        namespace_nesting(resource_routes_definition),
        scope_nesting(nested_resource_routes_definition),
        resolver
      ].compact.join

      private

      def namespace_nesting(source)
        namespaces.reduce(source) do |code, namespace|
          <<~RUBY
            namespace :#{namespace} do
            #{code.indent(2).chomp}
            end
          RUBY
        end
      end

      def namespaces = name
        .split('/')
        .tap(&:pop)
        .reverse

      def resource_routes_definition
        <<~RUBY
          #{route_method} :#{resource}, only: #{routes}, model_name: '#{class_name}' do
          #{resource_routes.indent(2).chomp}
          end
        RUBY
      end

      def route_method
        return :resource if singleton?

        :resources
      end

      def singleton?
        @entity in Singleton
      end

      def resource = name
        .split('/')
        .last
        .then_tap { it.pluralize unless singleton? }

      def routes = actions
        .excluding(:archive)
        .tap { it.push(:new) if can?(:create) }
        .tap { it.push(:edit) if can?(:update) }

      def resource_routes = [
        delete_route,
        archive_routes,
        duplicate_route,
        events.map(&method(:event_route))
      ].compact.join

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

      def duplicate_route
        return unless can?(:create)

        <<~RUBY
          post :duplicate, on: :member
        RUBY
      end

      def scope_nesting(source)
        namespaces.reduce(source) do |code, namespace|
          <<~RUBY
            scope path: :#{namespace}, as: :#{namespace} do
            #{code.indent(2).chomp}
            end
          RUBY
        end
      end

      def nested_resource_routes_definition
        <<~RUBY
          #{route_method} :#{resource}, only: [], model_name: '#{class_name}' do
          #{nested_resource_routes.indent(2).chomp}
          end
        RUBY
      end

      def nested_resource_routes = [
        import_routes,
        comparison_routes,
        bulk_actions_routes,
        autocompletions_routes,
        comment_routes,
        emailing_routes
      ].compact.join

      def import_routes
        return unless can?(:create)

        <<~RUBY
          collection do
            resources :imports, only: %i[new create], as: '#{route_alias}_imports'
          end
        RUBY
      end

      def route_alias = class_name
        .demodulize
        .underscore

      def comparison_routes
        return unless can?(:index)

        <<~RUBY
          collection do
            resources :comparisons, only: :create, as: '#{route_alias}_comparisons'
          end
        RUBY
      end

      def bulk_actions_routes
        return unless can?(:archive)

        <<~RUBY
          collection do
            resources :bulk_actions, only: :create, controller: 'schematics/bulk_actions', as: '#{route_alias}_bulk_actions'
          end
        RUBY
      end

      def autocompletions_routes
        return unless can?(:index)

        <<~RUBY
          collection do
            resources :autocompletions, only: :create, controller: 'schematics/autocompletions', as: '#{route_alias}_autocompletions'
          end
        RUBY
      end

      def comment_routes
        return unless can?(:show)

        <<~RUBY
          resources :comments, only: %i[new create]
        RUBY
      end

      def emailing_routes
        return unless can?(:show)

        <<~RUBY
          resources :emailings, only: %i[new create]
        RUBY
      end

      def resolver
        return unless singleton?

        <<~RUBY
          resolve '#{class_name}' do |resource, options|
            [:#{resource}, options]
          end
        RUBY
      end

      def event_route(event)
        <<~RUBY
          patch '#{event.state_machine_name}/#{event.name}', action: :trigger, event: '#{event.suffixed_name}', on: :member
        RUBY
      end
    end
  end
end
