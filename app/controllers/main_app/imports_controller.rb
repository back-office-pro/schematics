# frozen_string_literal: true

module MainApp
  module ImportsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
      skip_authorize_resource only: %i[new create template]
      before_action -> { authorize!(:import, parent_model_class) }, only: %i[new create template] # rubocop:disable Rails/LexicallyScopedActionFilter
      after_action :enqueue_job, only: :create, if: -> { @resource.persisted? }
    end

    def template
      respond_to do |format|
        format.csv do
          result = Schematics::Resources::GenerateFileInBackground.call(
            fingerprint: params[:fingerprint],
            job: Schematics::GenerateCsvTemplateJob,
            job_params: [parent_model_class.to_s],
            extension: 'csv',
            slug: parent_human_name_plural
          )
          return send_data result.data if result.failure?

          send_file result.filepath, type: 'text/csv', filename: result.filename
        end
      end
    end

    private

    def enqueue_job
      Schematics::ImportJob.perform_later(@resource.id, parent_model_class.to_s)
    end
  end
end
