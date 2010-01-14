module XMLDB
  module Base
    module Service
      
      ##
      # Returns the name associated with the Service instance.
      def getName() 
        @obj.getName()
      end
      
      ##
      # Gets the Version attribute of the Service object
      def getVersion()
        @obj.getVersion()
      end
      
      ##
      # Sets the Collection attribute of the Service object
      def setCollection(col)
        @obj.setCollection(col.obj)
      end
      
      def Service.getServiceInstance(service)
        require 'xmldb/modules/x_path_query_service'
        require 'xmldb/modules/update_query_service'
        
        javaClass = Rjb::import("java.lang.Class")
        if(javaClass.forName("org.xmldb.api.modules.XQueryService").isAssignableFrom(service.getClass()))
          return XMLDB::Modules::XPathQueryService.getInstance(service)
        elsif(javaClass.forName("org.xmldb.api.modules.XUpdateQueryService").isAssignableFrom(service.getClass()))
          return XMLDB::Modules::UpdateQueryService.getInstance(service)
        else
          return nil
        end
      end
      
    end
  end
end