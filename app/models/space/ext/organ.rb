module Space
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      attribute :desks_count, :integer, default: 0

      has_many :desks, class_name: 'Space::Desk'
    end

  end
end
