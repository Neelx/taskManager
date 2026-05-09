class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :user,        null: false, foreign_key: true
      t.string     :title,       null: false
      t.text       :description
      t.integer    :priority,    null: false, default: 1   # 0=low, 1=medium, 2=high
      t.date       :due_date
      t.boolean    :completed,   null: false, default: false

      t.timestamps
    end
    add_index :tasks, [ :user_id, :completed ]
    add_index :tasks, [ :user_id, :priority ]
    add_index :tasks, [ :user_id, :due_date ]
  end
end
