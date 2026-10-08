# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Resources::Restore do
  include ActiveJob::TestHelper

  include_context 'with import'

  let(:team) { Team.create!(name_en: 'Team', name_fr: 'Equipe', name_it: 'Squadra') }
  let(:message) do
    Message.create!(subject: 'Foo', content: 'Lorem', author: user, recipients: [user])
  end

  before { [team, message, import].each(&:destroy!) }

  after { clear_enqueued_jobs }

  describe '.call' do
    subject(:call) { described_class.call(resource:) }

    context 'when restoring the message' do
      let(:resource) { message }

      it 'restores the message' do
        expect { call }
          .to change(Message, :count)
          .by(1)
      end

      it 'restores the string translation' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation, :count)
          .by(1)
      end

      it 'restores the action text' do
        expect { call }
          .to change(ActionText::RichText, :count)
          .by(1)
      end

      it 'restores the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug, :count)
          .by(1)
      end

      it 'creates the search index' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(1)
        end
      end
    end

    context 'when restoring the team' do
      let(:resource) { team }

      it 'restores the team' do
        expect { call }
          .to change(Team, :count)
          .by(1)
      end

      it 'restores the string translations' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation, :count)
          .by(5)
      end

      it 'restores the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug, :count)
          .by(1)
      end

      it 'creates the search index' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(1)
        end
      end
    end

    context 'when restoring the import' do
      let(:resource) { import }

      it 'restores the import' do
        expect { call }
          .to change(Import, :count)
          .by(1)
      end

      it 'restores the string translation' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation, :count)
          .by(1)
      end

      it 'restores the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug, :count)
          .by(1)
      end

      it 'restores the active storage attachment' do
        expect { call }
          .to change(ActiveStorage::Attachment, :count)
          .by(1)
      end

      it 'restores the active storage blob' do
        expect { call }
          .to change(ActiveStorage::Blob, :count)
          .by(1)
      end

      it 'creates the search indexes' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(2)
        end
      end

      it 'serves the file' do
        call
        expect(ActiveStorage::Blob.service).to exist(file.key)
      end
    end
  end
end
