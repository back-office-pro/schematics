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
          result = Schematics::Resources::GenerateFileInBackground.call(
            fingerprint: params[:fingerprint],
            job: Schematics::GenerateCsvTemplateJob,
            job_params: [parent_model_class.to_s],
            extension: 'csv',
            slug: parent_human_name_plural
          )
          return send_data result.data if result.failure?

          send_file result.filepath, type: ::Mime[:csv].to_s, filename: result.filename
        end
      end
    end

    private

    def enqueue_job
      Schematics::ImportJob.perform_later(@resource.id, parent_model_class.to_s)
    end
  end
end
