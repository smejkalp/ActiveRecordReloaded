module ActiveRecordReloaded
  
  module Dbcontrollers
    
    class AbstractDbcontroller
    
      # Finds rows in database using specific options
      # Returns array of hash maps
      def find(options)
        raise 'Method find must be overridden'
      end
      
      # Insert a row into database using hash map
      # Returns new inserted ID
      def insert(table, options)
        raise 'Method insert must be overridden'
      end
      
      # Updates row in database using hash map
      # Returns number of affected rows
      def update(table, options)
        raise 'Method update must be overridden'
      end
      
      # Deletes row in database using specific options
      # Returns number of deleted rows
      def delete(table, options)
        raise 'Method delete must be overridden'
      end
      
      # Returns hash map of table attributes (columns) and their default values
      def attributes(table)
        raise 'Method delete must be overridden'
      end
    end
  end
end