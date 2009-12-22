module XMLDB
  module Base
    
    class Resource
      
      ##
      # Initialize 
      def initialize(c)
        @obj = c
        
        if (@obj == nil)
          raise 'Resource initialised with empty object'
        end
        
      end 
      
      ##
      # Retrieves the content from the resource. 
      
      def getContent() 
        return @obj.getContent().toString()
      end
      
      ##
      # Returns the unique id for this Resource or null if the Resource is anonymous.
      def getId()
        @obj.getId()
      end
      
      
      ##
      # Returns the Collection instance that this resource is associated with.
      def getParentCollection() 
        return XMLDB::Base::Collection.getInstance(@obj.getParentCollection())
      end  
      
      ##
      # Returns the resource type for this Resource.
      def getResourceType() 
        @obj.getResourceType() 
      end
      
      ##
      # Sets the content for this resource.
      def setContent(value) 
        @obj.setContent(value) 
      end
      
      ##
      # Get instance of wrapping class from wrapped class
      def Resource.getInstance(i) 
        return Resource.new(i)
      end
      
      attr_accessor :obj
      
    end
  end
end