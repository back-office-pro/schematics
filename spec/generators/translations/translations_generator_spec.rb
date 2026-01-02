# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'
require 'generators/translations/translations_generator'

RSpec.describe TranslationsGenerator do
  subject(:generator) { described_class.new([name], options, behavior:) }

  include_context 'with google translate stub'

  let(:name) { 'task' }
  let(:behavior) { :invoke }
  let(:options) { [] }
  let(:first_translation) do
    Translation.create!(
      locale: 'en',
      key: 'activerecord.models.task.gender',
      value: 'female'
    )
  end
  let(:second_translation) do
    Translation.create!(
      locale: 'en',
      key: 'activerecord.models.task.one',
      value: 'Task'
    )
  end
  let(:third_translation) do
    Translation.create!(
      locale: 'en',
      key: 'activerecord.models.task.other',
      value: 'Tasks'
    )
  end

  before { [first_translation, second_translation, third_translation] }

  describe '#invoke_all' do
    subject(:invoke_all) { generator.invoke_all }

    context 'when invoking' do
      it 'creates translations' do
        expect { invoke_all }
          .to change(Translation, :count)
          .by(9)
      end
    end

    context 'when revoking' do
      let(:behavior) { :revoke }

      it 'destroys translations' do
        expect { invoke_all }
          .to change(Translation.with_deleted, :count)
          .by(-3)
      end
    end

    context 'when renaming' do
      let(:name) { 'meeting' }
      let(:options) { ['--rename=task'] }

      it 'updates translations' do
        expect { invoke_all }
          .to change { first_translation.reload.key }
          .from('activerecord.models.task.gender')
          .to('activerecord.models.meeting.gender')
      end
    end
  end
end
