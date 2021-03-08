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

            model_class.reindex

            let(:model_class) { self.class.name.split('::').third.singularize.constantize }
            let(:entity) { model_class.entity }
            let(:record) { send(model_class.entity.name.pluralize, :one) }
            let(:other_record) { send(model_class.entity.name.pluralize, :two) }
            let(:request) do
              {
                entity.name => entity.fillable_elements.map do |element|
                  [element.column_name, element.json_default || record.send(element.column_name)]
                end.to_h,
              }
            end

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

      def context401
        context '401' do
          let(:auth_token) { '' }

          example_request 'Not authorized' do
            expect(response_status).to eq(401)
            expect(response_body).to be_blank
          end
        end
      end

      def context404
        context '404' do
          example_request 'Not found' do
            expect(response_status).to eq(404)
            expect(response_body).to be_blank
          end
        end
      end

      def context422
        context '422' do
          let(:id) { record.id }

          example 'Unprocessable entity' do
            do_request
            expect(response_status).to eq(422)
          end
        end
      end

      def test_index
        return if entity.is_a?(Entities::Singleton)
        route_summary "#{entity.name.pluralize} list"
        get polymorphic_path(model_class) do
          parameter :with_deleted, 'Display archives', with_example: true
          entity.searchable_elements.each do |element|
            parameter element.name.to_sym,
                      "Filter by #{element.name}",
                      with_example: true
          end

          context401
          context '200' do
            let(:expected_result) do
              ActiveModelSerializers::SerializableResource
                .new([record, other_record])
                .as_json
                .flat_map(&:as_json)
            end

            example_request "Getting a list of #{entity.name.pluralize}" do
              expect(response_status).to eq(200)
              expect(json_response).to contain_exactly(*expected_result)
            end
          end
        end
      end

      def test_show
        route_summary "Show #{entity.name.pluralize}"
        case entity
        when Entities::Singleton
          get polymorphic_path(model_class) do
            context401
            context '200' do
              let(:expected_result) do
                ActiveModelSerializers::SerializableResource
                  .new(other_record)
                  .as_json
                  .deep_stringify_keys
                  .transform_values(&:as_json)
              end

              example_request "Getting a #{entity.name}" do
                expect(response_status).to eq(200)
                expect(json_response).to eq(expected_result)
              end
            end
          end
        else
          get "#{polymorphic_path(model_class)}/:id" do
            context401
            context404
            context '200' do
              let(:id) { record.id }
              let(:expected_result) do
                ActiveModelSerializers::SerializableResource
                  .new(record)
                  .as_json
                  .deep_stringify_keys
                  .transform_values(&:as_json)
              end

              example_request "Getting a #{entity.name}" do
                expect(response_status).to eq(200)
                expect(json_response).to eq(expected_result)
              end
            end
          end
        end
      end

      def test_create
        return if entity.is_a?(Entities::Singleton)
        route_summary "Create #{entity.name}"
        post polymorphic_path(model_class) do
          entity.fillable_elements.each do |element|
            parameter element.name.to_sym,
                      type: element.type,
                      default: element.json_default,
                      with_example: true,
                      required: element.required?,
                      scope: entity.name.to_sym
          end

          context401
          context422
          context '200' do
            example "Creating a #{entity.name}" do
              do_request(request)
              expect(response_status).to eq(201)
              expect(response_body).to be_blank
            end
          end
        end
      end

      def test_update
        route_summary "Show #{entity.name.pluralize}"
        case entity
        when Entities::Singleton
          put polymorphic_path(model_class) do
            entity.fillable_elements.each do |element|
              parameter element.name.to_sym,
                        type: element.type,
                        default: element.json_default,
                        with_example: true,
                        required: element.required?,
                        scope: entity.name.to_sym
            end

            context401
            context422
            context '200' do
              example "Updating a #{entity.name}" do
                do_request(request)
                expect(response_status).to eq(204)
                expect(response_body).to be_blank
              end
            end
          end
        else
          put "#{polymorphic_path(model_class)}/:id" do
            entity.fillable_elements.each do |element|
              parameter element.name.to_sym,
                        type: element.type,
                        default: element.json_default,
                        with_example: true,
                        required: element.required?,
                        scope: entity.name.to_sym
            end

            context401
            context404
            context422
            context '200' do
              let(:id) { record.id }

              example "Updating a #{entity.name}" do
                do_request(request)
                expect(response_status).to eq(204)
                expect(response_body).to be_blank
              end
            end
          end
        end
      end

      def test_destroy
        return if entity.is_a?(Entities::Singleton)
        route_summary "Destroy #{entity.name}"
        delete "#{polymorphic_path(model_class)}/:id" do
          context401
          context404
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
          context401
          context404
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
          context401
          context404
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
