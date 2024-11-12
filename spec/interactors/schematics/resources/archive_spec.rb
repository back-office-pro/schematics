# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Resources::Archive do
  include_context 'with blog post'

  let(:version) { Schematics::Version.create!(event: 'create', item: resource, user:) }

  before { version }

  describe '.call' do
    subject(:call) { described_class.call(resource:) }

    it 'archives the resource' do
      expect { call }
        .to change(BlogPost, :count)
        .by(-1)
    end

    it 'archives the string translations' do
      expect { call }
        .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation, :count)
        .by(-5)
    end

    it 'archives the action texts' do
      expect { call }
        .to change(ActionText::RichText, :count)
        .by(-3)
    end

    it 'archives the friendly_id slugs' do
      expect { call }
        .to change(FriendlyId::Slug, :count)
        .by(-2)
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

    it 'destroys the pg_search documents' do
      expect { call }
        .to change(PgSearch::Document, :count)
        .by(-2)
    end

    it 'does not archive the version to keep it on timeline' do
      expect { call }.not_to change(Schematics::Version, :count)
    end

    it 'does not purge the image' do
      expect { call }
        .not_to have_enqueued_job(ActiveStorage::PurgeJob)
        .exactly(:once)
        .with(image)
        .on_queue('cleanups')
        .at(:no_wait)
    end
  end
end
