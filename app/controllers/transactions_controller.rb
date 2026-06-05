class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :set_page_title

  # GET /transactions or /transactions.json
  def index
    @transactions_by_date = current_user.transactions.recent.includes(:category, :source_pocket, :destination_pocket).group_by(&:date)
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = current_user.transactions.new
    load_form_data
  end

  # GET /transactions/1/edit
  def edit
    load_form_data
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = current_user.transactions.new(transaction_params)
    handle_tarik_tunai if tarik_tunai?

    if @transaction.save
      redirect_to transactions_path, notice: "Transaction was successfully created."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    # Need to build a temporary transaction to check tarik tunai before save
    @transaction.assign_attributes(transaction_params)
    handle_tarik_tunai if tarik_tunai?
    
    if @transaction.save
      redirect_to transactions_path, notice: "Transaction was successfully updated.", status: :see_other
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy!
    redirect_to transactions_path, notice: "Transaction was successfully destroyed.", status: :see_other
  end

  private
    def set_page_title
      @page_title = "My Transactions"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = current_user.transactions.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(
        :amount, :description, :time, :date, 
        :category_id, :transaction_type, 
        :source_pocket_id, :destination_pocket_id
      )
    end
    
    def load_form_data
      @pockets = current_user.pockets
      @expense_categories = current_user.categories.expense
      @income_categories = current_user.categories.income
      @transfer_categories = current_user.categories.transfer
    end
    
    def tarik_tunai?
      @transaction.transfer? &&
        @transaction.category_id.present? &&
        Category.find_by(id: @transaction.category_id)&.name == "Tarik Tunai"
    end

    def handle_tarik_tunai
      cash_pocket = current_user.pockets.find_by(name: "Cash")
      @transaction.destination_pocket = cash_pocket if cash_pocket
    end
end
