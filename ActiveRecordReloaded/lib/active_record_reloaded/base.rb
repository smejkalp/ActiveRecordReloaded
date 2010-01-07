require 'active_record_reloaded/dbcontrollers/mock/mock_dbcontroller'

module ActiveRecordReloaded
  
  class Base
    
    @@dbcontroller = ActiveRecordReloaded::Dbcontrollers::MockDbcontroller.new
    
    
    
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
      options = args.extract_options!
      
      case args.first
        when :first then find_first(options)
        when :last  then find_last(options)
        when :all   then find_every(options)
        else             raise 'Not implemented' #find_from_ids(args, options)
      end
    end
    
    
    
    ################## PUBLIC INSTANCE METHODS ######################
    public
      # New object method
      def initialize
        @attributes = { }
        initializePrimaryKey
      end
    
      # Returns all object's attributes
      def attribute_names
        @attributes.keys
      end
    
      # Saves object into a database
      def save
        hashmap = convertToMap
        
        if (!hasPrimaryKey)
          hashmap = @@dbcontroller.insert(hashmap)
        else
          hashmap = @@dbcontroller.update(hashmap)
        end
        
        convertToObject(hashmap)
      end
      
      # Destroys object in database
      def destroy
      
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
        limit = 0
        order = ''
        if (options.has_key?(:limit))
          limit = options[:limit]
        end
        
        if (options.has_key?(:order))
          order = options[:order]
        end
        
        
        return {
                :from   =>  tableName,
                :limit  =>  limit,
                :order  =>  order
            }
      end
      
      # Returns table name
      def self.tableName
        #TODO: dodelat ziskani nazvu tabulky
        #return self.class.name
        'tabulka'
      end
      
      # Creates a new instace of object from hash map
      def self.instantiate(hashmap)
        obj = self.new
        obj.instance_variable_set('@attributes', hashmap)
        return obj
      end
      
    
   ################## PROTECTED INSTANCE METHODS ######################
   protected
      # Returns true if object has non-zero primary key
      def hasPrimaryKey
        if ( @attributes.has_key?(getPrimaryKeyIndex) == true )
          if ( @attributes[getPrimaryKeyIndex] != 0 )
            return true
          end
        end
        
        return false
      end
      
      # Returns a table primary key index used for attributes
      def getPrimaryKeyIndex
        # TODO: dodelat ziskani nazvu tabulky
        #self.class.name + :Id
        :Uid
      end
    
      # Initalizes a primary key attribute
      def initializePrimaryKey
        @attributes[getPrimaryKeyIndex()] = 0
      end
    
      # Converts object to map which is sent into lower tiers
      def convertToMap
        if (hasPrimaryKey == false)
          initializePrimaryKey
        end
        
        return @attributes
      end
    
      # Creates object attributes using hash map
      def convertToObject(hashmap)
        # TODO: pravdepodobne tuto metodu vyhodit. Vyuziva se instantiate
        if ( !hashmap.is_a?(Hash) )
          raise 'Given parameter is not hashmap'
        end
        
        @attributes = hashmap
        if (!hasPrimaryKey)
          initializePrimaryKey
        end
      end

      # Determines what to do if method does not exists
      def method_missing(method_id, *arguments, &block)
        if (@attributes.has_key?(method_id))
          return @attributes[method_id]
        end
      end
      
      # Returns if the object is responsible for the method
      def respond_to?(method_id)
        if (@attributes.has_key?(method_id))
          return true
        end
        return false
      end

  end
end