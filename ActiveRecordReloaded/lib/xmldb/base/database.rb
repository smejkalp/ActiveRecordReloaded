require 'rjb'
require 'xmldb/wrapped_object'
require 'xmldb/base/collection'
require 'xmldb/base/configurable'

module XMLDB
  module Base
    
    class Database < XMLDB::WrappedObject
      include Configurable
      
      ##
      # acceptsURI determines whether this Database implementation can handle the URI. 
      def acceptsURI(uri)
        return @obj.acceptsURI(uri)
      end
      
      ##
      # Retrieves a Collection instance based on the URI provided in the uri parameter. 
      def getCollection(uri, username, password)
        collection = @obj.getCollection(uri, username, password)
        return XMLDB::Base::Collection.getInstance(collection)
      end
      
      ##
      # Returns the XML:DB API Conformance level for the implementation. 
      def getConformanceLevel()
        return @obj.getConformanceLevel()
      end
      
      ##
      # Deprecated. Replaced by String[] getNames().
      def getName() 
        return @obj.getName() 
      end
      
      ##
      # Returns an array of names associated with the Database instance.  
      def getNames() 
        return @obj.getNames()
      end
      
    end
  end
end
