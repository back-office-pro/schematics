require 'schematics/specs/helpers'

module Schematics
  module Specs
    module Acceptance
      include Helpers

      class << self
        def extended(subclass)
          super
          plural = subclass.to_s.demodulize
          model_class = plural.singularize.constantize
          subclass.class_eval do
            shared_setup
            token_auth

            fixtures model_class.entity.name.pluralize.to_sym

            unless model_class.entity.is_a?(Entities::Singleton)
              get Rails.application.routes.url_helpers.polymorphic_path(model_class) do
                # context '401' do
                #   let(:access_token) { 'foo' }

                #   example 'Authentication error' do
                #     do_request
                #     expect(response_status).to eq(401)
                #   end
                # end

                context '200' do
                  example "Getting a list of #{plural}" do
                    do_request
                    expect(response_status).to eq(200)
                    # expect(json_response).to eq()
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
