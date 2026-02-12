module Space
  module Model::Room
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :code, :string
      attribute :floor, :integer
      attribute :grids_count, :integer, default: 0

      belongs_to :station, counter_cache: true
      belongs_to :building, optional: true
      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :grids, dependent: :destroy_async
      has_many :desks, dependent: :destroy_async
      has_many :production_items, class_name: 'Factory::ProductionItem', dependent: :nullify

      before_save :sync_from_station, if: -> { station_id_changed? }
    end

    def sync_from_station
      self.organ_id = station.organ_id
    end

    def enter_url
      Rails.app.routes.url_for(
        controller: 'space/rooms',
        action: 'qrcode',
        id: id
      )
    end

    def qrcode_enter_url
      QrcodeUtil.data_url(enter_url)
    end

  end
end
