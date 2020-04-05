module Schematics
  class Entity
    attr_accessor :type,
                  :icon,
                  :attributes,
                  :virtuals,
                  :has_one_associations,
                  :has_many_associations,
                  :has_many_through_associations,
                  :has_one_through_associations

    def initialize(type, icon, descriptor, attributes, virtuals)
      @type = type
      @icon = icon || :caret_square_right
      @descriptor = descriptor
      @attributes = attributes.map { |attribute| Attributes::Factory.create(self, attribute) }
      @virtuals = virtuals.map { |virtual| Virtuals::Factory.create(self, virtual) }
      @has_one_associations = []
      @has_many_associations = []
      @has_many_through_associations = []
      @has_one_through_associations = []
    end

    def find_field_by_name(name)
      (@attributes + @virtuals).find { |field| field.name === name }
    end

    def descriptor
      find_field_by_name(@descriptor)
    end

    def weight
      @has_many_associations.size + @has_many_through_associations.size
    end

    def generate
      system "rails generate scaffold #{@type} #{@attributes.map(&:to_s).join(' ')}"
    end

    def references
      @attributes.select_is_a?(Attributes::BelongsTo)
    end

    def model_properties
      @attributes.select(&:permitted_param).map(&:model_property)
    end

    def api_params
      @attributes.select(&:permitted_param).map(&:api_param)
    end

    def permitted_params
      @attributes.map(&:permitted_param).flatten.compact
    end

    def filter_scopes
      (@attributes + @virtuals + @has_one_associations + @has_one_through_associations).
        map(&:filter_scope).
        compact
    end

    def sort_scopes
      (@attributes + @virtuals + @has_one_associations + @has_one_through_associations).
        map(&:sort_scope).
        compact
    end

    def has_filter_scopes
      (@attributes + @virtuals + @has_one_associations + @has_one_through_associations).
        map(&:has_filter_scope).
        compact
    end

    def has_sort_scopes
      (@attributes + @virtuals + @has_one_associations + @has_one_through_associations).
        map(&:has_sort_scope).
        compact
    end

    def validates
      @attributes.map(&:validate).compact
    end

    def associations
      @has_one_associations +
      @has_many_associations +
      @has_many_through_associations +
      @has_one_through_associations
    end

    def modelize(subclass)
      subclass.class_eval(friendly_id)
      (@attributes + associations + filter_scopes + sort_scopes + validates + virtuals).
        each { |modelizable| subclass.class_eval(modelizable) }
    end

    def controllerize(subclass)
      subclass.class_eval(api)
      (has_filter_scopes + has_sort_scopes).
        each { |controllerizable| subclass.class_eval(controllerizable) }
    end

    def friendly_id
      <<~RUBY
        friendly_id :#{descriptor.name}, use: [:slugged, :finders]
      RUBY
    end

    def api
      <<~RUBY
        swagger_controller :#{@type.pluralize}, "#{@type.camelize} Management"

        swagger_model :#{@type.camelize} do |model|
          description "A #{@type.camelize} object"
          #{model_properties.map(&:squish).join("\n\s\s")}
        end

        swagger_api :index do
          summary "Fetches all #{@type.humanize.downcase} items"
          notes "This lists all the #{@type.pluralize.humanize.downcase}"
          param :header, "Authorization", :string, :required, "Authorization token"
          param :query, :page, :integer, :optional, "Page number"
          response :unauthorized
          response :success
          type :#{@type.camelize}
        end

        swagger_api :show do
          summary "Fetches a single #{@type.humanize.downcase} item"
          notes "This returns a single #{@type.humanize.downcase}"
          param :header, "Authorization", :string, :required, "Authorization token"
          param :path, :id, :integer, :required, "#{@type.humanize} Id"
          response :unauthorized
          response :success
          response :not_found
          type :#{@type.camelize}
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
        class #{type.camelize}
          ###
          #{attributes.map { |attribute| '# ' + attribute.to_s }.join("\n\s\s")}
          ###

          #{friendly_id}
          #{validates.join("\s\s")}
          #{filter_scopes.join("\s\s")}
          #{sort_scopes.join("\s\s")}
          #{attributes.map(&:to_str).compact.join("\s\s")}
          #{associations.map(&:to_str).join("\s\s")}
          #{virtuals.map(&:to_str).join("\s\s")}
        end

        class #{type.camelize}Controller
          ###
          # #{permitted_params.join(", ")}
          ###

          #{has_filter_scopes.join("\s\s")}
          #{has_sort_scopes.join("\s\s")}
          #{api}
        end
      RUBY
    end

    def self.create(type:, icon: nil, descriptor: nil, attributes: nil, virtuals: nil)
      new(type, icon&.to_sym, descriptor, attributes || [], virtuals || [])
    end
  end
end
