# frozen_string_literal: true

module Schematics
  module ImportsController
    extend ActiveSupport::Concern

    prepended do
      include Nestable
      skip_authorize_resource only: %i[new create template]
      after_action :enqueue_job, only: :create, if: -> { @resource.persisted? }
    end

    def template
      respond_to do |format|
        format.csv do
          result = Resources::GenerateFileInBackground.call(
            fingerprint: params[:fingerprint],
            job: GenerateCsvTemplateJob,
            job_params: [parent_model_name.to_s],
            extension: 'csv',
            slug: parent_model_name_plural
          )
          return send_data result.data if result.failure?

          send_file result.filepath, type: 'text/csv', filename: result.filename
        end
      end
    end

    private

    def enqueue_job
      ImportJob.perform_later(@resource.id, parent_model_name.to_s)
    end
  end
end
