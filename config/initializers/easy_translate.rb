# frozen_string_literal: true

EasyTranslate.api_key = Schematics::Engine
                        .credentials
                        .gcloud
                        .fetch(:api_key)
