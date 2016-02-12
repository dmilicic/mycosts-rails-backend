class CostsController < ApplicationController
  include ActionController::Live

  before_action :set_cost, only: [:show, :edit, :update, :destroy]

  # GET /costs
  # GET /costs.json
  def index
    @costs = Cost.all
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


    response.stream.write "data: #{Cost.first.to_json}\n\n"

    start = Time.zone.now
    # Cost.uncached do
    #   Cost.where('created_at > ?', start) do |cost|
    #       response.stream.write "data: #{cost.id}...\n\n"
    #   end
    # end

    response.stream.close
  end

  # POST /costs
  # POST /costs.json
  def create
    @cost = Cost.new(cost_params)

    respond_to do |format|
      if @cost.save
        format.html { redirect_to @cost, notice: 'Cost was successfully created.' }
        format.json { render :show, status: :created, location: @cost }
      else
        format.html { render :new }
        format.json { render json: @cost.errors, status: :unprocessable_entity }
      end
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
      params.require(:cost).permit(:category, :description, :date, :amount, :currency)
    end
end
