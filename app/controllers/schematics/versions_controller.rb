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
  class VersionsController < ApplicationController
    include ResourcesHelper

    authorize_resource class: Version
    before_action :set_version, only: %i[show revert]
    delegate :human_name, :gender, to: :model_class, private: true

    def index
      @pagy, @versions = pagy(model_class.timeline(current_ability))
      return unless stale?(@versions)

      breadcrumb title, versions_path
      respond_to do |format|
        format.html { render VersionsTimeline::Component.new(versions: @versions, pagy: @pagy) }
        format.json { render json: @versions }
      end
    end

    def revert
      result = Versions::Revert.call(version: @version)
      respond_with(
        result,
        location: resource_path(@version.item),
        flash_interpolation_options: {
          human_name: @version.model_class.human_name,
          gender: @version.model_class.gender
        }
      )
    end

    def show
      return unless stale?(@version)

      breadcrumb title, versions_path
      respond_to do |format|
        format.html { render VersionsComparison::Component.new(version: @version) }
        format.json { render json: @version }
      end
    end

    private

    def set_version
      @version = model_class
                 .with_user
                 .load_async
                 .find(params[:id])
    end

    def model_class = Version

    def index_path = versions_path
  end
end
