# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Entities::Receptor do
  subject(:receptor) { described_class.new(entity) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) do
    Schematics::Entities::Entity.new(
      schema:,
      name:,
      options:,
      associations:,
      attributes:,
      virtuals:
    )
  end
  let(:name) { 'discussion' }
  let(:options) { {} }
  let(:associations) do
    [
      name: 'participants',
      type: 'has_and_belongs_to_many',
      options: {
        type: 'user'
      }
    ]
  end
  let(:virtuals) do
    [
      name: 'preview',
      function: '$subject'
    ]
  end
  let(:attributes) do
    [
      {
        name: 'subject',
        type: 'string',
        options: {
          readonly: true
        }
      },
      {
        name: 'content',
        type: 'rich_text'
      },
      {
        name: 'record',
        type: 'belongs_to',
        options: {
          polymorphic: true
        }
      }
    ]
  end

  describe '#renderable_elements' do
    subject { receptor.renderable_elements.map(&:name) }

    let(:expected_elements) { %w[id created_at content record participants preview subject] }

    it { is_expected.to match_array(expected_elements) }
  end

  describe '#non_renderable_elements' do
    subject { receptor.non_renderable_elements.map(&:name) }

    it { is_expected.to be_empty }
  end

  describe '#migratable_elements' do
    subject { receptor.migratable_elements.map(&:name) }

    it { is_expected.to contain_exactly('subject', 'record') }
  end

  describe '#non_migratable_elements' do
    subject { receptor.non_migratable_elements.map(&:name) }

    it { is_expected.to contain_exactly('content', 'participants', 'preview') }
  end

  describe '#preloadable_elements' do
    subject { receptor.preloadable_elements.map(&:name) }

    it { is_expected.to contain_exactly('content', 'record', 'participants', 'preview', 'subject') }
  end

  describe '#non_preloadable_elements' do
    subject { receptor.non_preloadable_elements.map(&:name) }

    it { is_expected.to contain_exactly('id', 'created_at') }
  end

  describe '#listable_elements' do
    subject { receptor.listable_elements.map(&:name) }

    it { is_expected.to contain_exactly('created_at', 'record', 'preview', 'subject') }
  end

  describe '#non_listable_elements' do
    subject { receptor.non_listable_elements.map(&:name) }

    it { is_expected.to contain_exactly('id', 'content', 'participants') }
  end

  describe '#searchable_elements' do
    subject { receptor.searchable_elements.map(&:name) }

    it { is_expected.to contain_exactly('created_at', 'content', 'record', 'preview', 'subject') }
  end

  describe '#non_searchable_elements' do
    subject { receptor.non_searchable_elements.map(&:name) }

    it { is_expected.to contain_exactly('id', 'participants') }
  end

  describe '#fillable_elements' do
    subject { receptor.fillable_elements.map(&:name) }

    it { is_expected.to contain_exactly('content', 'record', 'participants') }
  end

  describe '#validatable_elements' do
    subject { receptor.validatable_elements.map(&:name) }

    let(:expected_elements) { %w[id created_at content record participants subject] }

    it { is_expected.to match_array(expected_elements) }
  end

  describe '#non_validatable_elements' do
    subject { receptor.non_validatable_elements.map(&:name) }

    it { is_expected.to contain_exactly('preview') }
  end

  describe '#renderable_attributes' do
    subject { receptor.renderable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('id', 'created_at', 'content', 'record', 'subject') }
  end

  describe '#non_renderable_attributes' do
    subject { receptor.non_renderable_attributes.map(&:name) }

    it { is_expected.to be_empty }
  end

  describe '#migratable_attributes' do
    subject { receptor.migratable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('subject', 'record') }
  end

  describe '#non_migratable_attributes' do
    subject { receptor.non_migratable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('content') }
  end

  describe '#preloadable_attributes' do
    subject { receptor.preloadable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('content', 'record', 'subject') }
  end

  describe '#non_preloadable_attributes' do
    subject { receptor.non_preloadable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('id', 'created_at') }
  end

  describe '#listable_attributes' do
    subject { receptor.listable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('created_at', 'record', 'subject') }
  end

  describe '#non_listable_attributes' do
    subject { receptor.non_listable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('id', 'content') }
  end

  describe '#searchable_attributes' do
    subject { receptor.searchable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('created_at', 'content', 'record', 'subject') }
  end

  describe '#non_searchable_attributes' do
    subject { receptor.non_searchable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('id') }
  end

  describe '#fillable_attributes' do
    subject { receptor.fillable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('content', 'record') }
  end

  describe '#validatable_attributes' do
    subject { receptor.validatable_attributes.map(&:name) }

    it { is_expected.to contain_exactly('id', 'created_at', 'content', 'record', 'subject') }
  end

  describe '#non_validatable_attributes' do
    subject { receptor.non_validatable_attributes.map(&:name) }

    it { is_expected.to be_empty }
  end

  describe '#renderable_associations' do
    subject { receptor.renderable_associations.map(&:name) }

    it { is_expected.to contain_exactly('participants') }
  end

  describe '#non_renderable_associations' do
    subject { receptor.non_renderable_associations.map(&:name) }

    it { is_expected.to be_empty }
  end

  describe '#migratable_associations' do
    subject { receptor.migratable_associations.map(&:name) }

    it { is_expected.to be_empty }
  end

  describe '#non_migratable_associations' do
    subject { receptor.non_migratable_associations.map(&:name) }

    it { is_expected.to contain_exactly('participants') }
  end

  describe '#preloadable_associations' do
    subject { receptor.preloadable_associations.map(&:name) }

    it { is_expected.to contain_exactly('participants') }
  end

  describe '#non_preloadable_associations' do
    subject { receptor.non_preloadable_associations.map(&:name) }

    it { is_expected.to be_empty }
  end

  describe '#listable_associations' do
    subject { receptor.listable_associations.map(&:name) }

    it { is_expected.to be_empty }
  end

  describe '#non_listable_associations' do
    subject { receptor.non_listable_associations.map(&:name) }

    it { is_expected.to contain_exactly('participants') }
  end

  describe '#searchable_associations' do
    subject { receptor.searchable_associations.map(&:name) }

    it { is_expected.to be_empty }
  end

  describe '#non_searchable_associations' do
    subject { receptor.non_searchable_associations.map(&:name) }

    it { is_expected.to contain_exactly('participants') }
  end

  describe '#fillable_associations' do
    subject { receptor.fillable_associations.map(&:name) }

    it { is_expected.to contain_exactly('participants') }
  end

  describe '#validatable_associations' do
    subject { receptor.validatable_associations.map(&:name) }

    it { is_expected.to contain_exactly('participants') }
  end

  describe '#non_validatable_associations' do
    subject { receptor.non_validatable_associations.map(&:name) }

    it { is_expected.to be_empty }
  end

  context 'when entity has a parent' do
    let(:options) { { parent: 'team' } }

    describe '#renderable_elements' do
      subject { receptor.renderable_elements.map(&:name) }

      let(:expected_elements) do
        %w[
          id
          created_at
          content
          record
          participants
          preview
          subject
          name
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_elements) }
    end

    describe '#non_renderable_elements' do
      subject { receptor.non_renderable_elements.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#migratable_elements' do
      subject { receptor.migratable_elements.map(&:name) }

      it { is_expected.to contain_exactly('subject', 'record', 'name') }
    end

    describe '#non_migratable_elements' do
      subject { receptor.non_migratable_elements.map(&:name) }

      let(:expected_elements) do
        %w[
          content
          meetings
          participants
          preview
          record_comments
          record_drafts
          record_emailings
          tasks
          users
        ]
      end

      it { is_expected.to match_array(expected_elements) }
    end

    describe '#preloadable_elements' do
      subject { receptor.preloadable_elements.map(&:name) }

      let(:expected_elements) do
        %w[
          content
          record
          participants
          preview
          subject
          name
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_elements) }
    end

    describe '#non_preloadable_elements' do
      subject { receptor.non_preloadable_elements.map(&:name) }

      it { is_expected.to contain_exactly('id', 'created_at') }
    end

    describe '#listable_elements' do
      subject { receptor.listable_elements.map(&:name) }

      it { is_expected.to contain_exactly('created_at', 'record', 'preview', 'subject', 'name') }
    end

    describe '#non_listable_elements' do
      subject { receptor.non_listable_elements.map(&:name) }

      let(:expected_elements) do
        %w[
          id
          content
          participants
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_elements) }
    end

    describe '#searchable_elements' do
      subject { receptor.searchable_elements.map(&:name) }

      let(:expected_elements) do
        %w[
          created_at
          content
          record
          preview
          subject
          name
        ]
      end

      it { is_expected.to match_array(expected_elements) }
    end

    describe '#non_searchable_elements' do
      subject { receptor.non_searchable_elements.map(&:name) }

      let(:expected_elements) do
        %w[
          id
          participants
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_elements) }
    end

    describe '#fillable_elements' do
      subject { receptor.fillable_elements.map(&:name) }

      it { is_expected.to contain_exactly('content', 'record', 'participants', 'name') }
    end

    describe '#validatable_elements' do
      subject { receptor.validatable_elements.map(&:name) }

      let(:expected_elements) do
        %w[
          id
          created_at
          content
          record
          participants
          subject
          meetings
          name
          tasks
          users
        ]
      end

      it { is_expected.to match_array(expected_elements) }
    end

    describe '#non_validatable_elements' do
      subject { receptor.non_validatable_elements.map(&:name) }

      let(:expected_elements) do
        %w[
          preview
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_elements) }
    end

    describe '#renderable_attributes' do
      subject { receptor.renderable_attributes.map(&:name) }

      let(:expected_attributes) do
        %w[
          id
          created_at
          content
          record
          subject
          name
        ]
      end

      it { is_expected.to match_array(expected_attributes) }
    end

    describe '#non_renderable_attributes' do
      subject { receptor.non_renderable_attributes.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#migratable_attributes' do
      subject { receptor.migratable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('subject', 'record', 'name') }
    end

    describe '#non_migratable_attributes' do
      subject { receptor.non_migratable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('content') }
    end

    describe '#preloadable_attributes' do
      subject { receptor.preloadable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('content', 'record', 'subject', 'name') }
    end

    describe '#non_preloadable_attributes' do
      subject { receptor.non_preloadable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('id', 'created_at') }
    end

    describe '#listable_attributes' do
      subject { receptor.listable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('created_at', 'record', 'subject', 'name') }
    end

    describe '#non_listable_attributes' do
      subject { receptor.non_listable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('id', 'content') }
    end

    describe '#searchable_attributes' do
      subject { receptor.searchable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('created_at', 'content', 'record', 'subject', 'name') }
    end

    describe '#non_searchable_attributes' do
      subject { receptor.non_searchable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('id') }
    end

    describe '#fillable_attributes' do
      subject { receptor.fillable_attributes.map(&:name) }

      it { is_expected.to contain_exactly('content', 'record', 'name') }
    end

    describe '#validatable_attributes' do
      subject { receptor.validatable_attributes.map(&:name) }

      let(:expected_attributes) do
        %w[
          id
          created_at
          content
          record
          subject
          name
        ]
      end

      it { is_expected.to match_array(expected_attributes) }
    end

    describe '#non_validatable_attributes' do
      subject { receptor.non_validatable_attributes.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#renderable_associations' do
      subject { receptor.renderable_associations.map(&:name) }

      let(:expected_associations) do
        %w[
          participants
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_associations) }
    end

    describe '#non_renderable_associations' do
      subject { receptor.non_renderable_associations.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#migratable_associations' do
      subject { receptor.migratable_associations.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#non_migratable_associations' do
      subject { receptor.non_migratable_associations.map(&:name) }

      let(:expected_associations) do
        %w[
          meetings
          participants
          record_comments
          record_drafts
          record_emailings
          tasks
          users
        ]
      end

      it { is_expected.to match_array(expected_associations) }
    end

    describe '#preloadable_associations' do
      subject { receptor.preloadable_associations.map(&:name) }

      let(:expected_associations) do
        %w[
          participants
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_associations) }
    end

    describe '#non_preloadable_associations' do
      subject { receptor.non_preloadable_associations.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#listable_associations' do
      subject { receptor.listable_associations.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#non_listable_associations' do
      subject { receptor.non_listable_associations.map(&:name) }

      let(:expected_associations) do
        %w[
          participants
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_associations) }
    end

    describe '#searchable_associations' do
      subject { receptor.searchable_associations.map(&:name) }

      it { is_expected.to be_empty }
    end

    describe '#non_searchable_associations' do
      subject { receptor.non_searchable_associations.map(&:name) }

      let(:expected_associations) do
        %w[
          participants
          record_comments
          record_drafts
          record_emailings
        ]
      end

      it { is_expected.to match_array(expected_associations) }
    end

    describe '#fillable_associations' do
      subject { receptor.fillable_associations.map(&:name) }

      it { is_expected.to contain_exactly('participants') }
    end

    describe '#validatable_associations' do
      subject { receptor.validatable_associations.map(&:name) }

      it { is_expected.to contain_exactly('participants', 'meetings', 'tasks', 'users') }
    end

    describe '#non_validatable_associations' do
      subject { receptor.non_validatable_associations.map(&:name) }

      it { is_expected.to contain_exactly('record_drafts', 'record_comments', 'record_emailings') }
    end
  end
end
