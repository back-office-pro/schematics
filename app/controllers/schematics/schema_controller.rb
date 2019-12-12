module Schematics
  class SchemaController < ApplicationController
    include Pagy::Backend
    protect_from_forgery unless: -> { request.format.json? }
    before_action :set_paper_trail_whodunnit
    before_action :authenticate_user!
    before_action :set_resource, only: [:show, :edit, :update, :destroy]
    after_action { pagy_headers_merge(@pagy) if @pagy }
    has_scope :with_deleted, type: :boolean, only: :index
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    helper_method :model_class
    
    class << self
      Swagger::Docs::Generator::set_real_methods
      def inherited(subclass)
        super
        subclass.entity.controllerize(subclass)
      end
    end

    def index
      @pagy, @resources = pagy(apply_scopes(model_class).includes(eager_loading).order(ordering_params).all, items: params[:per_page] || 10)
      respond_to do |format|
        format.html
        format.json { render schema: @resources }
        format.csv  { render csv:   @resources }
        format.xls  { render xls:   @resources }
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { render schema: @resource }
        format.pdf  { 
          render pdf: "#{self.class.entity_name.dasherize}-#{@resource.id}.pdf", template: 'schematics/application/show', layout: 'layouts/schematics/pdf.html'
        }
      end
    end

    def new
      @resource = model_class.new
    end

    def edit
    end

    def create
      @resource = model_class.new(record_params)
      if @resource.save
        respond_to do |format|
          format.html { redirect_to @resource, notice: "#{self.class.entity_name.humanize} was successfully created" }
          format.json { head :created }
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: @record.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      if @resource.update(record_params)
        respond_to do |format|
          format.html { redirect_to @resource, notice: "#{self.class.entity_name.humanize} was successfully updated" }
          format.json
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @record.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      if params[:really] 
        @resource.really_destroy! 
        notice = "#{self.class.entity_name.humanize} was successfully destroyed"
      elsif @resource.deleted? 
        @resource.restore(recursive: true)
        notice = "#{self.class.entity_name.humanize} was successfully restored"
      else
        @resource.destroy
        notice = "#{self.class.entity_name.humanize} was successfully archived"
      end
      respond_to do |format|
        format.html { redirect_back fallback_location: url_for(action: :index), notice: notice }
        format.json
      end
    end

    def not_found
      respond_to do |format|
        format.html { render :not_found }
        format.json { head :not_found }
      end
    end

    private

    def self.model_name
      controller_name.classify
    end

    def self.entity_name
      self.model_name.underscore
    end

    def self.entity
      SCHEMA.find_entity_by_type(self.entity_name)
    end

    def model_class
      self.class.model_name.constantize
    end

    def set_resource
      @resource = (action_name.to_sym === :destroy ? model_class.with_deleted : model_class).find(params[:id])
    end

    def record_params
      params.require(self.class.entity_name.to_sym).send(:permit, *self.class.entity.permitted_params)
    end

    def ordering_params
      ordering = {}
      if params[:sort]
        sort_order = { '+' => :asc, '-' => :desc }
        sorted_params = params[:sort].split(',')
        sorted_params.each do |attr|
          sort_sign = (attr =~ /\A[+-]/) ? attr.slice!(0) : '+'
          if model_class.attribute_names.include?(attr)
            ordering[attr] = sort_order[sort_sign]
          end
        end
      end
      return ordering
    end

    def eager_loading
      self.class.entity.references.map(&:name).map(&:to_sym) + 
      self.class.entity.has_one_through_associations.map(&:name).map(&:to_sym) +
      self.class.entity.has_one_associations.map(&:name).map(&:to_sym)
    end
  end
end
