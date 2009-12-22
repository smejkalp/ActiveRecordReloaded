module XMLDB
  module Base
    
    class Configurable
      
      ##
      # Returns the value of the property identified by name.
      def getProperty(name) 
        @def.setProperty(name, value)
      end
      
      ##
      # Sets the property name to have the value provided in value.
      def setProperty(name, value)
        @def.setProperty(name, value)
      end

    end
    
  end
end