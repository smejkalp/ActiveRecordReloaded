require 'rexml/document'

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
      
      ######################################################
      ## XMLResource implementation
      
      ##
      # Returns the content of the Resource as a REXML.
      def getContentAsREXML()
        return REXML::Document.new(@obj.getContent().toString(), { :compress_whitespace => :all})
      end
      
      
      ##
      # Returns the content of the Resource as a REXML Root Node. Allows browsing using elements[]/attributes[] functions
      def getContentAsREXMLRoot() 
        return REXML::Document.new(@obj.getContent().toString(), { :compress_whitespace => :all}).root
      end
      
      
      ##
      # Returns the unique id for the parent document to this Resource or null if the Resource does not have a parent document.
      def getDocumentId() 
        @obj.getDocumentId() 
      end
      
      ##
      # Sets the content of the Resource using a DOM Node as the source.
      def setContentAsREXML(content) 
        @obj.setContent(content.to_s)
      end
      
      
      ##
      # Sets the content of the Resource using a SAX ContentHandler.
      def setContentAsREXMLRoot(content) 
        @obj.setContent(content.to_s)
      end
      
    end
  end
end
