module ActiveRecordReloaded
  
  module Dbcontrollers
    
    class AbstractDbcontroller
    
      def find(options)
        raise 'Method find must be overridden'
      end
      
      def insert(options)
        raise 'Method insert must be overridden'
      end
      
      def update(options)
        raise 'Method update must be overridden'
      end
      
      def delete(options)
        raise 'Method delete must be overridden'
      end
      
      def attributes(table)
        raise 'Method delete must be overridden'
      end
    end
  end
end