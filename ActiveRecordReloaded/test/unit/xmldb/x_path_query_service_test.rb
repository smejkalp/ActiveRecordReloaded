require "test/unit"
require 'xmldb/database_manager'

class XPathQueryServiceTest < Test::Unit::TestCase
  
  def setup
    super
    dm = nil
    assert_nothing_raised do
      dm = XMLDB::DatabaseManager.new('./lib/xmldb/jar')
      
      db = dm.createDatabase()
      
      dm.registerDatabase(db)
    end
    
    assert_nothing_raised do
      @collection = dm.getCollection('exist://joe.mk.cvut.cz:8080/exist/xmlrpc/db/test');
    end
    
    assert_nothing_raised do
      @xquery = @collection.getService('XQueryService', '')
    end
    
  end
  
  def test_getters
    assert(@xquery.getName() != "")
    assert(@xquery.getVersion() != "")
  end
  
  def test_setCollection
    @xquery.setCollection(@collection)
  end
  
  def test_namespaces
    @xquery.clearNamespaces();
    
    @xquery.setNamespace("test", "testValue")
    
    assert(@xquery.getNamespace("test") == "testValue")
    
    @xquery.removeNamespace("test")
  end
  
  def test_query
    resourceSet = @xquery.query("//subnode")
    assert_not_nil(resourceSet)
    
    assert(resourceSet.getSize() > 0)
    
    assert(resourceSet.getMembersAsResource().getContent() != "")
    
    assert(resourceSet.getMembersAsResource().getContent() != "")
    
    iter = resourceSet.getIterator()
    
    assert_not_nil(iter)
    
    assert_not_nil(resourceSet.getResource(0))
    
    assert(resourceSet.getResource(0).getContent() != "")
  end
  
end