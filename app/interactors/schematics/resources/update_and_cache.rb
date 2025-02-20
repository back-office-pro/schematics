# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Resources
    class UpdateAndCache
      include Interactor::Organizer

      organize Update, Cache
    end
  end
end
