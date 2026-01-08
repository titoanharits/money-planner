# app/controllers/onboarding_controller.rb
class OnboardingController < ApplicationController
  before_action :authenticate_user!
  # Mencegah user yang sudah setup untuk masuk lagi ke halaman onboarding
  before_action :redirect_if_onboarded, only: [:start, :generate]

  def start
    @page_title = "Welcome to Money Planner"
    # Action ini hanya merender form (halaman starter)
  end

  def generate
    income = params[:income]
    profile = params[:profile]

    if income.present? && profile.present?
      service = BudgetGeneratorService.new(current_user, income, profile)
      
      if service.call
        redirect_to root_path, notice: "Rencana keuangan Anda berhasil dibuat! Selamat mengelola uang."
      else
        flash.now[:alert] = "Gagal membuat kategori otomatis. Silakan coba lagi."
        render :start, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Mohon isi semua data yang diperlukan."
      render :start, status: :unprocessable_entity
    end
  end

  private

  def redirect_if_onboarded
    # Cek method needs_onboarding? yang kita buat di model User
    unless current_user.needs_onboarding?
      redirect_to root_path
    end
  end
end