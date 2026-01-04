module Space
  module Model::Grid
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :code, :string
      attribute :width, :integer
      attribute :height, :integer
      attribute :length, :integer
      attribute :floor, :integer

      belongs_to :room

      has_many :production_items, class_name: 'Factory::ProductionItem', dependent: :nullify
    end

    def qr_code
      [
        code,
        room.code,
        room.building&.code,
        room.station.code
      ].compact.join('-')
    end

    def qrcode_url
      QrcodeUtil.data_url(qr_code)
    end

    def enter_url
      Rails.application.routes.url_for(controller: 'space/grids', action: 'qrcode', id: id)
    end

    def qrcode_enter_url
      QrcodeUtil.data_url(enter_url)
    end

  end
end
