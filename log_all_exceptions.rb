# Use this monkey patch to log or output all exceptions within a program. 

# This works by hooking the creation of all Exceptions. Keep in mind, this
# will trap all exceptions, including rescued exceptions that are not fatal.
# This can be useful, especially within evented code like Eventmachine when used to discover
# where a callback is dying.

# A simple string-match filter is included so eliminating noise is possible:

# Exception.ignore_for_logging = ['Timeout']

# In order to use this, you must define a global log method specifying what to do with
# the output.  For example, here you could simply write it to stdout. Alternately, you 
# can call your own logger.

# module Kernel
#	def log(msg)
#		p msg
#	end
# end


class Exception
  alias :real_init :initialize
  
  @@ignore_patterns = []
  
  def self.ignore_for_logging=(text_arr)
    @@ignore_patterns = text_arr
  end
  
  def ignored?
    @@ignore_patterns.each do |p|      
      return true if self.message.include?(p)
    end
    false
  end
  
  def initialize(*args)
    real_init *args        
    unless ignored?
     log "****Exception: #{self}  #{self.message}  #{caller(1)}"
    end
     self
  end
    
end