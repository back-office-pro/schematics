# frozen_string_literal: true

module Schematics
  module Navbar
    module MyAccount
      class Component < ApplicationComponent
        delegate :role, :teams, to: :current_user
      end
    end
  end
end
