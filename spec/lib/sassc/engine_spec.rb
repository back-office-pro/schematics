# frozen_string_literal: true

require 'sassc/engine'

describe SassC::Engine do
  it_behaves_like 'a monkey patched instance method',
                  :load_paths,
                  'e87ca7a6f97557a2b6ab0d26714439de0de0124bf79561908bc2f24b44d7d356'
end
