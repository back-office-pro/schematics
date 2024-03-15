# frozen_string_literal: true

module Core
  module Migrations
    class CopyAndMigrate
      include Interactor::Organizer

      organize Copy, Migrate
    end
  end
end
