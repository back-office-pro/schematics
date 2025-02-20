# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Button::Help::Component, type: :component do
  subject { render_inline described_class.new(model_class:) }

  include_context 'with user'

  let(:text) { described_class.t('.text') }

  before { allow(vc_test_controller).to receive(:current_user).and_return(user) }

  context 'when model class is core but do not have external documentation' do
    let(:model_class) { User }

    it { is_expected.to have_no_link }
  end

  context 'when model class is core and have external documentation' do
    let(:model_class) { Migration }
    let(:path) { '/docs/en/reference/migrations' }

    it { is_expected.to have_link(text, href: Server.url(path:)) }
  end

  context 'when model class is not core' do
    let(:model_class) { class_double('Prospect', entity: nil) } # rubocop:disable RSpec/VerifiedDoubleReference

    it { is_expected.to have_link(href: '#') }
  end

  context 'when there is no model class' do
    let(:model_class) { nil }
    let(:path) { '/docs/en/reference/' }

    it { is_expected.to have_link(text, href: Server.url(path:)) }
  end
end
