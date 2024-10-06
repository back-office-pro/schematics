# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Resources::Restore do
  include_context 'with blog post'

  before { resource.destroy! }

  describe '.call' do
    subject(:call) { described_class.call(resource:) }

    it 'restores the resource' do
      expect { call }
        .to change(BlogPost, :count)
        .by(1)
    end

    it 'restores the string translations' do
      expect { call }
        .to change(Mobility::Backends::ActiveRecord::KeyValue::StringTranslation, :count)
        .by(5)
    end

    it 'restores the action texts' do
      expect { call }
        .to change(ActionText::RichText, :count)
        .by(3)
    end

    it 'restores the friendly_id slugs' do
      expect { call }
        .to change(FriendlyId::Slug, :count)
        .by(2)
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

    it 'serves the image' do
      call
      expect(ActiveStorage::Blob.service).to exist(image.key)
    end
  end
end
