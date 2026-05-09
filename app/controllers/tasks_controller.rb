class TasksController < ApplicationController
  before_action :set_task, only: [ :show, :edit, :update, :destroy, :toggle_complete ]

  def index
    @tasks = current_user.tasks

    # Build filter counts dynamically from the current user's tasks
    all_tasks = current_user.tasks
    @filter_counts = {
      "all"       => all_tasks.count,
      "pending"   => all_tasks.pending.count,
      "completed" => all_tasks.completed.count,
      "overdue"   => all_tasks.overdue.count,
      "high"      => all_tasks.pending.priority_high.count,
      "today"     => all_tasks.due_today.count
    }

    # Apply filter
    @tasks = case params[:filter]
    when "completed" then @tasks.completed
    when "pending"   then @tasks.pending
    when "overdue"   then @tasks.overdue
    when "high"      then @tasks.pending.priority_high
    when "today"     then @tasks.due_today
    else                  @tasks
    end

    # Apply sort
    @tasks = case params[:sort]
    when "priority" then @tasks.by_priority
    when "due_date" then @tasks.by_due_date
    when "created"  then @tasks.order(created_at: :desc)
    else                 @tasks.order(completed: :asc, priority: :desc, due_date: :asc)
    end

    @filter = params[:filter].presence || "all"
    @sort   = params[:sort].presence   || "default"
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Task \"#{@task.title}\" created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    title = @task.title
    @task.destroy
    redirect_to tasks_path, notice: "\"#{title}\" was deleted."
  end

  def toggle_complete
    @task.update!(completed: !@task.completed?)
    redirect_back fallback_location: tasks_path
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: "Task not found."
  end

  def task_params
    params.require(:task).permit(:title, :description, :priority, :due_date, :completed)
  end
end
