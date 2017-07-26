class FinanceStatesController < ApplicationController
  before_action :set_finance_state, only: [:show, :edit, :update, :destroy]

  # GET /finance_states
  # GET /finance_states.json
  def index
    @finance_states = FinanceState.all
  end

  # GET /finance_states/1
  # GET /finance_states/1.json
  def show
  end

  # GET /finance_states/new
  def new
    @finance_state = FinanceState.new
  end

  # GET /finance_states/1/edit
  def edit
  end

  # POST /finance_states
  # POST /finance_states.json
  def create
    @finance_state = FinanceState.new(finance_state_params)

    respond_to do |format|
      if @finance_state.save
        format.html { redirect_to @finance_state, notice: 'Finance state was successfully created.' }
        format.json { render :show, status: :created, location: @finance_state }
      else
        format.html { render :new }
        format.json { render json: @finance_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finance_states/1
  # PATCH/PUT /finance_states/1.json
  def update
    respond_to do |format|
      if @finance_state.update(finance_state_params)
        format.html { redirect_to @finance_state, notice: 'Finance state was successfully updated.' }
        format.json { render :show, status: :ok, location: @finance_state }
      else
        format.html { render :edit }
        format.json { render json: @finance_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finance_states/1
  # DELETE /finance_states/1.json
  def destroy
    @finance_state.destroy
    respond_to do |format|
      format.html { redirect_to finance_states_url, notice: 'Finance state was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_finance_state
      @finance_state = FinanceState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def finance_state_params
      params.require(:finance_state).permit(:period, :hibiscus_sync_id, :balance, :account_id)
    end
end
