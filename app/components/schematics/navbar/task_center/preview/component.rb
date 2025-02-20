# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Navbar
    module TaskCenter
      module Preview
        class Component < ApplicationComponent
          delegate :applicant, :title, :deadline, :late?, :state_formatted, to: :@task
          with_collection_parameter :task

          def initialize(task:)
            super
            @task = task
          end

          def href = resource_path(@task)

          def css_class
            'text-danger' if late?
          end
        end
      end
    end
  end
end
