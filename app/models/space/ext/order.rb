module Space
  module Ext::Order
    extend ActiveSupport::Concern

    included do
      belongs_to :desk, class_name: 'Space::Desk', optional: true
      belongs_to :station, class_name: 'Space::Station', optional: true

      after_create :increment_counts_to_desk
      after_destroy :decrement_counts_to_desk
    end

    def increment_counts_to_desk
      desk.update_json_counter(amount: amount, count: 1)
    end

    def decrement_counts_to_desk
      desk.update_json_counter(amount: -amount, count: -1)
    end

  end
end
