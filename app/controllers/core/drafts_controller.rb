# frozen_string_literal: true

class DraftsController < Schematics::ResourcesController
  after_action :touch_session!, only: :update
end
