#require 'xmldb/base/Resource'
require 'xmldb/wrapped_object'

module XMLDB
  module Base
    class ResourceIterator < WrappedObject
      
      ##
      # Returns true as long as there are still more resources to be iterated.
      def hasMoreResources()
        @obj.hasMoreResources()
      end
      
      ##
      # Returns the next Resource instance in the iterator.
      def nextResource()
        XMLDB::Base::Resource.getInstance(@obj.nextResource())
      end
      
    end
  end
end