require 'schematics/specs/helpers'

module Schematics
  module Specs
    module Acceptance
      include Helpers
      delegate :polymorphic_path, to: 'Rails.application.routes.url_helpers', private: true
      delegate :entity, to: :model_class, private: true

      class << self
        def extended(subclass)
          super
          subclass.class_eval do
            shared_setup
            token_auth
            fixtures entity.name.pluralize.to_sym

            let(:model_class) { self.class.name.split('::').third.singularize.constantize }
            let(:record) { send(model_class.entity.name.pluralize, :one) }
            let(:other_record) { send(model_class.entity.name.pluralize, :two) }

            explanation "#{entity.name.pluralize} resource"

            test_index
            test_show
            test_create
            test_update
            test_destroy
            test_archive
            test_restore
          end
        end
      end

      protected

      def model_class
        name.split('::').third.singularize.constantize
      end

      def not_authorized
        context '401' do
          let(:auth_token) { '' }

          example_request 'Not authorized' do
            expect(response_status).to eq(401)
            expect(response_body).to be_blank
          end
        end
      end

      def not_found
        context '404' do
          example_request 'Not found' do
            expect(response_status).to eq(404)
            expect(response_body).to be_blank
          end
        end
      end

      def test_index
        return if entity.is_a?(Entities::Singleton)
        route_summary "#{entity.name.pluralize} list"
        get polymorphic_path(model_class) do
          # with_options scope: :filter, with_example: true do
          #   entity.searchable_elements.each do |element|
          #     parameter element.name.to_sym, "Filter by #{element.name}"
          #   end
          # end

          not_authorized
          context '200' do
            let(:expected_result) do
              ActiveModelSerializers::SerializableResource
                .new([record, other_record])
                .to_json
            end

            example_request "Getting a list of #{entity.name.pluralize}" do
              expect(response_status).to eq(200)
              expect(response_body).to eq(expected_result)
            end
          end
        end
      end

      def test_show
        route_summary "Show #{entity.name.pluralize}"
        case entity
        when Entities::Singleton
          get polymorphic_path(model_class) do
            not_authorized
            context '200' do
              let(:expected_result) do
                ActiveModelSerializers::SerializableResource
                  .new(other_record)
                  .to_json
              end

              example_request "Getting a #{entity.name}" do
                expect(response_status).to eq(200)
                expect(response_body).to eq(expected_result)
              end
            end
          end
        else
          get "#{polymorphic_path(model_class)}/:id" do
            not_authorized
            not_found
            context '200' do
              let(:id) { record.id }
              let(:expected_result) do
                ActiveModelSerializers::SerializableResource.new(record).to_json
              end

              example_request "Getting a #{entity.name}" do
                expect(response_status).to eq(200)
                expect(response_body).to eq(expected_result)
              end
            end
          end
        end
      end

      def test_create
        return if entity.is_a?(Entities::Singleton)
      end

      def test_update

      end

      def test_destroy
        return if entity.is_a?(Entities::Singleton)
        route_summary "Destroy #{entity.name}"
        delete "#{polymorphic_path(model_class)}/:id" do
          not_authorized
          not_found
          context '204' do
            let(:id) { record.id }

            example_request "Destroying a #{entity.name}" do
              expect(response_status).to eq(204)
              expect(response_body).to be_blank
            end
          end
        end
      end

      def test_archive
        return if entity.is_a?(Entities::Singleton)
        route_summary "Archive #{entity.name}"
        delete "#{polymorphic_path(model_class)}/:id/archive" do
          not_authorized
          not_found
          context '204' do
            let(:id) { record.id }

            example_request "Archiving a #{entity.name}" do
              expect(response_status).to eq(204)
              expect(response_body).to be_blank
            end
          end
        end
      end

      def test_restore
        return if entity.is_a?(Entities::Singleton)
        route_summary "Restore #{entity.name}"
        delete "#{polymorphic_path(model_class)}/:id/restore" do
          not_authorized
          not_found
          context '204' do
            let(:id) { record.id }

            example_request "Restoring a #{entity.name}" do
              expect(response_status).to eq(204)
              expect(response_body).to be_blank
            end
          end
        end
      end
    end
  end
end
