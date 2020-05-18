module Schematics
  module Sessions
    class Update
      include Interactor::Organizer

      organize Create, Resources::Update
    end
  end
end
