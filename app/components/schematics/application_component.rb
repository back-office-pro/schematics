# frozen_string_literal: true

module Schematics
  class ApplicationComponent < ViewComponent::Base
    include ViewComponent::Translatable
    include ApplicationHelper

    delegate_missing_to :helpers
  end
end
