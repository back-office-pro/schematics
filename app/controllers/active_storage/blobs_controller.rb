# frozen_string_literal: true

module ActiveStorage
  class BlobsController < Schematics::ResourcesController
    include Schematics::ResourcesHelper
    skip_before_action :redirect_to_resource_path, only: :show # rubocop:disable Rails/LexicallyScopedActionFilter

    def viewers = super.unshift(:grid)
  end
end
