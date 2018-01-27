class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json
  add_flash_types :success, :warning, :danger, :info

  def get_item
    if params[:id].present?
      @item = Item.find(params[:id])
      @data = Hash.new
      @data["name"] = @item.name
      render json: Item.find(params[:id]).to_json
    end
  end
  
  def calculate_amount
    if params[:interval].present? && params[:item].present? && params[:amount].present?
      @item = Item.find(params[:item])
      @interval = Interval.find(params[:interval])
      @multiplier = Rational(@interval.numerator, @interval.denominator)
      @data = Hash.new
      @calculated = @multiplier * params[:amount].to_f
      Item.where(:parent_id => @item.id).each do |child| 
        @calculated += child.amount_calculated
      end
      @data["amount_calculated"] = @calculated.round(2)
      render json: @data and return false
     end  
  end
  
  
  # GET /items
  # GET /items.json
  def index
    respond_to do |format|
    format.html
    format.json { render json: ItemsDatatable.new(view_context) }
    end
  end
  
    # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def import
    Item.import(params[:file])
    redirect_to items_path, notice: "Item data imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:order_id, :name, :total_amount, :amount_calculated, :reserve, :maturity, :active, :category_id, :interval_id, :key_words, :account_id, :external_account, :budget, :savings_id, :parent_id)
    end
end






