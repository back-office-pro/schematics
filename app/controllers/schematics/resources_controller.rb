# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  class ResourcesController < ApplicationController # rubocop:disable Metrics/ClassLength
    include Fillable
    include Filterable
    include Calendarable
    include Viewable
    include Lockable
    include Redirectable
    include Authorizable
    include ResourcesHelper

    before_action :set_resource, except: %i[index new create]
    before_action :set_resources, only: :index
    before_action :set_draft, only: %i[new edit create duplicate update]
    before_action :authorize_resource, except: :trigger
    before_action :redirect_to_resource_path, only: :show
    before_action :redirect_to_edit_resource_path, only: :edit
    before_action :set_breadcrumb
    before_action :log_search!, only: :index
    before_action :require_sudo!, only: :delete
    after_action :assign_etag, only: %i[show update]
    after_action :assign_api_version

    prepend_view_path Rails.root.join('app/views/core')

    delegate :human_name, :human_name_plural, :gender, to: :model_class

    helper_method :model_class

    def model_name = resolve_model_name_from_route

    def model_class
      model_name.safe_constantize
    end

    def archive
      result = Resources::Archive.call(resource: @resource)
      respond_with result, location: index_path
    end

    def index
      return unless stale?(@resources)

      respond_to do |format|
        format.html
        format.json { render json: @resources.to_a, metadata: params.key?(:metadata) }
        format.csv do
          GenerateCSVJob.perform_later(
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

      respond_to do |format|
        format.html
        format.json { render json: @resource, ability: current_ability }
        format.svg { render svg: @resource }
        format.ics { render ics: @resource }
        format.pdf do
          GeneratePDFJob.perform_later(current_user, @resource)
          head :accepted
        end
      end
    end

    def duplicate
      @resource = @resource.dup
      result = Resources::Duplicate.call(resource: @resource)
      respond_with result, location: show_path
    end

    def new
      @resource = model_class.new
    end

    def edit; end

    def create
      @resource = model_class.new(resource_params_with_defaults)
      result = Resources::Create.call(resource: @resource, draft: @draft)
      respond_with result, location: show_path
    end

    def restore
      result = Resources::Restore.call(resource: @resource)
      respond_with result, location: index_path
    end

    def update
      result = Resources::UpdateAndCache.call(resource: @resource, draft: @draft, resource_params:)
      respond_with result, location: show_path
    end

    def trigger
      event = entity.find_event_by_suffixed_name("#{params[:event]}_#{params[:state]}")
      authorize! event.name.to_sym, @resource
      result = Resources::Trigger.call(resource: @resource, event:)
      respond_with result,
                   location: request.referer || show_path,
                   flash_interpolation_options: { event: event.human.downcase }
    end

    def destroy
      result = Resources::Destroy.call(resource: @resource)
      respond_with result, location: index_path
    end

    def view_assigns = super.merge(human_name_plural:, human_name:, gender:)

    protected

    def _prefixes = super
      .dup
      .unshift(model_name.underscore.pluralize)
      .uniq

    def set_resource
      @resource = model_class
        .preload_all
        .with_string_translations
        .with_slugs
        .then_tap { _1.with_deleted if request.delete? }
        .load_async
        .finder(params[:id])
    end

    def set_resources
      @resources = model_class.list(filter_params, current_ability, params[:sort])
      return if params.key?(:all_pages)

      @calendar, @pagy, @resources = pagy(
        :calendar,
        @resources,
        month: { format: t('date.formats.month') },
        disabled: viewer != :calendar
      )
    end

    def set_draft
      @draft = current_user.find_or_create_draft!(model_name, @resource&.id)
    end

    def set_breadcrumb
      return unless can?(:index, model_class)

      breadcrumb t('titles.schematics.resources.index', human_name_plural:), index_path
    end

    def index_path
      return resources_path(model_class) if can?(:index, model_class)

      root_path
    end

    def show_path = resource_path(@resource)

    def i18n_path = "schematics.resources.#{action_name}"

    def flash_interpolations = { human_name:, gender: }
  end
end
