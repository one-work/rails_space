module Space
  class Admin::DesksController < Admin::BaseController
    before_action :set_room, except: [:all]
    before_action :set_desk, only: [:show, :edit, :update, :destroy, :actions, :print, :print_data, :print_all]
    before_action :set_new_desk, only: [:new, :create]

    def index
      @desks = @room.desks.includes(room: [:building, :station]).page(params[:page])
    end

    def all
      station = Station.default_where(default_params).first || Station.create(default_params)
      @room = Room.default_where(default_params).first || Room.create(station_id: station.id, **default_params)

      @desks = Desk.default_where(default_params).page(params[:page])
      @item_hash = Trade::Item.default_where(default_params).where.not(desk_id: nil).carting.group(:desk_id).count
      @ordered_hash = Trade::Item.default_where(default_params).where.not(desk_id: nil).status_ordered.group(:desk_id).count
    end

    def print
      @desk.print
    end

    def print_data
      render json: @desk.to_cpcl.bytes
    end

    def print_all
      @desk.print_all
    end

    private
    def set_room
      @room = Room.find params[:room_id]
    end

    def set_desk
      @desk = @room.desks.find params[:id]
    end

    def set_new_desk
      @desk = @room.desks.build desk_params
    end

    def desk_params
      params.fetch(:desk, {}).permit(
        :name,
        :code,
        :width,
        :length,
        :height
      )
    end

  end
end
