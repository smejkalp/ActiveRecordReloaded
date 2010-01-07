require 'xmldb/base/resource_iterator'
require 'xmldb/base/resource'
require 'xmldb/wrapped_object'

module XMLDB
  module Base
    class ResourceSet < WrappedObject

      ##
      # Adds a Resource instance to the set. 
      def addResource(res) 
        @obj.addResource(res.obj)
      end
      
      ##
      # Removes all Resource instances from the set.
      def clear() 
        @obj.clear() 
      end
      
      ##
      # Returns an iterator over all Resource instances stored in the set.
      def getIterator() 
        XMLDB::Base::ResourceIterator.getInstance(@obj.getIterator())
      end
      
      ##
      # Returns a Resource containing an XML representation of all resources stored in the set.
      def getMembersAsResource() 
        XMLDB::Base::Resource.getInstance(@obj.getMembersAsResource()) 
      end
      
      ##
      # Returns the Resource instance stored at the index specified by index.
      def getResource(index) 
        XMLDB::Base::Resource.getInstance(@obj.getResource(index))
      end
      
      ##
      # Returns the number of resources contained in the set.
      def getSize() 
        @obj.getSize()
      end
      
      ##
      # Removes the Resource located at index from the set.
      def removeResource(index) 
        @obj.removeResource(index)
      end
      
    end
  end        
end