require File.expand_path('../../todo', __FILE__)
namespace :todo do
  @todo_file=ENV['TODO_FILE'] || "todo.txt"

  task :load_file do
    @tasks = Todo.parse_file(@todo_file)
  end

  desc "List all todos not marked as done"
  task :list => :load_file do
    @tasks.reject!{|t| t.done? }
    print_tasks
  end
  desc "List all todos"
  task :listall => :load_file do
    print_tasks
  end
  task :ls => :listall
  desc "List all todos for a project"
  task :listproj, :proj do |cmd,args|
    if args[:proj]
      proj = args[:proj]
    else
      STERR.puts "Which project would you like to list?"
      proj = STDIN.gets.chomp
    end
    @tasks = @tasks.find_all{|t| t.projects.include?(proj) }
    print_tasks
  end
  task :listproj => :load_file
  desc "List all todos with a given context"
  task :listcontext, :cont do |cmd,args|
    if args[:cont]
      cont = args[:cont]
    else
      STERR.puts "Which context would you like to list?"
      cont = STDIN.gets.chomp
    end
    @tasks = @tasks.find_all{|t| t.contexts.include?(cont) }
    print_tasks
  end
  task :listcontext => :load_file

  desc "Add a todo"
  task :add, :text do |cmd,args|
    if args[:text]
      text = args[:text]
    else
      puts "Please enter the text to add"
      text = STDIN.gets.chomp
    end
    @tasks << Todo.new(text)
    write_back_to_file
  end
  task :add => :load_file

  desc "Remove a task from the todo file"
  task :remove, :index do |cmd,args|
    if args[:index]
      idx = args[:index]
    else
      STDERR.puts "Which task would you like removed?"
      idx = STDIN.gets.chomp
    end
    @tasks.delete_at idx.to_i
    write_back_to_file
  end
  task :remove => :load_file

  desc "Mark a task as done"
  task :do, :index do |cmd,args|
    if args[:index]
      idx = args[:index]
    else
      STDERR.puts "Which task would you like to mark as done?"
      idx = STDIN.gets.chomp
    end
    @tasks[idx.to_i].do
    write_back_to_file
  end
  task :do => :load_file

  def write_back_to_file
    File.open(@todo_file,"w") do |f|
      f.puts @tasks
    end
  end
  def print_tasks
    @tasks.sort.each_with_index do |v,i| 
      puts "#{i+1} #{v}"
    end
  end
end
