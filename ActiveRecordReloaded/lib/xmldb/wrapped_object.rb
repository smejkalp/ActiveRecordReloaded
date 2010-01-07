module XMLDB
    class WrappedObject
      
      ##
      # Initialize 
      def initialize(c)
        @obj = c
        
        if (@obj == nil)
          raise self.class.to_s + ' initialised with empty object'
        end
      end
      
      ##
      # Get instance of wrapping class from wrapped class
      def WrappedObject.getInstance(i) 
        return self.new(i)
      end
      
      attr_reader :obj
      
    end
end
