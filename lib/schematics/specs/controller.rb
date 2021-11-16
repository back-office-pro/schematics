# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Controller
      extend ActiveSupport::Concern

      included do
        describe 'exception rescuing' do
          it { is_expected.to rescue_from(ActiveRecord::RecordNotFound).with(:not_found) }
          it { is_expected.to rescue_from(CanCan::AccessDenied).with(:forbidden) }
          it do
            is_expected
              .to rescue_from(ActionController::ParameterMissing)
              .with(:parameter_missing)
          end
        end

        describe 'before actions' do
          it { is_expected.to use_before_action(:authorize) }
          it { is_expected.to use_before_action(:set_paper_trail_whodunnit) }
          it { is_expected.to use_before_action(:set_resource) }
          it { is_expected.to use_before_action(:set_breadcrumb) }
        end
      end

      class_methods do
        delegate :entity, to: :model_class, private: true

        def model_class
          name.demodulize.split('_').first.constantize
        end
      end
    end
  end
end
