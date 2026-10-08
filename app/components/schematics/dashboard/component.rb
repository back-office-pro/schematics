# frozen_string_literal: true

module Schematics
  module Dashboard
    class Component < ApplicationComponent
      memoize def dashboards = ::Dashboard
        .preload_all
        .accessible_by_role(current_user.role)
    end
  end
end
