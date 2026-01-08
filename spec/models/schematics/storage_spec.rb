# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Storage do
  subject(:license) { described_class.new(configuration) }

  let(:configuration) do
    Configuration.new(
      aws_bucket:,
      aws_access_key_id:,
      aws_secret_access_key:,
      aws_region:,
      azure_storage_account_name:,
      azure_storage_access_key:,
      gcs_private_key_id:,
      gcs_private_key:
    )
  end

  context 'when not configured' do
    let(:aws_bucket) { nil }
    let(:aws_access_key_id) { nil }
    let(:aws_secret_access_key) { nil }
    let(:aws_region) { nil }
    let(:azure_storage_account_name) { nil }
    let(:azure_storage_access_key) { nil }
    let(:gcs_private_key_id) { nil }
    let(:gcs_private_key) { nil }
    let(:expected_service_configurations) do
      {
        test: {
          service: 'Disk',
          root: Rails.root.join('tmp/storage')
        },
        local: {
          service: 'Disk',
          root: Rails.root.join('storage')
        },
        amazon: {
          service: 'S3',
          access_key_id: nil,
          secret_access_key: nil,
          region: nil,
          bucket: nil,
          http_open_timeout: 1,
          http_read_timeout: 1
        },
        microsoft: {
          service: 'AzureBlob',
          storage_account_name: nil,
          storage_access_key: nil,
          container: ''
        },
        google: {
          service: 'GCS',
          project: '',
          bucket: '',
          credentials: {
            type: 'service_account',
            project_id: '',
            private_key_id: nil,
            private_key: nil,
            client_email: '',
            client_id: '',
            auth_uri: 'https://accounts.google.com/o/oauth2/auth',
            token_uri: 'https://accounts.google.com/o/oauth2/token',
            auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
            client_x509_cert_url: ''
          }
        }
      }
    end

    its(:service) { is_expected.to eq(:test) }
    its(:service_configurations) { is_expected.to eq(expected_service_configurations) }
  end

  context 'when aws is configured' do
    let(:aws_bucket) { 'test' }
    let(:aws_access_key_id) { 'test' }
    let(:aws_secret_access_key) { 'test' }
    let(:aws_region) { 'af-south-1' }
    let(:azure_storage_account_name) { nil }
    let(:azure_storage_access_key) { nil }
    let(:gcs_private_key_id) { nil }
    let(:gcs_private_key) { nil }
    let(:expected_service_configurations) do
      {
        test: {
          service: 'Disk',
          root: Rails.root.join('tmp/storage')
        },
        local: {
          service: 'Disk',
          root: Rails.root.join('storage')
        },
        amazon: {
          service: 'S3',
          access_key_id: 'test',
          secret_access_key: 'test',
          region: 'af-south-1',
          bucket: 'test',
          http_open_timeout: 1,
          http_read_timeout: 1
        },
        microsoft: {
          service: 'AzureBlob',
          storage_account_name: nil,
          storage_access_key: nil,
          container: ''
        },
        google: {
          service: 'GCS',
          project: '',
          bucket: '',
          credentials: {
            type: 'service_account',
            project_id: '',
            private_key_id: nil,
            private_key: nil,
            client_email: '',
            client_id: '',
            auth_uri: 'https://accounts.google.com/o/oauth2/auth',
            token_uri: 'https://accounts.google.com/o/oauth2/token',
            auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
            client_x509_cert_url: ''
          }
        }
      }
    end

    its(:service) { is_expected.to eq(:amazon) }
    its(:service_configurations) { is_expected.to eq(expected_service_configurations) }
  end

  context 'when azure is configured' do
    let(:aws_bucket) { nil }
    let(:aws_access_key_id) { nil }
    let(:aws_secret_access_key) { nil }
    let(:aws_region) { nil }
    let(:azure_storage_account_name) { 'test' }
    let(:azure_storage_access_key) { 'test' }
    let(:gcs_private_key_id) { nil }
    let(:gcs_private_key) { nil }
    let(:expected_service_configurations) do
      {
        test: {
          service: 'Disk',
          root: Rails.root.join('tmp/storage')
        },
        local: {
          service: 'Disk',
          root: Rails.root.join('storage')
        },
        amazon: {
          service: 'S3',
          access_key_id: nil,
          secret_access_key: nil,
          region: nil,
          bucket: nil,
          http_open_timeout: 1,
          http_read_timeout: 1
        },
        microsoft: {
          service: 'AzureBlob',
          storage_account_name: 'test',
          storage_access_key: 'test',
          container: ''
        },
        google: {
          service: 'GCS',
          project: '',
          bucket: '',
          credentials: {
            type: 'service_account',
            project_id: '',
            private_key_id: nil,
            private_key: nil,
            client_email: '',
            client_id: '',
            auth_uri: 'https://accounts.google.com/o/oauth2/auth',
            token_uri: 'https://accounts.google.com/o/oauth2/token',
            auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
            client_x509_cert_url: ''
          }
        }
      }
    end

    its(:service) { is_expected.to eq(:microsoft) }
    its(:service_configurations) { is_expected.to eq(expected_service_configurations) }
  end

  context 'when gcs is configured' do
    let(:aws_bucket) { nil }
    let(:aws_access_key_id) { nil }
    let(:aws_secret_access_key) { nil }
    let(:aws_region) { nil }
    let(:azure_storage_account_name) { nil }
    let(:azure_storage_access_key) { nil }
    let(:gcs_private_key_id) { 'test' }
    let(:gcs_private_key) { 'test' }
    let(:expected_service_configurations) do
      {
        test: {
          service: 'Disk',
          root: Rails.root.join('tmp/storage')
        },
        local: {
          service: 'Disk',
          root: Rails.root.join('storage')
        },
        amazon: {
          service: 'S3',
          access_key_id: nil,
          secret_access_key: nil,
          region: nil,
          bucket: nil,
          http_open_timeout: 1,
          http_read_timeout: 1
        },
        microsoft: {
          service: 'AzureBlob',
          storage_account_name: nil,
          storage_access_key: nil,
          container: ''
        },
        google: {
          service: 'GCS',
          project: '',
          bucket: '',
          credentials: {
            type: 'service_account',
            project_id: '',
            private_key_id: 'test',
            private_key: 'test',
            client_email: '',
            client_id: '',
            auth_uri: 'https://accounts.google.com/o/oauth2/auth',
            token_uri: 'https://accounts.google.com/o/oauth2/token',
            auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
            client_x509_cert_url: ''
          }
        }
      }
    end

    its(:service) { is_expected.to eq(:google) }
    its(:service_configurations) { is_expected.to eq(expected_service_configurations) }
  end
end
