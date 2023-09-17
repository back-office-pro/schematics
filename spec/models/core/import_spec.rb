# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import do
  include Schematics::Specs::Model

  its(:model_class) { is_expected.to eq(User) }

  describe '#finalize!' do
    subject(:finalize!) { record.finalize!(errors) }

    context 'when there is no import error' do
      let(:errors) { nil }

      it 'changes import state from in_progress to finished' do
        expect { finalize! }
          .to change(record, :state)
          .from('in_progress')
          .to('finished')
      end
    end

    context 'when there are import errors' do
      let(:errors) { { 'Line 1' => 'Name already taken' } }

      it 'changes import state from in_progress to error' do
        expect { finalize! }
          .to change(record, :state)
          .from('in_progress')
          .to('error')
      end

      it 'stores import errors' do
        expect { finalize! }
          .to change(record, :import_errors)
          .from({})
          .to(errors)
      end
    end
  end
end
