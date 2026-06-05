class MigrateExistingData < ActiveRecord::Migration[8.1]
  def up
    # We use execute to avoid model dependency issues during migrations
    execute <<-SQL
      UPDATE transactions t
      JOIN categories c ON t.category_id = c.id
      SET t.transaction_type = CASE WHEN c.category_type = 1 THEN 1 ELSE 0 END
    SQL
  end

  def down
    # Nothing to do here
  end
end
