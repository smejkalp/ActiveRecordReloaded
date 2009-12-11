require 'active_record_reloaded/dbcontrollers/mock/mock_dbcontroller'

module ActiveRecordReloaded
  
  class Base
    
    @dbcontroller = ActiveRecordReloaded::Dbcontrollers::MockDbcontroller.new
    
    
    
    ################## PUBLIC CLASS METHODS ######################
    def self.all
      find(:all)
    end
    
    def self.first(*args)
      find(:first, *args)
    end
    
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
    def save
      # pouhy nastrel rozhodovani zda provest insert nebo update objektu pri ukladani
      hashmap = convertToMap
      if (hasPrimaryKey == false)
        hashmap = @dbcontroller.insert(hashmap)
      else
        hashmap = @dbcontroller.update(hashmap)
      end
      
      convertToObject(hashmap)
    end
    
    def destroy
      
    end
    
    
    
    ################## PRIVATE METHODS ######################
    protected
      def self.find_first(options)
        options.update(:limit => 1)
        find_every(options).first
      end
      
      def self.find_last(options)
        raise 'Method not implemented'
      end
      
      def self.find_every(options)
        options = process_find_options(options)
        @dbcontroller.find(options)
      end
      
    
    
      def hasPrimaryKey
        # pravidlo, podle nehoz se ma rozhodnout zda provest insert nebo update
        true
      end
    
      def convertToMap
        # prevede sve vnitrni promenne do hash mapy pro poslani nizsim vrstvam
      end
    
      def convertToObject(hashmap)
        # prevede hash mapu z nizsich vrstev do objektu
      end
    
      def self.process_find_options(options)
        # zpracuje vyhledavaci parametry tak, aby jim rozumely nizsi vrstvy
      end
  end
end