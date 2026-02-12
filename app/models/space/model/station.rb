module Space
  module Model::Station
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :code, :string
      attribute :detail, :string
      attribute :buildings_count, :integer, default: 0
      attribute :rooms_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :area, class_name: 'Ship::Area', optional: true
      has_taxons :area

      has_many :buildings, dependent: :destroy_async
      has_many :rooms, dependent: :destroy_async
      has_many :desks, through: :rooms

      has_one_attached :logo
    end

    def content
      [area.full_name, detail].compact_blank.join(' ')
    end

    def product_url
      Rails.app.routes.url_for(
        controller: 'factory/productions',
        station_id: id,
        host: organ.host
      )
    end

    def qrcode_product_url
      QrcodeUtil.data_url(product_url)
    end

  end
end
