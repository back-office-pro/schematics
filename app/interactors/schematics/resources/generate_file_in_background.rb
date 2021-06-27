# frozen_string_literal: true

module Schematics
  module Resources
    class GenerateFileInBackground
      include Interactor

      before do
        @fingerprint = context.fingerprint || SecureRandom.uuid
        @job = context.job
        @job_params = context.job_params
        @extension = context.extension
        @slug = context.slug
      end

      def call
        if context.fingerprint
          if File.exist?(filepath)
            context.filename = filename
            context.filepath = filepath
          else
            context.fail!
          end
        else
          @job.perform_later(*@job_params.push(filepath))
          context.fail!(data: @fingerprint)
        end
      end

      private

      def filepath
        Rails.cache.fetch("tmp_file_path:#{@fingerprint}", expires_in: 5.minutes) do
          Rails.root.join('tmp', "#{SecureRandom.uuid}.#{@extension}").to_s
        end
      end

      def filename
        [@slug, @extension].join('.')
      end
    end
  end
end
