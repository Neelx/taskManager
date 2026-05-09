class DashboardController < ApplicationController
  def index
    @tasks         = current_user.tasks
    @total         = @tasks.count
    @completed     = @tasks.completed.count
    @pending       = @tasks.pending.count
    @overdue       = @tasks.overdue.count

    # Recent tasks for dashboard list (pending first, then by priority)
    @recent_tasks  = @tasks.order(completed: :asc, priority: :desc, created_at: :desc).limit(10)
    @high_priority = @tasks.pending.priority_high.by_due_date.limit(5)
  end
end
