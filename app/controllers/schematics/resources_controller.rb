# frozen_string_literal: true

module Schematics
  class ResourcesController < ApiController
    include Fillable
    include Sortable
    include Filterable
    include Searchable
    include Readable
    include Calendarable

    before_action :set_resource, only: %i[show edit delete update destroy archive restore]
    before_action :set_breadcrumb
    before_action :update_timestamp_field?, only: :show

    authorize_resource

    delegate :model_class, to: :class
    delegate :entity, :model_name, to: :model_class

    helper_method :entity, :model_class, :resource

    attr_reader :resource

    class << self
      alias original_controller_path controller_path

      def model_class
        original_controller_path.classify.constantize
      end

      def controller_path
        'schematics/resources'
      end
    end

    def index
      @calendar, @pagy, @resources = pagy_calendar(
        model_class.pagy_search(**search_params),
        month: { format: '%B %Y' },
        pagy: { backend: :pagy_searchkick },
        active: entity.viewer == :calendar
      )
      respond_to do |format|
        format.html
        format.json { render json: @resources }
        format.csv do
          result = Resources::GenerateFileInBackground.call(
            fingerprint: params[:fingerprint],
            job: GenerateCsvJob,
            job_params: [model_name.to_s, @resources.pluck(:id)],
            extension: 'csv',
            slug: model_name_plural.dasherize
          )
          return send_data result.data if result.failure?

          send_file result.filepath, type: 'text/csv', filename: result.filename
        end
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: @resource }
        format.pdf do
          result = Resources::GenerateFileInBackground.call(
            fingerprint: params[:fingerprint],
            job: GeneratePdfJob,
            job_params: [model_name.to_s, @resource.id],
            extension: 'pdf',
            slug: "#{model_name.human.downcase.dasherize}-#{@resource.slug}"
          )
          return send_data result.data if result.failure?

          send_file result.filepath, type: 'text/csv', filename: result.filename
        end
      end
    end

    def new
      @resource = model_class.new
    end

    def edit; end

    def delete; end

    def create
      @resource = model_class.new(resource_params)
      result = Resources::Create.call(resource: @resource)
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to @resource, notice: tscope(result.message, model_name: model_name.human)
          end
          format.json { head :created }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = tscope(result.message)
            render :new
          end
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      result = Resources::UpdateAndCache.call(resource: @resource, resource_params:)
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to @resource, notice: tscope(result.message, model_name: model_name.human)
          end
          format.json { respond_with_bip(@resource) }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = tscope(result.message)
            render :edit
          end
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      result = Resources::Destroy.call(resource: @resource)
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to polymorphic_path(model_class),
                        notice: tscope(result.message, model_name: model_name.human)
          end
          format.json
        end
      else
        respond_to do |format|
          format.html { redirect_to polymorphic_path(model_class), alert: tscope(result.message) }
          format.json { render json: tscope(result.message), status: :server_error }
        end
      end
    end

    def archive
      result = Resources::Archive.call(resource: @resource)
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to polymorphic_path(model_class),
                        notice: tscope(result.message, model_name: model_name.human)
          end
          format.json
        end
      else
        respond_to do |format|
          format.html { redirect_to polymorphic_path(model_class), alert: tscope(result.message) }
          format.json { render json: tscope(result.message), status: :server_error }
        end
      end
    end

    def restore
      result = Resources::Restore.call(resource: @resource)
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to polymorphic_path(model_class),
                        notice: tscope(result.message, model_name: model_name.human)
          end
          format.json
        end
      else
        respond_to do |format|
          format.html { redirect_to polymorphic_path(model_class), alert: tscope(result.message) }
          format.json { render json: tscope(result.message), status: :server_error }
        end
      end
    end

    def autocomplete
      field = params[:field].to_sym
      @resources = model_class.search(**search_params.merge(select: field, load: false))
      render json: @resources.map(&field).map(&:to_s).uniq
    end

    def view_assigns
      super.merge(model_name_plural:, model_name: model_name.human.downcase)
    end

    protected

    def set_resource
      @resource = model_class
                  .includes(entity.includes)
                  .includes(:slugs)
      @resource = @resource.with_deleted if request.delete?
      @resource = case entity
                  when Entities::Singleton
                    @resource.instance
                  when Entities::Entity
                    @resource.find(params[:id])
                  end
      return if request.path.start_with?(polymorphic_path(@resource))

      redirect_to @resource, status: :moved_permanently
    end

    def set_breadcrumb
      breadcrumb t('titles.schematics.resources.index', model_name_plural:),
                 polymorphic_path(model_class)
    end

    def model_name_plural
      model_name.human.pluralize.downcase
    end

    def tscope(message, **args)
      t(message[1..], scope: [:schematics, :resources, action_name], **args)
    end
  end
end
