module Schematics
  module Entities
    class Entity
      attr_reader :type,
                  :icon,
                  :descriptor,
                  :attributes,
                  :virtuals,
                  :associations

      MISSING_REGEX = /([a-zA-Z_]+)_([attributes|virtuals|associations|fields|elements]+)/.freeze

      class << self
        def create(type:,
                   icon: :caret_square_right,
                   descriptor: 'id',
                   singleton: false,
                   attributes: [],
                   virtuals: [])
          klass = singleton ? Singleton : self
          klass.new(type, icon.to_sym, descriptor, attributes, virtuals)
        end
      end

      def initialize(type, icon, descriptor, attributes, virtuals)
        @type = type
        @icon = icon
        @attributes = attributes.map { |attribute| Attributes::Attribute.create(self, attribute) }
        @virtuals = virtuals.map { |virtual| Virtuals::Virtual.create(self, virtual) }
        @descriptor = Descriptor.create(self, descriptor)
        @associations = []
      end

      def method_missing(method_name, *args, &block)
        constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        if Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)
          send(method.to_sym).select_is_a?(Schematics.const_get(mod).const_get(constant))
        elsif Schematics::Behaviours.const_defined?(constant)
          send(method.to_sym).select_is_a?(Schematics::Behaviours.const_get(constant))
        else
          super
        end
      end

      def respond_to_missing?(method_name, *args)
        constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant) ||
        Schematics::Behaviours.const_defined?(constant) ||
        super
      end

      def find_field_by_name(name)
        # TODO
        # Check how we handle :id, :created_at, :deleted_at, :slug...
        return Attributes::Attribute.create(self, type: 'date', name: name) if name == 'created_at'
        return Attributes::Attribute.create(self, type: 'integer', name: name) if name == 'id'
        fields.find { |field| field.name == name }
      end

      def weight
        has_many_and_through_associations.size
      end

      def generate
        "rails generate scaffold #{@type} #{@attributes.map(&:to_s).join(' ')}"
      end

      def fields
        @attributes + @virtuals
      end

      def elements
        fields + associations
      end

      def model_properties
        fillable_attributes.map(&:model_property)
      end

      def api_params
        fillable_attributes.map(&:api_param)
      end

      def permitted_params
        fillable_attributes.map(&:permitted_param).flatten.compact
      end

      def permitted_json_params
        fillable_attributes.map(&:permitted_json_param).flatten.compact
      end

      def eager_loading
        preloadable_elements.map(&:joins)
      end

      def filter_scopes
        filterable_elements.map(&:filter_scope)
      end

      def sort_scopes
        sortable_elements.map(&:sort_scope)
      end

      def has_filter_scopes
        filterable_elements.map(&:has_filter_scope)
      end

      def has_sort_scopes
        sortable_elements.map(&:has_sort_scope)
      end

      def validates
        @attributes.map(&:validate).compact
      end

      def has_one_and_through_associations
        has_one_associations + has_one_through_associations
      end

      def has_many_and_through_associations
        has_many_associations + has_many_through_associations
      end

      def class_name
        @type.camelize
      end

      def model_elements
        (elements + filter_scopes + sort_scopes + validates) << descriptor
      end

      def controller_elements
        (has_filter_scopes + has_sort_scopes) << api
      end

      def api
        <<~RUBY
          swagger_controller :#{@type.pluralize}, "#{class_name} Management"

          swagger_model :#{class_name} do |model|
            description "A #{class_name} object"
            #{model_properties.map(&:squish).join("\n\s\s")}
          end

          swagger_api :index do
            summary "Fetches all #{@type.humanize.downcase} items"
            notes "This lists all the #{@type.pluralize.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            param :query, :page, :integer, :optional, "Page number"
            response :unauthorized
            response :success
            type :#{class_name}
          end

          swagger_api :show do
            summary "Fetches a single #{@type.humanize.downcase} item"
            notes "This returns a single #{@type.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            param :path, :id, :integer, :required, "#{@type.humanize} Id"
            response :unauthorized
            response :success
            response :not_found
            type :#{class_name}
          end

          swagger_api :create do |api|
            summary "Creates a new #{@type.humanize.downcase}"
            notes "This creates a new #{@type.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            #{api_params.map(&:squish).join("\n\s\s")}
            response :unauthorized
            response :success
            response :unprocessable_entity
          end

          swagger_api :update do |api|
            summary "Updates an existing #{@type.humanize.downcase}"
            notes "This updates an existing #{@type.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            param :path, :id, :integer, :required, "#{@type.humanize} Id"
            #{api_params.map(&:squish).join("\n\s\s")}
            response :unauthorized
            response :success
            response :unprocessable_entity
            response :not_found
          end

          swagger_api :destroy do
            summary "Deletes an existing #{@type.humanize.downcase} item"
            notes "This deletes an existing #{@type.humanize.downcase}"
            param :header, "Authorization", :string, :required, "Authorization token"
            param :path, :id, :integer, :required, "#{@type.humanize} Id"
            param :query, :really, :boolean, :optional, "Really destroy #{@type.humanize.downcase} item (without soft delete)"
            response :unauthorized
            response :success
            response :not_found
          end
        RUBY
      end

      def to_s
        <<~RUBY
          class #{class_name}
            ###
            #{attributes.map { |attribute| '# ' + attribute.to_s }.join("\n\s\s")}
            ###

            #{descriptor.to_str}
            #{validates.join("\s\s")}
            #{filter_scopes.join("\s\s")}
            #{sort_scopes.join("\s\s")}
            #{attributes.map(&:to_str).join("\s\s")}
            #{associations.map(&:to_str).join("\s\s")}
            #{virtuals.map(&:to_str).join("\s\s")}
          end

          class #{class_name}Controller
            ###
            # #{permitted_params.join(", ")}
            # #{permitted_json_params.join(", ")}
            ###

            #{has_filter_scopes.join("\s\s")}
            #{has_sort_scopes.join("\s\s")}
            #{api}
          end
        RUBY
      end
    end
  end
end
