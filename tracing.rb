# Traces the execution of code out to a log file. Offers a slightly different
# approach than ruby-trace.
#
# Author: Eric Beland
# License: MIT

# This is a debugging tool that uses set_trace_func (doc excerpt below):
#
# ==set_trace_func Doc Excerpt
#
# Establishes aProc as the handler for tracing, or disables tracing if the
# parameter is nil. aProc takes up to six parameters: an event name, a filename,
# a line number, an object id, a binding, and the name of a class.
# aProc is invoked whenever an event occurs.
#
#  Events are:
#   c-call (call a C-language routine),
#   c-return (return from a C-language routine),
#   call (call a Ruby method), class (start a class or module definition),
#   end (finish a class or module definition),
#   line (execute code on a new line),
#   raise (raise an exception),
#   and return (return from a Ruby method).
#   Tracing is disabled within the context of aProc.
#
#

# ==Example:
#
# include Tracing
#
# class Object
#  include Tracing
# end
#
# tracing_on('/tmp/tracelog.txt')
# puts "hi"
# tracing_off

module Tracing

  def tracelog(str, logpath)
    File.open(logpath, "a") {|f|f << "#{Time.now} #{str}\n"}
  end

  # regexp listing what types of items to exclude...
  # overwrite this method locally to vary the detail
  # see events list at the top.  Filter c-call to remove
  # all calls to C methods (system funcs).
  def filter(txt)
    /(c-call|line|return)/ =~ txt
  end

  # put the log array output in a readable order
  def format_trace(x)
    "#{x[1]} #{x[2]} #{x[0]} #{x[5]}.#{x[3]}"
  end

  def tracing_on(logfile)    
    File.delete(logfile) if File.exist?(logfile)
    set_trace_func proc { |*x|
      tracelog(format_trace(x), logfile) if !(filter(x[0]))
    }
  end

  def tracing_off
    set_trace_func(nil)
  end

end

