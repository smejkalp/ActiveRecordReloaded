require "test/unit"

require 'xmldb/database_manager'

class DatabaseManagerTest < Test::Unit::TestCase
  
  def setup
    super
    
    @dm = XMLDB::DatabaseManager.new('./lib/xmldb/jar')
    
    db = @dm.createDatabase()
    
    @dm.registerDatabase(db)
  end
  
  def test_getCollection
    collection = @dm.getCollection('exist://joe.mk.cvut.cz:8080/exist/xmlrpc/db/test');
    assert(collection != nil, 'GetCollection returns nil.') 
    
    assert(collection.getName() == '/db/test', 'Collection returned wrong name:'+collection.getName()) 
  end
  
  def test_getResource
    collection = @dm.getCollection('exist://joe.mk.cvut.cz:8080/exist/xmlrpc/db/test');
    resource = collection.getResource('testDocument')
    
    assert(resource != nil, "getResource returned empty element")
    
    assert(resource.getId() == 'testDocument', 'Resource returned wrong name.')
  end
  
  def test_getContent
    collection = @dm.getCollection('exist://joe.mk.cvut.cz:8080/exist/xmlrpc/db/test');
    resource = collection.getResource('testDocument')
    
    assert(resource.getContent() != nil, 'Resource returned nil content.')
  end
end
