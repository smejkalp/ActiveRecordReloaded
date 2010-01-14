require 'active_record_reloaded/dbcontrollers/abstract_dbcontroller'
require 'xmldb/database_manager'
require 'rexml/document'
include REXML


module ActiveRecordReloaded
  
  module Dbcontrollers
    
    class XmlDbcontroller < AbstractDbcontroller 
      
      def initialize
        dm = XMLDB::DatabaseManager.new('./lib/xmldb/jar')
        db = dm.createDatabase()
        dm.registerDatabase(db)
        @collection = dm.getCollection('exist://joe.mk.cvut.cz:8080/exist/xmlrpc/db/arr');
        @xquery = @collection.getService('XQueryService', '')
        @xupdate = @collection.getService('XUpdateQueryService', '')
      end
      
      # Selects data from DB according to hashmap options ( :from, :limit, :order, :params)
      # :from => name of table
      # :limit => number of rows in returned array
      # :order => name of column
      # :params => hashmap like: params = { :columnName => "wanted value" }
      def find(options)
        tableName = options[:from]
        limit = options[:limit]
        paramsHash = options[:conditions]
        order = options[:order]
        
        conditions = ""
        if paramsHash != nil 
          paramsHash.keys.each_with_index { 
            |key, index|
            conditions += "@" + key.to_s + " = '" + paramsHash[key] + "'"
            if index < (paramsHash.keys.length - 1)
               conditions += " and "
            end
          }
        end
        
        if conditions != ""
          conditions = "[" + conditions + "]"
        end
        @xupdate
        resourceSet = @xquery.query("//instances/" + tableName + "/instance"+ conditions)
        xmldoc = resourceSet.getMembersAsArray()

        objects = Array.new
        i = 0
        xmldoc.each{|xml|
           objects[i] = {}
           xml.elements[1].attributes.keys.each { 
             |attribute|
             objects[i][attribute] = xml.elements[1].attributes[attribute]
           }
           i += 1
           if limit != nil && i >= limit
             break
           end
        }
        
        if order != nil
          objects.sort_by{ |item| item[order] }
        end
        
        return objects
      end
      
      def insert(table, options)
        #raise 'Method is not implemented'
        query = "<?xml version=\"1.0\"?> 
 <xupdate:modifications version=\"1.0\"
                xmlns:xupdate=\"http://www.xmldb.org/xupdate\"><xupdate:append select=\"//instances/#{table}\" child=\"last()\"> <xupdate:element name=\"intstance\">" 
        options.each_pair{|key, value|
          #query = "<{$key}>{$value}</{$key}>
          query << "<xupdate:attribute name=\"#{key}\">#{value}</xupdate:attribute>"
        } 
        query << "</xupdate:element></xupdate:append></xupdate:modifications>"
        
        @xupdate.update(query)
        
        resourceSet = @xquery.query("//classes/" + table.to_s + "[@_ID_]")
        arr = resourceSet.getMembersAsArray()
        #id = arr[1].elements
        #id = arr.elements["_ID_"]
        return 2
        
      end
      
      def update(table, options)
        #raise 'Method is not implemented'
        query = "<?xml version=\"1.0\"?> 
 <xupdate:modifications version=\"1.0\"
                xmlns:xupdate=\"http://www.xmldb.org/xupdate\"><xupdate:update select=\"//instances/#{table}[@_ID_='#{options["_ID_"]}']\"> <xupdate:element name=\"intstance\">" 
        options.each_pair{|key, value|
          #query = "<{$key}>{$value}</{$key}>
          query << "<xupdate:attribute name=\"#{key}\">#{value}</xupdate:attribute>"
        } 
        query << "</xupdate:element></xupdate:update></xupdate:modifications>"

        @xupdate.update(query)
        
      end
      
      def delete(options)
        raise 'Method is not implemented'
      end
      
      # Loads table rows and returns them in hashmap
      def attributes(table)
          resourceSet = @xquery.query("//classes/" + table.to_s + "[1]")
         
          xmlfile = File.new( resourceSet.getMembersAsResource().getContent() )
          xmldoc = Document.new(xmlfile)
  
          fields = { }
          xmldoc.elements.each("//" + table){ 
             |e|
             e.attributes.keys.each { 
               |attribute|
               fields[attribute] = e.attributes[attribute]
             }
          }
          return fields
      end
      
     end
  end
end