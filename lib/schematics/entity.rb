module Schematics
  class Entity
    attr_accessor :type, :attributes, :virtuals, :has_one_associations, 
      :has_many_associations, :has_many_through_associations, :has_one_through_associations

    def initialize(type, descriptor, attributes, virtuals)
      @type = type
      @descriptor = descriptor
      @attributes = attributes.map { |attribute| Attributes::Factory.create(self, attribute) }
      @virtuals = virtuals.map { |virtual| Virtuals::Factory.create(self, virtual) }
      @has_one_associations = []
      @has_many_associations = []
      @has_many_through_associations = []
      @has_one_through_associations = []
    end

    def descriptor
      (@attributes + @virtuals).find { |param| param.name === @descriptor }
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

    def scopes
      (@attributes + @virtuals + @has_one_associations + @has_one_through_associations).map(&:scope).compact
    end

    def has_scopes
      (@attributes + @virtuals + @has_one_associations + @has_one_through_associations).map(&:has_scope).compact
    end

    def validates
      @attributes.map(&:validate).compact
    end

    def associations
      @has_one_associations + @has_many_associations + @has_many_through_associations + @has_one_through_associations
    end

    def modelize(subclass)
      subclass.class_eval(friendly_id)
      (@attributes + associations + scopes + validates + virtuals).each { |modelizable| subclass.class_eval(modelizable) }
    end
    
    def controllerize(subclass)
      subclass.class_eval(api)
      has_scopes.each { |controllerizable| subclass.class_eval(controllerizable) }
    end

    def friendly_id
      %Q[friendly_id :#{descriptor.name}, use: [:slugged, :finders]]
    end

    def api
      <<-RUBY
        swagger_controller :#{@type.pluralize}, "#{@type.camelize} Management"

        swagger_model :#{@type.camelize} do |model|
          description "A #{@type.camelize} object"
          #{model_properties.join("\n\t")}
        end

        swagger_api :index do
          summary "Fetches all #{@type.humanize.downcase} items"
          notes "This lists all the #{@type.pluralize.humanize.downcase}"
          param :header, "Authentication-Token", :string, :required, "Authentication token"
          param :query, :page, :integer, :optional, "Page number"
          response :unauthorized
          response :success
          type :#{@type.camelize}
        end

        swagger_api :show do
          summary "Fetches a single #{@type.humanize.downcase} item"
          notes "This returns a single #{@type.humanize.downcase}"
          param :header, "Authentication-Token", :string, :required, "Authentication token"
          param :path, :id, :integer, :required, "#{@type.humanize} Id"
          response :unauthorized
          response :success
          response :not_found
          type :#{@type.camelize}
        end

        swagger_api :create do |api|
          summary "Creates a new #{@type.humanize.downcase}"
          notes "This creates a new #{@type.humanize.downcase}"
          param :header, "Authentication-Token", :string, :required, "Authentication token"
          #{api_params.join("\n\t")}
          response :unauthorized
          response :success
          response :unprocessable_entity
        end
        
        swagger_api :update do |api|
          summary "Updates an existing #{@type.humanize.downcase}"
          notes "This updates an existing #{@type.humanize.downcase}"
          param :header, "Authentication-Token", :string, :required, "Authentication token"
          param :path, :id, :integer, :required, "#{@type.humanize} Id"
          #{api_params.join("\n\t")}
          response :unauthorized
          response :success
          response :unprocessable_entity
          response :not_found
        end

        swagger_api :destroy do
          summary "Deletes an existing #{@type.humanize.downcase} item"
          notes "This deletes an existing #{@type.humanize.downcase}"
          param :header, "Authentication-Token", :string, :required, "Authentication token"
          param :path, :id, :integer, :required, "#{@type.humanize} Id"
          param :query, :really, :boolean, :optional, "Really destroy #{@type.humanize.downcase} item (without soft delete)"
          response :unauthorized
          response :success
          response :not_found
        end
      RUBY
    end

    def self.create(type, descriptor: nil, attributes: nil, virtuals: nil)
      Entity.new(type.to_s, descriptor, attributes || [], virtuals || [])
    end
  end
end
