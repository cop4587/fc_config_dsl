
# entry = key + block

class DSL
  
  attr_accessor :content

  def add(key, &block)
    elements = {}
    elements.merge!(block.call)
    entry = {}
    entry[key] = elements
    puts "add entry = #{entry}"
  end
  
  def upd(key, &elements)
    puts "upd #{key}"
    elements.call if elements
  end
  
  def del(key)
    puts "del #{key}"
  end
  
  def _(element)
    element
  end

=begin
  def self.define_action(name)
    define_method(name) do |key, &elements|
      puts "#{name} #{key}"
      elements.call if elements
    end
  end
  
  [:add, :upd, :del].each { |name| define_action name }
=end  
end