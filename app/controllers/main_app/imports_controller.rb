# frozen_string_literal: true

module MainApp
  module ImportsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
      skip_authorize_resource only: %i[new create]
      before_action -> { authorize!(:import, parent_model_class) }, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
      after_action :enqueue_job, only: :create, if: -> { @resource.persisted? }
    end

    def new
      super
      respond_to do |format|
        format.html
        format.csv do
          Schematics::GenerateCsvTemplateJob.perform_later(current_user, parent_model_class)
          head :accepted
        end
      end
    end

    private

    def enqueue_job
      Schematics::ImportJob.perform_later(@resource, parent_model_class)
    end
  end
end
