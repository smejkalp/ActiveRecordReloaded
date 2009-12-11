require 'active_record_reloaded/dbcontrollers/abstract_dbcontroller'

module ActiveRecordReloaded
  
  module Dbcontrollers
    
    class MockDbcontroller < AbstractDbcontroller 
      
      def find(options)
        objects = Array.new
        for i in 0..4
          objects[i] = getElement
        end
        objects
      end
      
      def insert(options)
        raise 'Method is not implemented'
      end
      
      def update(options)
        raise 'Method is not implemented'
      end
      
      def delete(options)
        raise 'Method is not implemented'
      end
      
      private
        def getElement
          return Array[
                :id     =>  1,
                :text   =>  'text prispevku',
                :autor  =>  'pepa'
            ]
        end
    end
  end
end