# frozen_string_literal: true

class DraftsController < Schematics::ResourcesController
  around_action :touch_session!, only: :update
end
