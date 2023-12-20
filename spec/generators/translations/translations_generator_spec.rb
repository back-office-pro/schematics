# frozen_string_literal: true

require 'rails_helper'
require 'generators/translations/translations_generator'

RSpec.describe TranslationsGenerator do
  subject(:generator) { described_class.new([name], options, behavior:) }

  include_context 'with google translate stub'

  let(:name) { 'task' }
  let(:behavior) { :invoke }
  let(:options) { [] }
  let(:translation) do
    Translation.create!(
      locale: 'en',
      key: 'activerecord.models.task.gender',
      value: 'female'
    )
  end

  before { translation }

  describe '#invoke_all' do
    subject(:invoke_all) { generator.invoke_all }

    context 'when invoking' do
      it 'creates translations' do
        expect { invoke_all }
          .to change(Translation, :count)
          .by(57)
      end
    end

    context 'when revoking' do
      let(:behavior) { :revoke }

      it 'destroys translations' do
        expect { invoke_all }
          .to change(Translation, :count)
          .by(-1)
      end
    end

    context 'when renaming' do
      let(:name) { 'meeting' }
      let(:options) { ['--rename=task'] }

      it 'updates translations' do
        expect { invoke_all }
          .to change { translation.reload.key }
          .from('activerecord.models.task.gender')
          .to('activerecord.models.meeting.gender')
      end
    end
  end
end
