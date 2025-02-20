# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Imports
    class ImportData
      include Interactor::Organizer

      organize ReadData, ValidateData, InsertData
    end
  end
end
