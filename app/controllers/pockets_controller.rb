class PocketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pocket, only: [:show, :edit, :update, :destroy, :adjust_balance]
  before_action :set_page_title

  def index
    @pockets = current_user.pockets
  end

  def show
    @transactions = Transaction.where("source_pocket_id = ? OR destination_pocket_id = ?", @pocket.id, @pocket.id)
                               .recent.limit(20).includes(:category)
    @adjustments = @pocket.balance_adjustments.recent.limit(10)
  end

  def new
    @pocket = current_user.pockets.new
  end

  def edit
  end

  def create
    @pocket = current_user.pockets.new(pocket_params)
    if @pocket.save
      redirect_to pockets_path, notice: "Kantong berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @pocket.update(pocket_params)
      redirect_to pockets_path, notice: "Kantong berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def adjust_balance
    if params[:zero_balance] == "1"
      target = 0
    else
      target = params[:target_balance].to_d
    end

    if @pocket.adjust_balance!(target, current_user, note: params[:note])
      redirect_to pocket_path(@pocket), notice: "Saldo berhasil disesuaikan."
    else
      redirect_to pocket_path(@pocket), alert: "Gagal menyesuaikan saldo."
    end
  end

  def destroy
    if @pocket.destroy
      redirect_to pockets_path, notice: "Kantong berhasil dihapus."
    else
      redirect_to pockets_path, alert: "Kantong gagal dihapus karena masih ada transaksi."
    end
  end

  private

  def set_pocket
    @pocket = current_user.pockets.find(params[:id])
  end

  def set_page_title
    @page_title = "Kantong Saya"
  end

  def pocket_params
    params.require(:pocket).permit(:name, :icon, :color)
  end
end
