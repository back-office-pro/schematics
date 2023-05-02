# frozen_string_literal: true

module Core
  class DraftsController < Schematics::ResourcesController
    after_action :touch_session!, only: :update
  end
end
