require 'active_record_reloaded/dbcontrollers/abstract_dbcontroller'

module ActiveRecordReloaded
  
  module Dbcontrollers
    
    class MockDbcontroller < AbstractDbcontroller 
      
      public
        # Finds rows in database using specific options
        # Returns array of hash maps
        def find(options)
          objects = Array.new
          for i in 0..4
            objects[i] = getElement
          end
          objects
        end
        
        # Insert a row into database using hash map
        # Returns new inserted ID
        def insert(options)
          return 100
        end
        
        # Updates row in database using hash map
        # Returns number of affected rows
        def update(options)
          return 5
        end
        
        # Deletes row in database using specific options
        # Returns number of deleted rows
        def delete(options)
          raise 'Method is not implemented'
        end
        
        # Returns hash map of table attributes (columns) and their default values
        def attributes(table)
          return { 
                 :uid => 0, 
                 :text => '', 
                 :autor => '' 
              }
        end
      
      private
        # Returns a new Mock object (hash map)
        def getElement
          return {
                :uid     =>  1,
                :text   =>  'text prispevku',
                :autor  =>  'pepa'
            }
        end
    end
  end
end