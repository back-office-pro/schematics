# frozen_string_literal: true

module Core
  module LinkPreviews
    class Process
      include Interactor::Organizer

      organize Parse, Upsert
    end
  end
end
