# frozen_string_literal: true

module Schematics
  module Profile
    class Update
      include Interactor::Organizer

      organize ::Sessions::Create, Resources::UpdateAndCache
    end
  end
end
