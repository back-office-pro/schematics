# frozen_string_literal: true

module Schematics
  class ResourcesController < ApplicationController # rubocop:disable Metrics/ClassLength
    include Fillable
    include Searchable
    include Calendarable
    include Documentable
    include Versionable
    include Lockable
    include Redirectable

    before_action :set_resource, except: %i[index new create autocomplete]
    before_action :set_resources, only: :index
    before_action :redirect_to_resource_path, only: :show
    before_action :redirect_to_edit_resource_path, only: :edit
    before_action :set_breadcrumb
    before_action :log_search!, only: :index
    after_action :assign_etag, only: %i[show update]

    responders :flash, ResourceResponder
    respond_to :html, except: :autocomplete
    respond_to :json, except: %i[new edit delete]
    respond_to :svg, :ics, only: :show

    prepend_view_path Engine.root.join('app', 'views', 'core')

    authorize_resource instance_name: :resource, except: %i[autocomplete trigger]

    delegate :model_class, to: :class
    delegate :entity, :human_name, :human_name_plural, :gender, to: :model_class

    helper_method :model_class

    class << self
      def model_class = controller_path
        .classify
        .constantize
    end

    def archive
      result = Resources::Archive.call(resource: @resource)
      respond_with result, location: index_path, redirect_on_failure: true
    end

    def autocomplete
      authorize! :index, model_class
      respond_with model_class.autocomplete(filter_params, current_ability, params.require(:field))
    end

    def index
      return unless stale?(@resources)

      respond_with do |format|
        format.json { render json: @resources.to_a, metadata: params.key?(:metadata) }
        format.csv do
          GenerateCsvJob.perform_later(
            current_user,
            @resources.to_a,
            params.key?(:all_pages) || @pagy.pages > 1
          )
          head :accepted
        end
      end
    end

    def delete; end

    def show
      return unless stale?(@resource)

      respond_with(@resource, ability: current_ability) do |format|
        format.pdf do
          GeneratePdfJob.perform_later(current_user, @resource)
          head :accepted
        end
      end
    end

    def duplicate
      @resource = @resource.dup
      result = Resources::Duplicate.call(resource: @resource)
      respond_with result, location: resource_path
    end

    def new
      @resource = model_class.new
      @draft = current_user.drafts.find_by(action: polymorphic_path(model_class))
    end

    def edit; end

    def create
      @resource = model_class.new(resource_params)
      result = Resources::Create.call(resource: @resource)
      respond_with result, location: resource_path
    end

    def restore
      result = Resources::Restore.call(resource: @resource)
      respond_with result, location: index_path, redirect_on_failure: true
    end

    def update
      result = Resources::UpdateAndCache.call(resource: @resource, resource_params:)
      respond_with result, location: resource_path
    end

    def trigger
      event = entity.find_event_by_name(params.require(:event))
      authorize! event.name.to_sym, @resource
      result = Resources::Trigger.call(resource: @resource, event:)
      respond_with result,
                   location: -> { request.referer || resource_path },
                   action: :show,
                   flash_interpolation_options: { event: event.human.downcase }
    end

    def destroy
      result = Resources::Destroy.call(resource: @resource)
      respond_with result, location: index_path, redirect_on_failure: true
    end

    def view_assigns = super.merge(
      human_name_plural:,
      human_name:,
      gender:
    )

    protected

    def resource_path = main_app.polymorphic_path(@resource)

    def i18n_title_path = 'schematics.resources'

    def index_path
      return main_app.polymorphic_path(model_class) if can?(:index, model_class)

      schematics.root_path
    end

    def set_breadcrumb
      return unless can?(:index, model_class)

      breadcrumb t('titles.schematics.resources.index', human_name_plural:), index_path
    end

    def set_resource
      @resource = model_class
                  .preload_all
                  .with_slugs
                  .then_tap { _1.with_deleted if request.delete? }
                  .load_async
                  .finder(params[:id])
    end

    def set_resources
      @resources = model_class.list(filter_params, current_ability, params[:sort])
      return if params.key?(:all_pages)

      @calendar, @pagy, @resources = pagy_calendar(
        @resources,
        month: { format: t('date.formats.month') },
        pagy: { backend: ::Tenant.search_engine.pagy_backend },
        active: entity.viewer == :calendar
      )
    end

    def flash_interpolation_options = { human_name:, gender: }
  end
end
