# frozen_string_literal: true

module Schematics
  module Imports
    class ImportData
      include Interactor::Organizer

      organize ReadData, ValidateData, InsertData
    end
  end
end
