# frozen_string_literal: true

Rails.configuration.to_prepare do
  if defined?(ImportsController)
    ImportsController.class_eval do
      include Schematics::Nestable
      skip_authorize_resource only: %i[new create template]
      after_action -> { Schematics::ImportJob.perform_later(@resource.id, parent_model_name.to_s) },
                   only: :create,
                   if: -> { @resource.persisted? }

      def template
        respond_to do |format|
          format.csv do
            result = Schematics::Resources::GenerateFileInBackground.call(
              fingerprint: params[:fingerprint],
              job: Schematics::GenerateCsvTemplateJob,
              job_params: [parent_model_name.to_s],
              extension: 'csv',
              slug: parent_model_name_plural
            )
            return send_data result.data if result.failure?

            send_file result.filepath, type: 'text/csv', filename: result.filename
          end
        end
      end
    end
  end
end
