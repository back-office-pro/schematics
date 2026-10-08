# frozen_string_literal: true

class DraftsController < Schematics::ResourcesController
  skip_before_action :set_draft
end
