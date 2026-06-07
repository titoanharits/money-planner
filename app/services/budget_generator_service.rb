class BudgetGeneratorService
  def initialize(user, income, profile)
    @user = user
    @income = income.to_f
    @profile = profile
    @period_start = user.period_start_for
  end

  def call
    # Ambil konfigurasi profil
    rules = profile_rules[@profile.to_sym]
    return false unless rules

    Transaction.transaction do
      rules.each do |rule|
        # 1. Hitung nominal berdasarkan persentase
        amount = @income * rule[:percent]

        # 2. Cari atau buat kategori (Gunakan icon & color default)
        category = @user.categories.find_or_create_by!(name: rule[:name]) do |c|
          c.icon = rule[:icon]
          c.color = rule[:color]
          c.category_type = :expense
        end

        # 3. Create atau update budget bulan ini
        budget = category.budgets.find_or_initialize_by(
          user: @user,
          period_start_date: @period_start
        )
        budget.update!(amount: amount, month: @period_start.month, year: @period_start.year)
      end

      # Default Income Categories
      [
        { name: "Gaji", icon: "💼", color: "#4ADE80" },
        { name: "Profit", icon: "📈", color: "#34D399" }
      ].each do |cat|
        @user.categories.find_or_create_by!(name: cat[:name]) do |c|
          c.icon = cat[:icon]
          c.color = cat[:color]
          c.category_type = :income
          c.system_default = false
        end
      end

      # System Transfer Categories (locked)
      [
        { name: "Transfer Bank", icon: "🏦", color: "#60A5FA" },
        { name: "Tarik Tunai", icon: "💵", color: "#FBBF24" }
      ].each do |cat|
        @user.categories.find_or_create_by!(name: cat[:name]) do |c|
          c.icon = cat[:icon]
          c.color = cat[:color]
          c.category_type = :transfer
          c.system_default = true
        end
      end

      # Default Pocket
      @user.pockets.find_or_create_by!(name: "Cash") do |p|
        p.icon = "💰"
        p.color = "#FBBF24"
      end
    end
    true
  rescue StandardError => e
    Rails.logger.error "Auto-Budget Error: #{e.message}"
    false
  end

  private

  def profile_rules
    {
      # 1. THE CLASSIC (Elizabeth Warren)
      balanced_50_30_20: [
        { name: 'Essential (Needs)', percent: 0.50, icon: '🏠', color: '#818cf8' },
        { name: 'Lifestyle (Wants)', percent: 0.30, icon: '☕', color: '#fb923c' },
        { name: 'Financial Goals', percent: 0.20, icon: '🛡️', color: '#34d399' }
      ],
      # 2. THE 60% SOLUTION (Richard Jenkins)
      committed_60: [
        { name: 'Committed Expenses', percent: 0.60, icon: '📝', color: '#60a5fa' },
        { name: 'Retirement Savings', percent: 0.10, icon: '📈', color: '#a78bfa' },
        { name: 'Long-term Savings', percent: 0.10, icon: '💰', color: '#fbbf24' },
        { name: 'Fun Money', percent: 0.20, icon: '🎉', color: '#f87171' }
      ],
      # 3. AGGRESSIVE FIRE (Financial Independence, Retire Early)
      fire_aggressive: [
        { name: 'Living Expenses', percent: 0.30, icon: '🍞', color: '#94a3b8' },
        { name: 'Investments', percent: 0.60, icon: '🔥', color: '#ef4444' },
        { name: 'Buffer Fund', percent: 0.10, icon: '🌊', color: '#2dd4bf' }
      ],
      # 4. PARETO BUDGET (80/20 Rule)
      pareto_80_20: [
        { name: 'General Living', percent: 0.80, icon: '🛒', color: '#f472b6' },
        { name: 'Savings & Debt', percent: 0.20, icon: '💎', color: '#4ade80' }
      ]
    }
  end
end