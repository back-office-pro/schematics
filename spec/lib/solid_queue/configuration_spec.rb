# frozen_string_literal: true

require 'active_model'
require 'solid_queue/configuration'

describe SolidQueue::Configuration do
  it_behaves_like 'a monkey patched instance method',
                  :processes_config,
                  'ca536e94f8028d8cbb1992ec48396e409b17545380d42ed8a3a7d455aff679fa'

  it_behaves_like 'a monkey patched instance method',
                  :recurring_tasks_config,
                  '8335e80b55a963002c26201ceab5eb97983a52efb3b918eb71ba5e8dc49fde44'
end
