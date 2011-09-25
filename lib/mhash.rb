# Mhash
#
#   defines accessors methods for each hash key 
#
#
#   why?
#     to enhance syntactic sugar and to let the refactoring transition to a real object easier
#
#   usage:
#
#     include Mhash
#     h = { a: "b" }
#     to_mhash h
#     p h.a #=> "b"
#     h.a = "c"
#     p h.a

module Mhash
  def to_mhash(object)
    object.keys.each do |key|
      eval "
        def object.#{key}  
          self[:#{key}]
        end"
      eval "
        def object.#{key}=(value)  
          self[:#{key}] = value
        end"
    end
    object
  end
end