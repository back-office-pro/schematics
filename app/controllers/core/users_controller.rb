# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class UsersController < Schematics::ResourcesController
  before_action :require_sudo!, only: :edit # rubocop:disable Rails/LexicallyScopedActionFilter
end
