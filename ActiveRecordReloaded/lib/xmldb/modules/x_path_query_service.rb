require 'xmldb/base/resource'
require 'xmldb/base/service'
require 'xmldb/base/resource_set'
require 'xmldb/wrapped_object'

module XMLDB
  module Modules
    class XPathQueryService < WrappedObject
      include XMLDB::Base::Service
      
      ##
      # Removes all namespace mappings stored in the internal namespace map.
      def clearNamespaces() 
        @obj.clearNamespaces()
      end
      
      ##
      # Returns the URI string associated with prefix from the internal namespace map.
      def getNamespace(prefix)
        @obj.getNamespace(prefix)
      end  
      
      ##
      # Run an XPath query against the Collection.
      def query(query)
        XMLDB::Base::ResourceSet.getInstance(@obj._invoke('query', 'Ljava.lang.String;', query))
      end  
      
      ##
      # Run an XPath query against an XML resource stored in the Collection associated with this service.
      def queryResource(id, query) 
        XMLDB::Base::ResourceSet.getInstance(@obj._invoke('queryResource', 'Ljava.lang.String;Ljava.lang.String', id, query))
      end
      
      ##
      # Removes the namespace mapping associated with prefix from the internal namespace map.
      def removeNamespace(prefix) 
        @obj.removeNamespace(prefix)
      end
      
      ##
      # Sets a namespace mapping in the internal namespace map used to evaluate queries.
      def setNamespace(prefix, uri) 
        @obj.setNamespace(prefix, uri)
      end
      
    end
  end
end