module Schematics
  class SchemaController < ApplicationController
    include Pagy::Backend
    before_action :set_paper_trail_whodunnit
    before_action :authorize
    before_action :set_resource, only: [:show, :edit, :update, :destroy]
    after_action { pagy_headers_merge(@pagy) if @pagy }
    has_scope :with_deleted, type: :boolean, only: :index
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    delegate :model_class, to: :class
    delegate :entity, :model_name, to: :model_class
    attr_reader :resource

    class << self
      delegate :entity, :model_name, to: :model_class
      Swagger::Docs::Generator.set_real_methods

      def inherited(subclass)
        super
        subclass.class_eval do
          entity.controllerize(subclass)
        end
      end

      def model_class
        controller_name.classify.constantize
      end
    end

    def index
      @pagy, @resources = pagy(
        apply_scopes(model_class).
        includes(entity.eager_loading).
        order(created_at: :desc),
        items: params.fetch(:per_page, 10)
      )
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
                 layout: 'layouts/schematics/pdf.html'
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
      if @resource.save
        respond_to do |format|
          format.html do
            notice = t('schematics.schema.create.created', model_name: model_name.human)
            redirect_to @resource, notice: notice
          end
          format.json { head :created }
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      if @resource.update(resource_params)
        respond_to do |format|
          format.html do
            notice = t('schematics.schema.update.updated', model_name: model_name.human)
            redirect_to @resource, notice: notice
          end
          format.json
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      if params[:really]
        @resource.really_destroy!
        action = :destroyed
      elsif @resource.deleted?
        @resource.restore(recursive: true)
        action = :restored
      else
        @resource.destroy
        action = :archived
      end
      respond_to do |format|
        format.html do
          notice = t(action, model_name: model_name.human, scope: 'schematics.schema.destroy')
          redirect_to polymorphic_path(model_class), notice: notice
        end
        format.json
      end
    end

    def not_found
      respond_to do |format|
        format.html { render :not_found, status: :not_found }
        format.json { head :not_found }
      end
    end

    protected

    def set_resource
      title = t('schematics.schema.index.title', model_name: model_name.human.pluralize.downcase)
      breadcrumb title, :"#{entity.type.pluralize}_path"
      scope = (action_name.to_sym == :destroy) ? :with_deleted : :unscoped
      @resource = model_class.send(scope).includes(entity.eager_loading).find(params[:id])
    end

    def resource_params
      keys = request.format.json? ? entity.permitted_json_params : entity.permitted_params
      params.require(entity.type.to_sym).send(:permit, *keys)
    end
  end
end
