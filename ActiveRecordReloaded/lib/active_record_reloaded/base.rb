require 'active_record_reloaded/dbcontrollers/xml/xml_dbcontroller'

module ActiveRecordReloaded
  
  class Base
    
    @@dbcontroller = ActiveRecordReloaded::Dbcontrollers::XmlDbcontroller.new
    
    
    
    ################## PUBLIC CLASS METHODS ######################
    public
      # Returns all objects without using conditions
      def self.all
        find(:all)
      end
      
      # Returns first object using conditions
      def self.first(*args)
        find(:first, *args)
      end
      
      # Returns objects using conditions
      def self.find(*args)
      options = args.is_a?(::Hash) ? args.pop : args.is_a?(Array) ? args.pop : {}
      
      case args.first
        when :first then find_first(options)
        when :last  then find_last(options)
        when :all   then find_every(options)
        else             raise 'Not implemented' #find_from_ids(args, options)
      end
    end
    
      # Returns table name
      # TODO: dodelat ziskani nazvu tabulky
      def self.table_name
        return self.name
      end
      
      # Returns a table primary key index used for attributes
      # TODO: dodelat ziskani primarniho klice
      def self.primary_key
        #self.class.name + :Id
        :_ID_
      end
    
      # Deletes object in database according to its ID
      def self.delete(id)
        options = { :id => id }
        @@dbcontroller.delete(options)
      end
    
    
    ################## PUBLIC INSTANCE METHODS ######################
    public
      # New object method
      def initialize
        @attributes = { }
        @attributes = @@dbcontroller.attributes(table_name)
        @new_record = true
      end
    
      # Returns all object's attributes
      def attribute_names
        @attributes.keys
      end
      
      def primary_key
        return self.class.primary_key
      end
      
      def table_name
        return self.class.table_name
      end
    
      # Returns if the object is new
      def new_record?
        return @new_record
      end
    
      # Saves object into a database
      # TODO: po vlozeni aktualizovat primarni klic objektu
      def save
        @new_record ? insert : update
      end
      
      # Destroys object in database
      def destroy
        if (!@new_record)
            raise 'Cannot delete object from database because it has not been inserted'
        end
        
        id = get_attribute(primary_key)
        delete(id)
        set_attribute(id, default_primary_key_value)
        @new_record = true
      end
    
    
    ################## PROTECTED CLASS METHODS ######################
    protected
      # Finds the first object using lower tier options
      def self.find_first(options)
        options.update(:limit => 1)
        find_every(options).first
      end
      
      # Finds the last object using lower tier options
      def self.find_last(options)
        raise 'Method not implemented'
      end
      
      # Finds every object using lower tier options
      def self.find_every(options)
        options = process_find_options(options)
        result = @@dbcontroller.find(options)
        
        objects = Array.new
        if (result.is_a?(Array))
          i = 0
          result.each {
            |item|
            objects[i] = instantiate(item)
            i = i + 1
          }
        end
        
        return objects
      end
      
      # Makes a lower tier options according to conditions parameters
      def self.process_find_options(options)
        return {
                :from   => table_name,
                :limit  => option(:limit, nil, options),
                :offset => option(:offset, 0, options),
                :order  => option(:order, nil, options),
                :conditions => option(:conditions, nil, options)
            }
      end
      
      # Gets a option value from options (HashMap) or default value if it does not exists
      def self.option(key, defaultValue, options)
        if (options.has_key?(key))
          return options[key]
        end
        
        return defaultValue
      end
      
      # Creates a new instace of object from hash map
      def self.instantiate(hashmap)
        obj = self.new
        obj.instance_variable_set('@attributes', hashmap)
        obj.instance_variable_set('@new_record', false)
        return obj
      end
      
    
   ################## PROTECTED INSTANCE METHODS ######################
   protected
      # Returns true if object has non-zero primary key
      def has_primary_key
        if ( has_attribute(primary_key) == true )
          pkey = get_attribute(primary_key)
          if ( pkey != 0 && pkey != '' && pkey != default_primary_key_value )
            return true
          end
        end
        
        return false
      end
      
      # Returns default value of primary key
      def default_primary_key_value
        attrs = @@dbcontroller.attributes(table_name)
        return attrs[primary_key]
      end
      
      # Resets primary key value to default
      def reset_primary_key_to_default
        @attributes[primary_key] = default_primary_key_value
      end
    
      # Converts object to map which is sent into lower tiers
      def convert_to_map
        return @attributes
      end
    
      # Creates object attributes using hash map
      def convert_to_object(hashmap)
        # TODO: pravdepodobne tuto metodu vyhodit. Vyuziva se instantiate
        if ( !hashmap.is_a?(Hash) )
          raise 'Given parameter is not hashmap'
        end
        
        @attributes = hashmap
      end

      # Determines what to do if method does not exists
      def method_missing(method_id, *arguments, &block)
        method_id = method_id.to_s
        if (has_attribute(method_id))
          case arguments.length
            when 0 then return get_attribute(method_id)
            when 1 then return set_attribute(method_id, arguments[0])
          end
        end
      end
      
      # Returns if the object is responsible for the method
      def respond_to?(method_id)
        if (@attributes.has_key?(method_id))
          return true
        end
        return false
      end

      # Returns attribute value
      def get_attribute(attribute)
        if (!has_attribute(attribute)) 
          raise 'Object does not have attribute ' + attribute
        end
        return @attributes[attribute]
      end
    
      # Sets attribute value
      def set_attribute(attribute, value) 
        if (!has_attribute(attribute)) 
          raise 'Object does not have attribute ' + attribute
        end
        
        @attributes[attribute] = value
      end
    
      # Checks if object has the attribute 
      def has_attribute(attribute)
        attribute = attribute.to_s
        if (@attributes.has_key?(attribute))
          return true 
        end
        return false
      end

      # Inserts new object into database
      def insert
        uid = @@dbcontroller.insert(table_name, convert_to_map)
        #set_attribute(primary_key, uid)
        @new_record = false
        return uid
      end

      # Updates existing object in database
      def update
        @@dbcontroller.update(table_name, convert_to_map)
      end

  end
end