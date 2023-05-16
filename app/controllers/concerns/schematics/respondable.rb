# frozen_string_literal: true

module Schematics
  module Respondable
    extend ActiveSupport::Concern

    included do
      respond_to :html, :json
      responders :flash, Schematics::InteractorResponder
    end
  end
end
