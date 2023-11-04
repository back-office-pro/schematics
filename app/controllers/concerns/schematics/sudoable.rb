# frozen_string_literal: true

module Schematics
  module Sudoable
    extend ActiveSupport::Concern

    def require_sudo!
      return if current_session.sudo?

      store_location
      redirect_to schematics.sudo_path
    end
  end
end
