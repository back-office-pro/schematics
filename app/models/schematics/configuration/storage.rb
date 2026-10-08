# frozen_string_literal: true

module Schematics
  module Configuration
    class Storage
      delegate :aws_bucket,
               :aws_access_key_id,
               :aws_secret_access_key,
               :aws_region,
               :azure_storage_account_name,
               :azure_storage_access_key,
               :gcs_private_key_id,
               :gcs_private_key,
               to: :@configuration,
               private: true

      def initialize(configuration)
        @configuration = configuration
      end

      def service # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        return :amazon if aws_bucket && aws_access_key_id && aws_secret_access_key && aws_region
        return :microsoft if azure_storage_account_name && azure_storage_access_key
        return :google if gcs_private_key_id && gcs_private_key

        Rails.configuration.active_storage.service
      end

      def service_configurations = ::Rails
        .configuration
        .active_storage
        .service_configurations
        .merge(
          amazon: {
            service: 'S3',
            access_key_id: aws_access_key_id,
            secret_access_key: aws_secret_access_key,
            region: aws_region,
            bucket: aws_bucket,
            http_open_timeout: 1,
            http_read_timeout: 1
          },
          microsoft: {
            service: 'AzureBlob',
            storage_account_name: azure_storage_account_name,
            storage_access_key: azure_storage_access_key,
            container: ''
          },
          google: {
            service: 'GCS',
            project: '',
            bucket: '',
            credentials: {
              type: 'service_account',
              project_id: '',
              private_key_id: gcs_private_key_id,
              private_key: gcs_private_key,
              client_email: '',
              client_id: '',
              auth_uri: 'https://accounts.google.com/o/oauth2/auth',
              token_uri: 'https://accounts.google.com/o/oauth2/token',
              auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
              client_x509_cert_url: ''
            }
          }
        )
    end
  end
end
