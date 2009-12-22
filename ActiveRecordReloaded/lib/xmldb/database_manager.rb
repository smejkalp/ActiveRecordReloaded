require 'rjb'

require 'xmldb/base/database'

module XMLDB
  
  class DatabaseManager
    
    ##
    # initialize XMLDB api
    #
    
    def initialize (libDir = ".")
      Rjb::load('.', ['-Djava.ext.dirs='+libDir])
      
      str = Rjb::import('java.lang.String')
      if(str == nil)
        raise 'Rjb initialisation failed!'
      end
      
      @db = []
      
    end
    
    ##
    # Create Database instance of specified class
    #
    
    def createDatabase (databaseClass = 'org.exist.xmldb.DatabaseImpl')  
      db = Rjb::import(databaseClass).new
      if(db == nil)
        raise 'Cannot instantiate XML:DB Database '+databaseClass+'. Wrong lib dir?'
      end
      
      return  XMLDB::Base::Database.getInstance(db)
      
    end
    
    ##
    # Deregisters a Database implementation from the DatabaseManager.
    #
    
    def deregisterDatabase(database)
      @db.delete(database)
    end
    
    ##
    # Retrieves a Collection instance from the database for the given URI. 
    
    def getCollection(uri, username = 'guest', password = 'guest') 
      return choose(uri).getCollection(uri, username, password)
    end
    
    ##
    # Returns the Core Level conformance value for the provided URI. 
    def getConformanceLevel(uri)
      return choose(uri).getConformanceLevel(uri)
    end
    
    ##
    # Returns a list of all available Database implementations that have been registered with this DatabaseManager.
    def getDatabases() 
      return @db
    end
    
    ##
    # Retrieves a property that has been set for the DatabaseManager.
    
    def getProperty(name)
    end
    
    ##
    # Registers a new Database implementation with the DatabaseManager.
    def registerDatabase(database)
      @db << database
    end
    
    ##
    # Stores the provided resource into the database.
    
    def setProperty(name, value)
    end
    
    def choose(uri)
      @db.each {|d| if(d.acceptsURI(uri))then return d end}
        raise "Cannot handle UIR "+uri
      end
    end
  end
