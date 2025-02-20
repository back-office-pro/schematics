# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Specs::Dummy do
  subject(:dummy) { described_class.new(extension) }

  context 'when extension is pdf' do
    let(:extension) { :pdf }

    its(:default) { is_expected.to be_a(Rack::Test::UploadedFile) }
    its('default.content_type') { is_expected.to eq('application/pdf') }
    its('default.original_filename') { is_expected.to match(/dummy[\w-]+\.pdf/) }

    its(:json_default) do
      is_expected.to eq(
        {
          'filename' => 'dummy.pdf',
          'content_type' => 'application/pdf',
          'data' => "data:application/pdf;base64,YXBwbGljYXRpb24vcGRm\n"
        }
      )
    end
  end

  context 'when extension is png' do
    let(:extension) { :png }

    its(:default) { is_expected.to be_a(Rack::Test::UploadedFile) }
    its('default.content_type') { is_expected.to eq('image/png') }
    its('default.original_filename') { is_expected.to match(/dummy[\w-]+\.png/) }

    its(:json_default) do
      is_expected.to eq(
        {
          'filename' => 'dummy.png',
          'content_type' => 'image/png',
          'data' => "data:image/png;base64,aW1hZ2UvcG5n\n"
        }
      )
    end
  end
end
