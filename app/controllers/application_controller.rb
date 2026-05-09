class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_login
  before_action :set_nav_counts, if: :logged_in?

  private

  def require_login
    unless logged_in?
      store_location
      redirect_to login_path, alert: "Please sign in to continue."
    end
  end

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  # Load dynamic counts for sidebar nav — available in all views
  def set_nav_counts
    tasks = current_user.tasks
    @nav_counts = {
      total:     tasks.count,
      pending:   tasks.pending.count,
      overdue:   tasks.overdue.count,
      completed: tasks.completed.count,
      high:      tasks.pending.priority_high.count,
      today:     tasks.due_today.count
    }
  end
  helper_method :nav_counts

  def nav_counts
    @nav_counts || {}
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

  def redirect_back_or(default)
    redirect_to(session.delete(:return_to) || default)
  end
end
