# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Resources::Archive do
  include ActiveJob::TestHelper

  include_context 'with import'

  let(:team) { Team.create!(name_en: 'Team', name_fr: 'Equipe', name_it: 'Squadra') }
  let(:message) do
    Message.create!(subject: 'Foo', content: 'Lorem', author: user, recipients: [user])
  end
  let(:versions) do
    Schematics::Version.create!(
      [
        { event: 'create', item: import, user: },
        { event: 'create', item: team, user: },
        { event: 'create', item: message, user: }
      ]
    )
  end

  before do
    versions
    [team, message, import, file].each(&:create_search_index)
  end

  describe '.call' do
    subject(:call) { described_class.call(resource:) }

    context 'when archiving the message' do
      let(:resource) { message }

      it 'archives the message' do
        expect { call }
          .to change(Message, :count)
          .by(-1)
      end

      it 'archives the string translation' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation, :count)
          .by(-1)
      end

      it 'archives the action text' do
        expect { call }
          .to change(ActionText::RichText, :count)
          .by(-1)
      end

      it 'archives the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug, :count)
          .by(-1)
      end

      it 'destroys the search index' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(-1)
        end
      end

      it 'does not archive the version to keep it on timeline' do
        expect { call }.not_to change(Schematics::Version, :count)
      end
    end

    context 'when archiving the team' do
      let(:resource) { team }

      it 'archives the team' do
        expect { call }
          .to change(Team, :count)
          .by(-1)
      end

      it 'archives the string translations' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation, :count)
          .by(-5)
      end

      it 'archives the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug, :count)
          .by(-1)
      end

      it 'destroys the search index' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(-1)
        end
      end

      it 'does not archive the version to keep it on timeline' do
        expect { call }.not_to change(Schematics::Version, :count)
      end
    end

    context 'when archiving the import' do
      let(:resource) { import }

      it 'archives the import' do
        expect { call }
          .to change(Import, :count)
          .by(-1)
      end

      it 'archives the string translation' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation, :count)
          .by(-1)
      end

      it 'archives the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug, :count)
          .by(-1)
      end

      it 'archives the active storage attachment' do
        expect { call }
          .to change(ActiveStorage::Attachment, :count)
          .by(-1)
      end

      it 'archives the active storage blob' do
        expect { call }
          .to change(ActiveStorage::Blob, :count)
          .by(-1)
      end

      it 'destroys the search indexes' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(-2)
        end
      end

      it 'does not archive the version to keep it on timeline' do
        expect { call }.not_to change(Schematics::Version, :count)
      end

      it 'does not purge the file' do
        expect { call }
          .not_to have_enqueued_job(ActiveStorage::PurgeJob)
          .exactly(:once)
          .with(file)
          .on_queue('low')
          .at(:no_wait)
      end
    end
  end
end
