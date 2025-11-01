module Space
  module Ext::Order
    extend ActiveSupport::Concern

    included do
      belongs_to :desk, class_name: 'Space::Desk', optional: true
      belongs_to :station, class_name: 'Space::Station', optional: true

      after_save :update_counters_to_desk, if: -> { desk_id.present? && saved_change_to_unreceived_amount? }
      after_create :increment_counts_to_desk, if: -> { desk_id.present? }
      after_destroy :decrement_counts_to_desk, if: -> { desk_id.present? }
    end

    def update_counters_to_desk
      return unless desk
      r = unreceived_amount - unreceived_amount_before_last_save
      desk.update_json_counter(unreceived_amount: r)
    end

    def increment_counts_to_desk
      return unless desk
      desk.update_json_counter(count: 1, unreceived_amount: unreceived_amount)
    end

    def decrement_counts_to_desk
      return unless desk
      desk.update_json_counter(count: -1)
    end

  end
end
