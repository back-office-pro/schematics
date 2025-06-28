# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Resources::Destroy do
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
    allow(ActiveRecord::Base).to receive(:lock_optimistically).and_return(false)
  end

  after { clear_enqueued_jobs }

  describe '.call' do
    subject(:call) { described_class.call(resource:) }

    context 'when destroying the message' do
      let(:resource) { message }

      it 'destroys the message' do
        expect { call }
          .to change(Message.with_deleted, :count)
          .by(-1)
      end

      it 'destroys the string translation' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation.with_deleted, :count) # rubocop:disable Layout/LineLength
          .by(-1)
      end

      it 'destroys the action text' do
        expect { call }
          .to change(ActionText::RichText.with_deleted, :count)
          .by(-1)
      end

      it 'destroys the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug.with_deleted, :count)
          .by(-1)
      end

      it 'destroys the search index' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(-1)
        end
      end

      it 'does not destroy the version to keep it on timeline' do
        expect { call }.not_to change(Schematics::Version, :count)
      end
    end

    context 'when destroying the team' do
      let(:resource) { team }

      it 'destroys the team' do
        expect { call }
          .to change(Team.with_deleted, :count)
          .by(-1)
      end

      it 'destroys the string translations' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation.with_deleted, :count) # rubocop:disable Layout/LineLength
          .by(-5)
      end

      it 'destroys the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug.with_deleted, :count)
          .by(-1)
      end

      it 'destroys the search index' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(-1)
        end
      end

      it 'does not destroy the version to keep it on timeline' do
        expect { call }.not_to change(Schematics::Version, :count)
      end
    end

    context 'when destroying the import' do
      let(:resource) { import }

      it 'destroys the import' do
        expect { call }
          .to change(Import.with_deleted, :count)
          .by(-1)
      end

      it 'destroys the string translation' do
        expect { call }
          .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation.with_deleted, :count) # rubocop:disable Layout/LineLength
          .by(-1)
      end

      it 'destroys the friendly_id slug' do
        expect { call }
          .to change(FriendlyId::Slug.with_deleted, :count)
          .by(-1)
      end

      it 'destroys the active storage attachment' do
        expect { call }
          .to change(ActiveStorage::Attachment.with_deleted, :count)
          .by(-1)
      end

      it 'destroys the active storage blob' do
        perform_enqueued_jobs do
          expect { call }
            .to change(ActiveStorage::Blob.with_deleted, :count)
            .by(-1)
        end
      end

      it 'destroys the search indexes' do
        perform_enqueued_jobs do
          expect { call }
            .to change(Schematics::SearchIndex, :count)
            .by(-2)
        end
      end

      it 'does not destroy the version to keep it on timeline' do
        expect { call }.not_to change(Schematics::Version, :count)
      end

      it 'purges the file' do
        expect { call }
          .to have_enqueued_job(ActiveStorage::PurgeJob)
          .exactly(:once)
          .with(:default, file.id)
          .on_queue('low')
          .at(:no_wait)
      end
    end
  end
end
