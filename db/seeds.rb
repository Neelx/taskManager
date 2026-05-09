# Demo seeds — run with: rails db:seed
puts "Seeding..."

user = User.find_or_create_by!(email: "demo@taskmaster.com") do |u|
  u.name     = "Demo User"
  u.password = "password123"
  u.password_confirmation = "password123"
end

user.tasks.destroy_all

tasks = [
  { title: "Design new landing page",    description: "Create wireframes and mockups for the revamped homepage.", priority: :high,   due_date: Date.today - 1, completed: false },
  { title: "Write API documentation",    description: "Document all REST endpoints with request/response examples.", priority: :high,   due_date: Date.today + 3, completed: false },
  { title: "Fix login page bug",         description: "Users on mobile can't tap the submit button.", priority: :high,   due_date: Date.today,     completed: false },
  { title: "Set up CI/CD pipeline",      description: "Configure GitHub Actions for automated testing and deploy.", priority: :medium, due_date: Date.today + 7, completed: false },
  { title: "Update dependencies",        description: "Run bundle update and resolve any conflicts.", priority: :medium, due_date: Date.today + 5, completed: true },
  { title: "Write unit tests",           description: "Cover all model validations and controller actions.", priority: :medium, due_date: Date.today + 10, completed: false },
  { title: "Optimize database queries",  description: "Add missing indexes and refactor N+1 queries.", priority: :low,    due_date: Date.today + 14, completed: false },
  { title: "Code review session",        description: "Review PRs from the team.", priority: :low,    due_date: nil,            completed: true },
  { title: "Team standup prep",          description: nil, priority: :low,    due_date: Date.today,     completed: true },
]

tasks.each { |t| user.tasks.create!(t) }

puts "✓ Seeded #{user.tasks.count} tasks for #{user.email} (password: password123)"
