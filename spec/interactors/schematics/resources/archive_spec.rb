# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Resources::Archive do
  include_context 'with user'

  let(:resource) do
    BlogPost.create!(
      title_en: 'My title',
      title_fr: 'Mon titre',
      title_it: 'Il mio titolo',
      content_en: 'My content',
      content_fr: 'Mon contenu',
      content_it: 'Il mio contenuto',
      image:,
      author: user
    )
  end
  let(:image) do
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(file_fixture('logo.png'), 'rb'),
      filename: 'logo.png',
      content_type: Mime[:png].to_s
    ).signed_id
  end
  let(:version) { Schematics::Version.create!(event: 'create', item: resource, user:) }

  before do
    resource
    resource.update!(
      title_en: 'My new title',
      title_fr: 'Mon nouveau titre',
      title_it: 'Il mio nuovo titolo'
    )
    version
  end

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

    it 'does not archive the version to keep it on timeline' do
      expect { call }.not_to change(Schematics::Version, :count)
    end
  end
end
