class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[ show edit update destroy ]
  before_action :set_page_title

  # GET /transactions or /transactions.json
  def index
    @transactions_by_date = current_user.transactions.recent.includes(:category).group_by(&:date)
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = current_user.transactions.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = current_user.transactions.new(transaction_params)

    if @transaction.save
      redirect_to transactions_path, notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: "Transaction was successfully updated.", status: :see_other
    else
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
      params.require(:transaction).permit(:amount, :description, :time, :date, :category_id)
    end
end
