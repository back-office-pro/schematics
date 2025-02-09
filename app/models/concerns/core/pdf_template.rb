# frozen_string_literal: true

module Core
  module PDFTemplate
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Interpolable
    end
  end
end
