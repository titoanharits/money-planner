# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "== Menjalankan proses pengecekan dan backfill data untuk semua User =="

User.find_each do |user|
  # 1. Pastikan setiap user memiliki minimal 1 kantong (Cash)
  cash_pocket = user.pockets.find_or_create_by!(name: "Cash") do |p|
    p.icon = "💰"
    p.color = "#FBBF24"
  end

  # 2. Pastikan Kategori Default Pendapatan ada
  [
    { name: "Salary", icon: "💼", color: "#4ADE80" },
    { name: "Profit", icon: "📈", color: "#34D399" }
  ].each do |cat|
    user.categories.find_or_create_by!(name: cat[:name], category_type: :income) do |c|
      c.icon = cat[:icon]
      c.color = cat[:color]
      c.system_default = false
    end
  end

  # 3. Pastikan Kategori Default Transfer ada
  [
    { name: "Bank Transfer", icon: "🏦", color: "#60A5FA" },
    { name: "Withdraw", icon: "💵", color: "#FBBF24" }
  ].each do |cat|
    user.categories.find_or_create_by!(name: cat[:name], category_type: :transfer) do |c|
      c.icon = cat[:icon]
      c.color = cat[:color]
      c.system_default = true
    end
  end

  # 4. Migrasi transaksi lama yang belum terhubung dengan kantong atau tipe transaksinya kosong
  user.transactions.find_each do |tx|
    needs_update = false

    # Sinkronisasi tipe transaksi dengan tipe kategorinya (jika ada kategori)
    if tx.category.present? && tx.transaction_type != tx.category.category_type
      tx.transaction_type = tx.category.category_type
      needs_update = true
    end
    
    # Hubungkan transaksi lama ke kantong "Cash" secara default
    if tx.expense? || tx.transfer?
      if tx.source_pocket_id.nil?
        tx.source_pocket_id = cash_pocket.id
        needs_update = true
      end
    end

    if tx.income? || tx.transfer?
      if tx.destination_pocket_id.nil?
        tx.destination_pocket_id = cash_pocket.id
        needs_update = true
      end
    end

    tx.save(validate: false) if needs_update
  end
end

puts "== Backfill selesai dengan sukses! =="
