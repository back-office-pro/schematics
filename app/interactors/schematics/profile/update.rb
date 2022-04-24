# frozen_string_literal: true

module Schematics
  module Profile
    class Update
      include Interactor::Organizer

      organize MainApp::Sessions::Create, Resources::UpdateAndCache
    end
  end
end
