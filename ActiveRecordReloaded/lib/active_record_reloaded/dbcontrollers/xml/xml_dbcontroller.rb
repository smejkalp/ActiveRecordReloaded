require 'active_record_reloaded/dbcontrollers/abstract_dbcontroller'
require 'xmldb/database_manager'
require 'rexml/document'
require 'uri'
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
      
      # Selects data from DB according to hashmap options ( :from, :limit, :order, :conditions)
      # :from => name of table
      # :limit => number of rows in returned array
      # :order => name of column
      # :conditions => hashmap like: conditions = { :columnName => "wanted value" }
      def find(options)
        tableName = options[:from]
        limit = options[:limit]
        paramsHash = options[:conditions]
        order = options[:order]
        
        conditions = ""
        if paramsHash != nil 
          paramsHash.keys.each_with_index { 
            |key, index|
            conditions += "@" + key.to_s + " = '" + URI.escape(paramsHash[key]) + "'"
            if index < (paramsHash.keys.length - 1)
               conditions += " and "
            end
          }
        end
        
        if conditions != ""
          conditions = "[" + conditions + "]"
        end
        
        resourceSet = @xquery.query("/root/instances/" + tableName + "/instance"+ conditions)
        xmldoc = resourceSet.getMembersAsArray()

        objects = Array.new
        i = 0
        xmldoc.each{|xml|
           objects[i] = {}
           xml.elements[1].attributes.keys.each { 
             |attribute|
             objects[i][attribute] = deserializeObject( URI.unescape(xml.elements[1].attributes[attribute]) )
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
        attr_hashmap = attributes(table)
        obj_ID = attr_hashmap["_ID_"]
        next_obj_ID = obj_ID.to_i + 1

        query = "<?xml version=\"1.0\"?><xupdate:modifications version=\"1.0\" xmlns:xupdate=\"http://www.xmldb.org/xupdate\"><xupdate:update select=\"/root/classes/#{table}/@_ID_\" >#{next_obj_ID}</xupdate:update></xupdate:modifications>"
        @xupdate.update(query)
        
        options["_ID_"] = obj_ID
        query = "<?xml version=\"1.0\"?><xupdate:modifications version=\"1.0\" xmlns:xupdate=\"http://www.xmldb.org/xupdate\"><xupdate:append select=\"//instances/#{table}\" child=\"last()\"> <xupdate:element name=\"instance\">" 
        options.each_pair{|key, value|
          query << "<xupdate:attribute name=\"#{key}\">#{URI.escape(serializeObject(value))}</xupdate:attribute>"
        } 
        query << "</xupdate:element></xupdate:append></xupdate:modifications>"
        
        @xupdate.update(query)
        
        return obj_ID
        
      end
      
      def update(table, options)
        query = "<?xml version=\"1.0\"?> <xupdate:modifications version=\"1.0\" xmlns:xupdate=\"http://www.xmldb.org/xupdate\">" 
        options.each_pair{|key, value|
          query << "<xupdate:update select=\"/root/instances/#{table}/instance[@_ID_='#{options["_ID_"]}']/@#{key}\" >#{URI.escape(serializeObject(value))}</xupdate:update>"
        }
        query << "</xupdate:modifications>"

        @xupdate.update(query)
        
      end
      
      def delete(table, options)
        id = options[:id]
        query = "<xupdate:modifications version=\"1.0\" xmlns:xupdate=\"http://www.xmldb.org/xupdate\"><xupdate:remove select=\"/root/instances/#{table}/instance[@_ID_ = #{id}]\"/></xupdate:modifications>"
        @xupdate.update(query)
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
      
      
      def serializeObject( object )
        if ( object.kind_of? ActiveRecordReloaded::Base )
          return Marshal.dump(serializeBaseObject(object))
        end
        
        if ( object.kind_of? Array )
          resultArray = []
          object.each { |element|
            resultArray << serializeObject(element) 
          }
          return Marshal.dump(resultArray)
        end
        
        if ( object.kind_of? Hash )
          resultHash = {}
          object.each_pair{ |key, value|
            resultHash[key] = serializeObject(value)
          }
          return Marshal.dump(resultHash)
        end
        return object
      end
      
      def serializeBaseObject( object )
        object.save
        serializedObject = SerializedBaseClass.new( object._ID_, object.class )
        return serializedObject
      end
      
      def deserializeObject( object )
        begin
          unmarshaledObject = Marshal.load( object )
          
          if ( unmarshaledObject.kind_of? SerializedBaseClass )
            options = { :limit => 1, :conditions => { :_ID_ => unmarshaledObject.id } }
            foundObjects = eval( unmarshaledObject.className.to_s + ".find(:all, options)" )
            return foundObjects.first
          end
          
          if ( unmarshaledObject.kind_of? Hash )
            unmarshaledObject.each_pair{ |key, value|
              unmarshaledObject[key] = deserializeObject(value)
            }
            return unmarshaledObject
          end
          
          if ( unmarshaledObject.kind_of? Array )
            unmarshaledObject.each_with_index { |element, idx| 
              unmarshaledObject[idx] = deserializeObject(element) 
            }
            return unmarshaledObject
          end
          
          raise Exception
        rescue Exception
        	return object
        end
      end
      
     end
  end
end

class SerializedBaseClass
  attr_reader :id, :className
  def initialize( id, className )
    @id = id
    @className = className
  end
end