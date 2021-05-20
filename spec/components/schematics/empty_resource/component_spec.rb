require 'rails_helper'

RSpec.describe Schematics::EmptyResource::Component, type: :component do
  subject { render_inline(component) }

  let(:component) { described_class.new }
  let(:title) { component.translate('.title') }

  it { is_expected.to have_selector('h4', text: title) }
end
