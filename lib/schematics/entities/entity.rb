module Schematics
  module Entities
    class Entity
      attr_reader :name,
                  :icon,
                  :descriptor,
                  :attributes,
                  :virtuals,
                  :associations,
                  :generators

      MISSING_REGEX = /([a-zA-Z_]+)_([attributes|virtuals|associations|fields|elements]+)/.freeze

      class << self
        def create(name:,
                   type: nil,
                   icon: :caret_square_right,
                   descriptor: 'id',
                   singleton: false,
                   associations: [],
                   attributes: [],
                   virtuals: [])
          args = [name, icon.to_sym, descriptor, associations, attributes, virtuals]
          return new(*args) if type.nil?
          Entities.const_get(type.camelize.to_sym).new(*args)
        end
      end

      def initialize(name, icon, descriptor, associations, attributes, virtuals)
        @name = name
        @icon = icon
        @associations = associations.map do |association|
          Associations::Association.create(self, **association)
        end
        @attributes = attributes.map { |attribute| Attributes::Attribute.create(self, **attribute) }
        @virtuals = virtuals.map { |virtual| Virtuals::Virtual.create(self, **virtual) }
        @descriptor = Descriptor.create(self, descriptor)
        @generators = default_generators + @associations.flat_map(&:generator)
      end

      def method_missing(method_name, *args, &block)
        constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        if Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)
          send(method.to_sym).select_is_a?(Schematics.const_get(mod).const_get(constant))
        elsif Behaviours.const_defined?(constant)
          send(method.to_sym).select_is_a?(Behaviours.const_get(constant))
        else
          super
        end
      end

      def respond_to_missing?(method_name, *args)
        constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant) ||
        Behaviours.const_defined?(constant) ||
        super
      end

      def find_field_by_name(name)
        case name
        when 'created_at'
          Attributes::Attribute.create(self, type: 'date', name: name)
        when 'id'
          Attributes::Attribute.create(self, type: 'integer', name: name)
        else
          fields.find { |field| field.name == name }
        end
      end

      def weight
        has_many_and_through_and_belongs_to_many_associations.size
      end

      def fields
        @attributes + @virtuals
      end

      def elements
        fields + associations
      end

      def model_properties
        fillable_elements.map(&:model_property)
      end

      def api_params
        fillable_elements.map(&:api_param)
      end

      def permitted_params
        fillable_elements.flat_map(&:permitted_params)
      end

      def permitted_json_params
        fillable_elements.flat_map(&:permitted_json_params)
      end

      def includes
        preloadable_elements.flat_map(&:preload).compact.uniq
      end

      def validates
        @attributes.map(&:validate).compact
      end

      def has_many_and_through_and_belongs_to_many_associations
        has_many_associations + has_many_through_associations + has_and_belongs_to_many_associations
      end

      def class_name
        name.camelize
      end

      def load
        context = binding.of_caller(1).method(:eval)
        model_elements.each(&context)
      end

      def viewer
        return :calendar if datetime_attributes.size >= 2
        return :grid if attachment_attributes.any?(&:image?)
        :table
      end

      def search_data
        <<~RUBY
          def search_data
            {
              created_at: created_at,
              #{
                searchable_elements.map do |element|
                  "#{element.name}: #{element.search_data.squish}"
                end.join(', ')
              }
            }
          end
        RUBY
      end

      def route
        <<~RUBY
          resources :#{name.pluralize} do
            member do
              delete :archive
              delete :restore
            end
            collection do
              post :bulk_insert
              get :import
              get :autocomplete
            end
          end
        RUBY
      end

      def to_str
        <<~RUBY
          has_paper_trail ignore: [:id, :created_at, :updated_at, :deleted_at, :slug]
          acts_as_paranoid
          searchkick searchable: #{elasticsearchable_elements},
                     filterable: #{elasticsearchable_elements},
                     word_middle: #{elasticsearchable_elements},
                     suggest: #{elasticsearchable_elements},
                     callbacks: :async
        RUBY
      end

      def api
        <<~RUBY
          swagger_controller :#{name.pluralize}, "#{class_name} Management"

          swagger_model :#{class_name} do |model|
            description "A #{class_name} object"
            #{model_properties.map(&:squish).join("\n\s\s")}
          end

          swagger_api :index do
            summary "Fetches all #{name.humanize.downcase} items"
            notes "This lists all the #{name.pluralize.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            param :query, :page, :integer, :optional, "Page number"
            response :unauthorized
            response :forbidden
            response :success
            type :#{class_name}
          end

          swagger_api :show do
            summary "Fetches a single #{name.humanize.downcase} item"
            notes "This returns a single #{name.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            param :path, :id, :integer, :required, "#{name.humanize} Id"
            response :unauthorized
            response :forbidden
            response :success
            response :not_found
            type :#{class_name}
          end

          swagger_api :create do |api|
            summary "Creates a new #{name.humanize.downcase}"
            notes "This creates a new #{name.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            #{api_params.map(&:squish).join("\n\s\s")}
            response :unauthorized
            response :forbidden
            response :success
            response :unprocessable_entity
          end

          swagger_api :update do |api|
            summary "Updates an existing #{name.humanize.downcase}"
            notes "This updates an existing #{name.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            param :path, :id, :integer, :required, "#{name.humanize} Id"
            #{api_params.map(&:squish).join("\n\s\s")}
            response :unauthorized
            response :forbidden
            response :success
            response :unprocessable_entity
            response :not_found
          end

          swagger_api :destroy do
            summary "Deletes an existing #{name.humanize.downcase} item"
            notes "This deletes an existing #{name.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            param :path, :id, :integer, :required, "#{name.humanize} Id"
            response :unauthorized
            response :forbidden
            response :success
            response :not_found
          end
        RUBY
      end

      def to_s
        <<~RUBY
          class #{class_name}
            #{to_str}

            ###
            #{attributes.map { |attribute| '# ' + attribute.to_s }.join("\n\s\s")}
            # #{permitted_params.join(", ")}
            # #{permitted_json_params.join(", ")}
            ###

            #{descriptor.to_str}
            #{validates.join("\s\s")}
            #{search_data}
            #{attributes.map(&:to_str).join("\s\s")}
            #{associations.map(&:to_str).join("\s\s")}
            #{virtuals.map(&:to_str).join("\s\s")}
          end
        RUBY
      end

      protected

      def model_elements
        [self, descriptor, search_data] + elements + validates
      end

      def elasticsearchable_elements
        searchable_elements.map(&:name).map(&:to_sym)
      end

      def default_generators
        [
          "rails g scaffold #{name} #{attributes.map(&:to_s).join(' ')} --skip-resource-route",
          "rails g migration add_deleted_at_to_#{name.pluralize} deleted_at:datetime",
          "rails g migration add_slug_to_#{name.pluralize} slug:string:unique:true",
        ]
      end
    end
  end
end
