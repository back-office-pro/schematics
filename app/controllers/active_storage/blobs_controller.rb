# frozen_string_literal: true

module ActiveStorage
  class BlobsController < Schematics::ResourcesController
    skip_before_action :redirect_to_resource_path, only: :show
  end
end
