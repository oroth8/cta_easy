class ArrivalsController < ApplicationController
  # before_action :require_authorization
  # before_action :set_arrival, only: %i[show edit update destroy]

  # GET /arrivals or /arrivals.json
  def index
    @arrivals = Arrival.all
  end

  # GET /arrivals/1 or /arrivals/1.json
  def show

    @arrival = CtaClient.new.arrivals(params[:id])
    respond_to do |format|
      format.json { render json: @arrival }
      format.html { render :show }
    end
   
  end

  # GET /arrivals/1/edit
  def edit; end

  # POST /arrivals or /arrivals.json
  def create
    @arrival = Arrival.new(arrival_params)

    respond_to do |_format|
      if @arrival.save
        render :show, status: :created, location: @arrival
      else
        render json: @arrival.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /arrivals/1 or /arrivals/1.json
  def update
    respond_to do |_format|
      if @arrival.update(arrival_params)
        render :show, status: :ok, location: @arrival
      else
        render json: @arrival.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /arrivals/1 or /arrivals/1.json
  def destroy
    @arrival.destroy

    respond_to do |_format|
      head :no_content
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_arrival
    @arrival = Arrival.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def arrival_params
    params.fetch(:arrival, {})
  end

  def require_authorization
    if request.headers.fetch("Authorization").split(" ").last != "api_key"
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
