# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  let(:user_params) do
    {
      user: {
        email: 'john@doe.com',
        password: '123456',
        first_name: 'John',
        last_name: 'Doe',
        locale: 'en',
      },
    }
  end
  let(:permitted_params) do
    [
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :avatar,
      { avatar_attachment_attributes: %i[id _destroy] },
      :locale,
      :time_zone,
      :role_id,
    ]
  end

  describe 'exception rescuing' do
    it { is_expected.to rescue_from(ActionController::ParameterMissing).with(:parameter_missing) }
    it { is_expected.to rescue_from(ActiveRecord::RecordNotFound).with(:not_found) }
    it { is_expected.to rescue_from(CanCan::AccessDenied).with(:forbidden) }
  end

  describe 'before actions' do
    it { is_expected.to use_before_action(:authorize) }
    it { is_expected.to use_before_action(:set_paper_trail_whodunnit) }
    it { is_expected.to use_before_action(:set_resource) }
    it { is_expected.to use_before_action(:set_breadcrumb) }
  end

  describe 'routes' do
    it { is_expected.to route(:get, '/users').to(controller: :users, action: :index, locale: :en, model_name: 'User') } # rubocop:disable Layout/LineLength
    it { is_expected.to route(:get, '/utilisateurs').to(controller: :users, action: :index, locale: :fr, model_name: 'User') } # rubocop:disable Layout/LineLength
    it { is_expected.to route(:get, '/users/1').to(controller: :users, action: :show, id: 1, locale: :en, model_name: 'User') } # rubocop:disable Layout/LineLength
    it { is_expected.to route(:get, '/utilisateurs/1').to(controller: :users, action: :show, id: 1, locale: :fr, model_name: 'User') } # rubocop:disable Layout/LineLength
  end

  xdescribe 'permitted params' do
    it { is_expected.to permit(*permitted_params).for(:create, params: user_params).on(:user) }
  end
end
