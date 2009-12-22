require "test/unit"

require 'xmldb/database_manager'

class CollectionTest < Test::Unit::TestCase
  
  def setup
    super
    
    dm = XMLDB::DatabaseManager.new('./lib/xmldb/jar')
    
    db = dm.createDatabase()
    
    dm.registerDatabase(db)
    
    @collection = dm.getCollection('exist://joe.mk.cvut.cz:8080/exist/xmlrpc/db/test');
  end
  
  def test_createId
    assert(@collection.createId() != '')
  end
  
  def test_createRemoveResource
    id = @collection.createId()
    res = @collection.createResource(id)
    assert(res != nil);
    
    res.setContent('<test/>')
    
    assert(res.getId() == id)
    
    @collection.storeResource(res)
    
    @collection.removeResource(res)
  end
  
  def test_getChildParentCollection
    
    assert(@collection.getChildCollectionCount() > 0) 
    
    subcol = @collection.getChildCollection('subtest')
    assert(subcol != nil)
    
    parent = subcol.getParentCollection()
    assert(parent.getName() == @collection.getName())
  end
  
  def test_listResources
    assert(@collection.listResources().length > 0)
  end
  
  def test_isOpen
    assert(@collection.isOpen() == true)
  end
  
  def test_getResourceCount
    assert(@collection.getResourceCount() > 0) 
  end
  
end