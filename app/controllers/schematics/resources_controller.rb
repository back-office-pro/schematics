module Schematics
  class ResourcesController < ApplicationController
    include Fillable
    include Sortable
    include Filterable
    include Searchable
    include Readable
    before_action :authorize
    before_action :set_resource, only: %i[show edit delete update destroy archive restore]
    before_action :set_paper_trail_whodunnit
    before_action :set_breadcrumb
    before_action :update_timestamp_field?, only: :show
    authorize_resource
    after_action { pagy_headers_merge(@pagy) if @pagy }
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from CanCan::AccessDenied, with: :forbidden
    delegate :model_class, to: :class
    delegate :entity, :model_name, to: :model_class
    helper_method :entity, :model_class, :resource
    attr_reader :resource

    class << self
      def model_class
        controller_name.classify.constantize
      end

      def controller_path
        'schematics/resources'
      end
    end

    def index
      page = params.fetch(:page, 1)
      per_page = params.fetch(:per_page, 25)
      @resources = model_class.search(**search_params.merge(page: page, per_page: per_page))
      @pagy = Pagy.new_from_searchkick(@resources)
      respond_to do |format|
        format.html
        format.json { render json: @resources }
        format.csv  { render csv:  @resources }
        format.xls  { render xls:  @resources }
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: @resource }
        format.pdf do
          render pdf: "#{model_name.human.downcase.dasherize}-#{@resource.slug}",
                 disposition: 'attachment',
                 template: 'schematics/application/show',
                 layout: 'layouts/schematics/pdf',
                 header: {
                   font_size: 8,
                   center: @resource,
                   right: '[page] / [topage]',
                 },
                 footer: {
                   font_size: 8,
                   left: helpers.setting(:company_name),
                   center: helpers.setting(:company_address),
                   right: helpers.setting(:company_registration_number),
                 }
        end
      end
    end

    def new
      @resource = model_class.new
    end

    def edit; end

    def delete; end

    def import; end

    def bulk_insert
      file = params.require(:import).permit(:file)
      result = Resources::BulkInsert.call(file: file, model_class: model_class)
      @errors = result.errors
      if result.success?
        respond_to do |format|
          format.html do
            notice = t(result.message, model_name_plural: model_name.human.pluralize.downcase)
            redirect_to polymorphic_path(model_class), notice: notice
          end
          format.json { head :created }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :import
          end
          format.json { render json: @errors, status: :unprocessable_entity }
        end
      end
    end

    def create
      @resource = model_class.new(resource_params)
      result = Resources::Create.call(resource: @resource)
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to @resource, notice: t(result.message, model_name: model_name.human)
          end
          format.json { head :created }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :new
          end
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      result = Resources::Update.call(resource: @resource, resource_params: resource_params)
      if result.success?
        respond_to do |format|
          format.html do
            redirect_to @resource, notice: t(result.message, model_name: model_name.human)
          end
          format.json { respond_with_bip(@resource) }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
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
          notice = t(result.message, model_name: model_name.human)
          format.html { redirect_to polymorphic_path(model_class), notice: notice }
          format.json
        end
      else
        respond_to do |format|
          format.html { redirect_to polymorphic_path(model_class), alert: t(result.message) }
          format.json { render json: t(result.message), status: :server_error }
        end
      end
    end

    def archive
      result = Resources::Archive.call(resource: @resource)
      if result.success?
        respond_to do |format|
          notice = t(result.message, model_name: model_name.human)
          format.html { redirect_to polymorphic_path(model_class), notice: notice }
          format.json
        end
      else
        respond_to do |format|
          format.html { redirect_to polymorphic_path(model_class), alert: t(result.message) }
          format.json { render json: t(result.message), status: :server_error }
        end
      end
    end

    def restore
      result = Resources::Restore.call(resource: @resource)
      if result.success?
        respond_to do |format|
          notice = t(result.message, model_name: model_name.human)
          format.html { redirect_to polymorphic_path(model_class), notice: notice }
          format.json
        end
      else
        respond_to do |format|
          format.html { redirect_to polymorphic_path(model_class), alert: t(result.message) }
          format.json { render json: t(result.message), status: :server_error }
        end
      end
    end

    def autocomplete
      field = params[:field].to_sym
      @resources = model_class.search(**search_params.merge(load: false, select: field))
      render json: @resources.map(&field).uniq
    end

    def parameter_missing(exception)
      respond_to do |format|
        format.json do
          render json: { errors: [{ exception.param => ['parameter is required'] }] },
                 status: :unprocessable_entity
        end
      end
    end

    def not_found
      self.action_name = :not_found
      respond_to do |format|
        format.html do
          redirect_to polymorphic_path(model_class),
                      alert: t('.alert', model_name: model_name.human)
        end
        format.json { head :not_found }
      end
    end

    def forbidden
      self.action_name = :forbidden
      respond_to do |format|
        format.html { redirect_to schematics.root_path, alert: t('.alert') }
        format.json { head :forbidden }
      end
    end

    def view_assigns
      super.merge(
        model_name_plural: model_name.human.pluralize.downcase,
        model_name: model_name.human.downcase
      )
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
      model_name_plural = model_name.human.pluralize.downcase
      title = t('titles.schematics.resources.index', model_name_plural: model_name_plural)
      breadcrumb title, :"#{entity.name.pluralize}_path"
    end
  end
end
