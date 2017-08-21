class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json
  add_flash_types :success, :warning, :danger, :info

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
    #@item.calculate_planned_value
    @item = Item.find(params[:id])
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    #@item.calculate_planned_value
    @item = Item.find(params[:id])
    
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        #@item.calculate_planned_value
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
            #attrs = ["interval_id", "total_amount"]
    #if (@item.changed & attrs).any?
      puts " !!!  Whooooooooooops"
      #@item.update(amount_calculated: @item.calculate_planned_value)
      @item.calculate_planned_value
      #redirect_back(fallback_location: root_path, info: 'amount_calculated updated to: ' + @item.amount_calculated.to_s)
      #redirect_to :back, 
      
    #end
        format.html { redirect_back(fallback_location: root_path, info: 'amount_calculated updated to: ' + @item.amount_calculated.to_s) }
          #redirect_to @item, notice: 'Item was successfully updated.'}
        format.json { respond_with_bip(@item) }
        #format.json { render :show, status: :ok, location: @item }
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
      params.require(:item).permit(:order_id, :name, :total_amount, :amount_calculated, :reserve, :maturity, :active, :category_id, :interval_id, :key_words)
    end
end
