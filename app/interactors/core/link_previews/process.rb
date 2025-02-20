# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module LinkPreviews
    class Process
      include Interactor::Organizer

      organize Parse, Upsert
    end
  end
end
