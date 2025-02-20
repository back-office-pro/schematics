# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Respondable
    extend ActiveSupport::Concern

    included do
      responders :flash, InteractorResponder
      respond_to :html, :json
    end
  end
end
