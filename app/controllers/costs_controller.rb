class CostsController < ApplicationController
  include ActionController::Live

  protect_from_forgery except: :create

  before_action :set_cost, only: [:show, :edit, :update, :destroy]

  # GET /costs
  # GET /costs.json
  def index
    @costs = Cost.order('created_at DESC').all
  end

  # GET /costs/1
  # GET /costs/1.json
  def show
    render @cost
  end

  # GET /costs/new
  def new
    @cost = Cost.new
  end

  # GET /costs/1/edit
  def edit
  end

  def events
    response.headers["Content-Type"] = "text/event-stream"
    response.headers["Cache-Control"] = "no-cache"

    redis = Redis.new
    redis.subscribe('cost.create') do |on|
      on.message do |event, data|
        response.stream.write "data: #{data}\n\n"
      end
    end

  ensure
    response.stream.close
  end

  # POST /costs
  def create

    # filter parameters
    params = cost_params

    # let's get the user name who sent this requiest
    username = params['user'] || "Anonymous"

    # check if the user exists in the db
    user = User.find_by(name: username)

    # create a new user if it does not exist
    if user.nil?
      user = User.create(name: username)
    end

    # create new cost items based on received params
    @costs = params[:costs].collect { |cost_attributes| Cost.new(cost_attributes) }

    # save each new cost item to the database and notify over Redis
    success = true
    @costs.each do |cost|
      cost.user = user
      success = cost.save && success

      if success
        $redis.publish('cost.create', cost.to_json)
      end
    end

    # send the appropriate response codes
    if success
      head :created
    else
      head :bad_request
    end
  end

  # PATCH/PUT /costs/1
  # PATCH/PUT /costs/1.json
  def update
    respond_to do |format|
      if @cost.update(cost_params)
        format.html { redirect_to @cost, notice: 'Cost was successfully updated.' }
        format.json { render :show, status: :ok, location: @cost }
      else
        format.html { render :edit }
        format.json { render json: @cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /costs/1
  # DELETE /costs/1.json
  def destroy
    @cost.destroy
    respond_to do |format|
      format.html { redirect_to costs_url, notice: 'Cost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost
      @cost = Cost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_params
      params.permit(:user, :costs => [:category, :description, :amount, :date])
    end
end
