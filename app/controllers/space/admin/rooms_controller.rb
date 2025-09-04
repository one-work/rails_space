module Space
  class Admin::RoomsController < Admin::BaseController
    before_action :set_station, except: [:all]
    before_action :set_room, only: [:show, :edit, :update, :destroy, :actions, :print_data]
    before_action :set_new_room, only: [:new, :create]

    def index
      @rooms = @station.rooms.page(params[:page])
    end

    def all
      @station = Station.default_where(default_params).first || Station.create(default_params)
      @rooms = Room.default_where(default_params).page(params[:page])
    end

    def print_data
      render json: @room.to_cpcl.bytes
    end

    private
    def set_station
      @station = Station.find params[:station_id]
    end

    def set_room
      @room = @station.rooms.find params[:id]
    end

    def set_new_room
      @room = @station.rooms.build room_params
    end

    def room_params
      params.fetch(:room, {}).permit(
        :name,
        :code,
        :floor
      )
    end
  end
end
