module Schematics
  class SchemaController < ApplicationController
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
        "schematics/schema"
      end
    end

    def index
      @q = model_class.ransack(params[:q])
      @q.sorts = 'created_at desc' if @q.sorts.empty?
      @pagy, @resources = pagy @q.result, items: params.fetch(:per_page, 25)
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
          format.json { respond_with_bip(@resource) }
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
      title = t('titles.schematics.schema.index',
                model_name_plural: model_name.human.pluralize.downcase)
      breadcrumb title, :"#{entity.type.pluralize}_path"
    end

    def resource_params
      keys = request.format.json? ? entity.permitted_json_params : entity.permitted_params
      defaults = entity.references_attributes.map { |attribute| [attribute.name, current_user] }
      params.require(entity.type.to_sym).permit(keys).with_defaults(defaults)
    end
  end
end
