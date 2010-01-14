require 'xmldb/base/resource'
require 'xmldb/base/service'
require 'xmldb/base/resource_set'
require 'xmldb/wrapped_object'

module XMLDB
  module Modules
    class UpdateQueryService < WrappedObject
      include XMLDB::Base::Service
      
      ##
      # Runs a set of XUpdate operations against the collection.
      def update(commands)
        @obj.update(commands)
      end
      
      ## 
      # Runs a set of XUpdate operations against a resource stored in a collection.
      def updateResource(id, commands) 
        @obj.updateResource(id, commands)
      end        
      
    end
  end
end
