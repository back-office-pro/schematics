# frozen_string_literal: true

module Schematics
  class ResourcesController < ApplicationController # rubocop:disable Metrics/ClassLength
    include Fillable
    include Sortable
    include Filterable
    include Searchable
    include Readable
    include Calendarable
    include Documentable

    before_action :set_resource, except: %i[index new create autocomplete]
    before_action :set_breadcrumb
    before_action :read!, only: :show
    before_action :log_search!, only: :index

    authorize_resource instance_name: :resource, except: :autocomplete

    delegate :model_class, to: :class
    delegate :entity, :human_name, :human_name_plural, :gender, to: :model_class

    helper_method :entity, :model_class

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
      if params[:all_pages].present?
        @resources = model_class.search(**search_params)
      else
        @calendar, @pagy, @resources = pagy_calendar(
          model_class.pagy_search(**search_params),
          month: { format: '%B %Y' },
          pagy: { backend: :pagy_searchkick },
          active: entity.viewer == :calendar
        )
      end
      respond_to do |format|
        format.html
        format.json { render json: @resources }
        format.csv do
          result = Resources::GenerateFileInBackground.call(
            fingerprint: params[:fingerprint],
            job: GenerateCsvJob,
            job_params: [model_class.to_s, @resources.pluck(:id), current_user.preferences], # rubocop:disable Rails/PluckId
            extension: 'csv',
            slug: human_name_plural.dasherize
          )
          return send_data result.data if result.failure?

          send_file result.filepath, type: ::Mime[:csv].to_s, filename: result.filename
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
            job_params: [model_class.to_s, @resource.id],
            extension: 'pdf',
            slug: "#{human_name.dasherize}-#{@resource.slug}"
          )
          return send_data result.data if result.failure?

          send_file result.filepath, type: ::Mime[:csv].to_s, filename: result.filename
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
            redirect_to @resource, notice: tscope(result.message)
          end
          format.json { render json: @resource, status: :created, location: @resource }
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

    def duplicate
      @resource = @resource.dup
      result = Resources::Duplicate.call(resource: @resource)
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to @resource, notice: tscope(result.message)
          end
          format.json { render json: @resource, status: :created, location: @resource }
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
            redirect_to @resource, notice: tscope(result.message)
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

    def trigger
      event = entity.find_event_by_name(params.require(:event))
      result = Resources::Trigger.call(resource: @resource, event:)
      if result.success?
        respond_to do |format|
          format.html do
            notice = tscope(result.message, event: event.human.downcase)
            redirect_back(fallback_location: @resource, notice:)
          end
          format.json
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = tscope(result.message)
            render :show
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
            redirect_to polymorphic_path(model_class), notice: tscope(result.message)
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
            redirect_to polymorphic_path(model_class), notice: tscope(result.message)
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
            redirect_to polymorphic_path(model_class), notice: tscope(result.message)
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
      authorize! :index, model_class
      field = params.require(:field).to_sym
      @resources = model_class.search(**search_params.merge(select: field, load: false))
      render json: @resources.limit(5).map(&field).map(&:to_s).uniq
    end

    def view_assigns
      super.merge(human_name_plural:, human_name:, gender:)
    end

    protected

    def set_resource
      @resource = model_class
                  .includes(entity.includes)
                  .includes(:slugs)
                  .yield_self { request.delete? ? _1.with_deleted : _1 }
                  .finder(params[:id])
      return if request.path.start_with?(polymorphic_path(@resource))

      redirect_to @resource, status: :moved_permanently
    end

    def set_breadcrumb
      return unless can?(:index, model_class)

      breadcrumb t('titles.schematics.resources.index', human_name_plural:),
                 polymorphic_path(model_class)
    end

    def tscope(message, **kwargs)
      translate(
        message[1..],
        scope: [:schematics, :resources, action_name],
        **kwargs.merge(human_name:, gender:)
      )
    end
  end
end
