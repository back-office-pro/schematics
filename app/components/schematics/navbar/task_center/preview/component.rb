# frozen_string_literal: true

module Schematics
  module Navbar
    module TaskCenter
      module Preview
        class Component < ApplicationComponent
          delegate :applicant, :title, :created_at, to: :@task

          def initialize(task:)
            super
            @task = task
          end

          def href = task_path(@task)
        end
      end
    end
  end
end
