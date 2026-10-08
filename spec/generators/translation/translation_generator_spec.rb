# frozen_string_literal: true

require 'rails_helper'
require 'generators/translation/translation_generator'

RSpec.describe TranslationGenerator do
  subject(:generator) { described_class.new([name], options, behavior:) }

  include_context 'with google translate stub'

  let(:translation) do
    Translation.create!(
      locale: 'en',
      key: 'activerecord.attributes.task.title',
      value: 'Title'
    )
  end

  before { translation }

  describe '#invoke_all' do
    subject(:invoke_all) { generator.invoke_all }

    context 'when invoking' do
      let(:behavior) { :invoke }
      let(:name) { 'activerecord.attributes.task.subtitle' }
      let(:options) { [] }

      it 'create translations' do
        expect { invoke_all }
          .to change(Translation, :count)
          .by(3)
      end
    end

    context 'when revoking' do
      let(:behavior) { :revoke }
      let(:name) { 'activerecord.attributes.task.title' }
      let(:options) { [] }

      it 'destroys translation' do
        expect { invoke_all }
          .to change(Translation.with_deleted, :count)
          .by(-1)
      end
    end

    context 'when renaming' do
      let(:behavior) { :invoke }
      let(:name) { 'activerecord.attributes.task.subtitle' }
      let(:options) { ['--rename=activerecord.attributes.task.title'] }

      it 'updates translation key' do
        expect { invoke_all }
          .to change { translation.reload.key }
          .from('activerecord.attributes.task.title')
          .to('activerecord.attributes.task.subtitle')
      end

      it 'updates translation value' do
        expect { invoke_all }
          .to change { translation.reload.value }
          .from('Title')
          .to('Subtitle')
      end
    end
  end
end
