# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Resources::Destroy do
  include ActiveJob::TestHelper

  include_context 'with blog post'

  let(:version) { Schematics::Version.create!(event: 'create', item: resource, user:) }

  before { version }

  after { clear_enqueued_jobs }

  describe '.call' do
    subject(:call) { described_class.call(resource:) }

    it 'destroys the resource' do
      expect { call }
        .to change(BlogPost.with_deleted, :count)
        .by(-1)
    end

    it 'destroys the string translations' do
      expect { call }
        .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation.with_deleted, :count) # rubocop:disable Layout/LineLength
        .by(-5)
    end

    it 'destroys the action texts' do
      expect { call }
        .to change(ActionText::RichText.with_deleted, :count)
        .by(-3)
    end

    it 'destroys the friendly_id slugs' do
      expect { call }
        .to change(FriendlyId::Slug.with_deleted, :count)
        .by(-2)
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

    it 'does not destroy the version to keep it on timeline' do
      expect { call }.not_to change(Schematics::Version, :count)
    end

    it 'purges the image' do
      expect { call }
        .to have_enqueued_job(ActiveStorage::PurgeJob)
        .exactly(:once)
        .with(image)
        .on_queue('cleanups')
        .at(:no_wait)
    end
  end
end
