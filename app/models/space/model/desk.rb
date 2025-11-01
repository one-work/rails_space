module Space
  module Model::Desk
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :code, :string
      attribute :width, :integer
      attribute :height, :integer
      attribute :length, :integer
      attribute :counters, :json, default: {}

      belongs_to :room
      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :trade_items, class_name: 'Trade::Item', dependent: :nullify

      before_save :sync_from_room, if: -> { room_id_changed? }
    end

    def sync_from_room
      self.organ_id = room.organ_id
    end

    def content
      [name].compact_blank.join(' ')
    end

    def qr_code
      [code, room.code, room.building&.code, room.station.code].compact.join('-')
    end

    def qrcode_url
      QrcodeHelper.data_url(qr_code)
    end

    def enter_url
      Rails.application.routes.url_for(
        controller: 'space/desks',
        action: 'qrcode',
        id: id,
        host: room.station.organ.host
      )
    end

    def qrcode_enter_url
      QrcodeHelper.data_url(enter_url)
    end

    def product_url
      Rails.application.routes.url_for(
        controller: 'factory/productions',
        desk_id: id,
        host: room.station.organ.host
      )
    end

    def qrcode_product_url
      QrcodeHelper.data_url(product_url)
    end

    def share_info
      r = {
        url: product_url,
        title: "#{organ.name} 提前下单：#{content}"
      }
      if organ.share_logo.attached?
        r.merge!(
          share_logo: organ.share_logo_url,
          debug: organ.debug_enabled
        )
      end
    end

  end
end
