class Api::V1::RoutesController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
  before_action :set_route, only: [:show, :update, :destroy, :favorite]
  # after_action :set_route, only: [:create]
  before_action :set_current_user, only: [:favorite, :show]


  def favorite
    # @current_user = User.find(params[:user_id])
    # @building = Building.find(params[:id])
    if @current_user.favorited?(@route) == false
      puts "params.... #{params}"
      # @current_user = User.find(params["favoritor_id"].to_i)
      puts "@current_user .. #{@current_user}"
      # @building = Building.find(params[:favoritable_id])
      @current_user.favorite(@route)
      render json: {
        msg: "ok"
      }
    else
      puts "params.... #{params}"
      # @current_user = User.find(params["favoritor_id"].to_i)
      puts "@current_user .. #{@current_user}"
      # @building = Building.find(params[:favoritable_id])
      @current_user.unfavorite(@route)
      render json: {
        msg: "ok"
      }
    end
  end


  def index
    @user_signed_in = set_current_user
    if params[:query].present?
      @routes = Route.global_search(params[:query])
    else
      @routes = Route.order(:name)
    end
  end

  def update
    if @route.update(route_params)
      render :show
    else
      render_errors
    end
  end

  def create
    p route_params
    @route = Route.new(route_params)

    if @route.save
      p @route
      render :show, status: :created
    else
      render_errors
    end
  end

  def show
  end

  def destroy
    @route.destroy
    head :no_content
  end

  private

  def set_current_user
    if params[:user_id]
      @current_user = User.find(params[:user_id])
    else
      return false
    end
  end

  def set_route
    @route = Route.find(params[:id])
    # @user = @route.user
  end

  def render_errors
    render json: { errors: @route.errors.full_messages }
  end

  def route_params
    params.require(:route).permit(:id, :approximate_duration, :approximate_distance, :user_id, :start_long, :start_lat, :end_long, :end_lat, :radius_search, :main_picture, :district, :favoritable_score, :favoritable_total, :name, :metro_station_stop, :metro_station_start, :description)
  end
end
