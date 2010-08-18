class Todo
  # Regular Expressions used in parsing todos
  @@PRIREG=/^\(([A-Z])\)/
  @@CONREG=/@(\w+)/
  @@PROREG=/\+(\w+)/
  @@DONREG=/^x /

  attr :priority
  attr :contexts
  attr :projects
  attr :done

  # Parses text line by line and returns an array of TodoFus
  def self.parse(str)
    ret = []
    str.each_line do |line|
      ret << Todo.new(line)
    end
    ret
  end

  # Parses file line by line and returns an array of TodoFus
  def self.parse_file(fn)
    ret = []
    File.new(fn).read.each_line do |line|
      ret << Todo.new(line)
    end
    ret
  end

  # Constructs a TodoFu from an input string
  def initialize(str)
    s = str.strip.chomp
    @priority = s.scan(@@PRIREG).flatten.first 
    @contexts = s.scan(@@CONREG).flatten.uniq || []
    @projects = s.scan(@@PROREG).flatten.uniq || []
    @done = !s.match(@@DONREG).nil?
    @text = s
  end

  # Sets/Changes the current priority
  def priority=(pri)
    return false unless pri.is_a?(NilClass) || (pri.is_a?(String) && pri.match(/[A-Z]/))
    if pri == nil || pri == ""
      @text.gsub!(/^\([A-Z]\)/,"")
      @text.strip!
    else
      @text.gsub!(/^\([A-Z]\)/,"(#{pri})") || @text = "(#{pri}) #{@text}"
    end
    @priority = pri
  end

  # Updates the current contexts
  # * Removes contexts that are no longer needed
  # * Appends new contexts
  def contexts=(cons)
    return false unless cons.is_a? Array
    removed = @contexts - cons
    added = cons - @contexts
    @text << " " << added.map{|t| "@#{t}"}.join(" ")
    removed.each {|r| @text.gsub!(" @#{r}","")}
    @contexts=cons
  end

  # Updates the current projects
  # * Removes projects that are no longer needed
  # * Appends new projects
  def projects=(projs)
    return false unless projs.is_a? Array
    removed = @projects - projs
    added = projs - @projects
    @text << " " << added.map{|t| "+#{t}"}.join(" ")
    removed.each {|r| @text.gsub!(" +#{r}","")}
    @projects=projs
  end

  # Returns a String in the following format:
  # (priority) Text with contexts and projects
  def to_s
    @text
  end

  def do
    @text = "x #{@text}"
    @done = true
  end

  def undo
    @text.gsub!(/^(x )/,"")
    @done = false
  end

  def done?
    @done
  end

  # Compares objects based on priority, with unprioritized
  # objects always losing
  def <=>(b)
    return 1 if @priority.nil?
    return -1 if b.priority.nil?
    @priority <=> b.priority
  end
end
