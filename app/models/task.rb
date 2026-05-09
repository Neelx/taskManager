class Task < ApplicationRecord
  belongs_to :user

  enum :priority, { low: 0, medium: 1, high: 2 }, prefix: true

  validates :title,    presence: true, length: { maximum: 200 }
  validates :priority, presence: true
  validates :completed, inclusion: { in: [ true, false ] }

  scope :pending,    -> { where(completed: false) }
  scope :completed,  -> { where(completed: true) }
  scope :overdue,    -> { pending.where("due_date < ?", Date.today) }
  scope :due_today,  -> { pending.where(due_date: Date.today) }
  scope :by_priority, -> { order(priority: :desc) }
  scope :by_due_date, -> { order(Arel.sql("due_date IS NULL, due_date ASC")) }

  def overdue?
    due_date.present? && due_date < Date.today && !completed?
  end

  def due_today?
    due_date == Date.today && !completed?
  end

  def status_label
    if completed?
      "Completed"
    elsif overdue?
      "Overdue"
    elsif due_today?
      "Due Today"
    else
      "Pending"
    end
  end

  def priority_label
    priority.to_s.capitalize
  end
end
