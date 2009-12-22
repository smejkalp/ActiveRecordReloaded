require "test/unit"

require 'xmldb/database_manager'

class ResourceTest < Test::Unit::TestCase
  
  def setup
    super
    
    dm = XMLDB::DatabaseManager.new('./lib/xmldb/jar')
    
    db = dm.createDatabase()
    
    dm.registerDatabase(db)
    
    @collection = dm.getCollection('exist://joe.mk.cvut.cz:8080/exist/xmlrpc/db/test')
    @resource  = @collection.getResource('testDocument')
  end
  
  def test_getParentCollection
    assert(@collection.getName() == @resource.getParentCollection().getName())
  end
  
  def test_getId
    assert(@resource.getId().length > 0)
  end
  
  def test_getSetcontent
    content = '<node attrib="value">text</node>'
    
    @resource.setContent(content)
    
    assert(content == @resource.getContent())
  end
  
end