module Schematics
  class ResourcesController < ApplicationController
    include Schematics::Sortable
    include Schematics::Filterable
    include Schematics::Fillable
    before_action :set_paper_trail_whodunnit
    before_action :authorize
    before_action :set_breadcrumb
    before_action :set_resource, only: [:show, :edit, :update, :destroy]
    after_action { pagy_headers_merge(@pagy) if @pagy }
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    delegate :model_class, to: :class
    delegate :entity, :model_name, to: :model_class
    helper_method :entity, :model_class

    class << self
      delegate :entity, :model_name, to: :model_class
      Swagger::Docs::Generator.set_real_methods

      def inherited(subclass)
        super
        subclass.class_eval do
          class_eval(entity.api)
        end
      end

      def model_class
        controller_name.classify.constantize
      end

      def controller_path
        "schematics/resources"
      end
    end

    def index
      @resources = model_class.search(
        includes: entity.includes,
        where: filter_params.except(:with_deleted),
        order: sorting_params,
        page: params.fetch(:page, 1),
        per_page: params.fetch(:per_page, 25),
        load: typeahead.nil?,
        select: typeahead,
        scope_results: (-> (r) { r.with_deleted } if filter_params.key?(:with_deleted))
      )
      @pagy = Pagy.new_from_searchkick(@resources)
      respond_to do |format|
        format.html
        format.json { render json: @resources.map(&typeahead).uniq }
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

    def edit
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
      result = Resources::Destroy.call(resource: @resource, really: params[:really])
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

    def not_found
      self.action_name = :not_found
      respond_to do |format|
        format.html { render :not_found, status: :not_found }
        format.json { head :not_found }
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
      scope = (action_name.to_sym == :destroy) ? :with_deleted : :unscoped
      @resource = case entity
                  when Entities::Singleton
                    model_class.instance
                  when Entities::Entity
                    model_class.send(scope).find(params[:id])
                  end
      unless request.path.start_with? polymorphic_path(@resource)
        return redirect_to @resource, status: :moved_permanently
      end
    end

    def set_breadcrumb
      model_name_plural = model_name.human.pluralize.downcase
      title = t('titles.schematics.resources.index', model_name_plural: model_name_plural)
      breadcrumb title, :"#{entity.name.pluralize}_path"
    end
  end
end
