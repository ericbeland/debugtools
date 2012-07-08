# Logs calls to Object.require so if a required file is blowing up, you can look
# and see the last require and diagnose.  After seeing which blows up, it can
# be helpful to run it to run the parser over it, even if it is non-executable

require 'logger'
  
class Object
  def require(file_name)        
    output = "requiring #{file_name}"    
    log = Logger.new(File.join(File.dirname(__FILE__), 'required.log'))        
    log.debug(output)     
    super
  end  
end
