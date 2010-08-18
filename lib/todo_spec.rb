require './todo'
describe Todo, "#parsing"  do
  it "can parse a standard todo" do
    s = "This is a standard todo"
    t = Todo.new(s)
    t.is_a?(Todo).should == true
    t.to_s.should == s
  end
  it "can parse a todo with priority" do
    s = "(A) This todo has priority"
    t = Todo.new(s)
    t.is_a?(Todo).should == true
    t.priority.should == "A"
    t.to_s.should == s
  end
  it "can parse a todo with context" do
    s = "This todo has a @context"
    t = Todo.new(s)
    t.is_a?(Todo).should == true
    t.contexts.include?("context").should == true
    t.to_s.should == s
  end
  it "can parse a todo with project" do
    s = "This todo has a +project"
    t = Todo.new(s)
    t.is_a?(Todo).should == true
    t.projects.include?("project").should == true
    t.to_s.should == s
  end
  it "can parse a completed todo" do
    s = "x This todo is done"
    t = Todo.new(s)
    t.is_a?(Todo).should == true
    t.done?.should == true
    t.to_s.should == s
  end
  it "can parse a complex todo" do
    s = "(A) This todo has a @context and a +project"
    t = Todo.new(s)
    t.priority.should == "A"
    t.contexts.include?("context").should == true
    t.projects.include?("project").should == true
    t.is_a?(Todo).should == true
    t.to_s.should == s
  end
  it "can parse a list of todos" do
    
    @todos = Todo.parse(File.open("todo_spec.txt","r").read)
    @todos.count.should == 5
  end
  it "can parse a file" do
    @todos = Todo.parse_file("todo_spec.txt")
    @todos.count.should == 5
  end
end
describe Todo, "#managing" do
  before(:all) do
    @todo = Todo.new("(A) Make this todo work @context +project")
  end
  it "correctly adds a context" do
    @todo.contexts = @todo.contexts + ["newcontext"]
    @todo.contexts.include?("newcontext").should == true
    @todo.to_s.include?("@newcontext").should == true
    @todo.to_s.include?("@context").should == true
  end
  it "correcly subtracts a context" do
    @todo.contexts = []
    @todo.contexts.include?("context").should_not == true
    @todo.to_s.include?("@context").should_not == true
  end
  it "correctly adds and subtracts a context at once" do
    @todo.contexts = ["newcontext"]
    @todo.contexts.include?("context").should_not == true
    @todo.to_s.include?("@context").should_not == true
    @todo.contexts.include?("newcontext").should == true
    @todo.to_s.include?("@newcontext").should == true
  end
  it "correctly adds a project" do
    @todo.projects = @todo.projects + ["newproject"]
    @todo.projects.include?("newproject").should == true
    @todo.to_s.include?("+newproject").should == true
    @todo.to_s.include?("+project").should == true
  end
  it "correcly subtracts a project" do
    @todo.projects = []
    @todo.projects.include?("project").should_not == true
    @todo.to_s.include?("+project").should_not == true
  end
  it "correctly adds and subtracts a project at once" do
    @todo.projects = ["newproject"]
    @todo.projects.include?("newproject").should == true
    @todo.projects.include?("project").should_not == true
    @todo.to_s.include?("+newproject").should == true
    @todo.to_s.include?("+project").should_not == true
  end
  it "correctly changes a priority" do
    @todo.priority = "B"
    @todo.priority.should == "B"
    @todo.to_s.match(/^\(B\)/).should_not == nil
  end
  it "correctly removes a priority" do
    @todo.priority = nil
    @todo.priority.should == nil
    @todo.to_s.match(/^\(.\)/).should == nil
  end
  it "correctly marks as done" do
    @todo.do
    @todo.done?.should == true
  end
  it "correctly marks as undone" do
    @todo.do
    @todo.undo
    @todo.done?.should_not == true
  end
#  it "" do
#    pending
#  end
end
