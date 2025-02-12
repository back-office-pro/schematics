# frozen_string_literal: true

module Schematics
  module Navbar
    module MeetingCenter
      module Preview
        class Component < ApplicationComponent
          delegate :creator, :subject, :start_at, :location, to: :@meeting
          with_collection_parameter :meeting

          def initialize(meeting:)
            super
            @meeting = meeting
          end

          def href = resource_path(@meeting)
        end
      end
    end
  end
end
