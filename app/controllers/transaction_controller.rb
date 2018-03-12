class TransactionController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    @transaction = Transaction.find(params[:id])
  end

  # GET /accounts/new
  def new
    @transaction = Transaction.new  #(:user_id => current_user.id)
  end

  # GET /accounts/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.json
  def create
    
    @transaction = Transaction.new(account_params)
    #@account.user_id = current_user.id
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @transaction.update(account_params)
        format.html { redirect_to @transaction, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:transaction).permit(:account_id, :monthly_statistic_id)
    end
  
  
end
