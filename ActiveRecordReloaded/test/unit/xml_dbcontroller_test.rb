require "test/unit"
require 'active_record_reloaded/dbcontrollers/xml/xml_dbcontroller'
require 'active_record_reloaded/base'

class XmlDbcontrollerTest < Test::Unit::TestCase
  
  def setup
    @mockDbController = ActiveRecordReloaded::Dbcontrollers::XmlDbcontroller.new
    assert true 
  end
  
  def test_find
    subnode = Subnode.new
    subnode.attrib2 "value1"
    subnode.save
    subnode = Subnode.new
    subnode.attrib2 "value1"
    subnode.save
    subnode = Subnode.new
    subnode.attrib2 "value1"
    subnode.save
    
    options = { :limit => 1, :order => "attrib2", :conditions => { :attrib2 => "value1" } }
    subnodes = Subnode.find( :all, options )
    assert subnodes.length == 1
    
    options = { :limit => 2, :order => "attrib2" }
    subnodes = Subnode.find( :all, options )
    assert subnodes.length == 2
    
    options = { :limit => 3, :order => "attrib2", :conditions => { :attrib2 => "value1" } }
    subnodes = Subnode.find( :all, options )
    subnodes.each { 
      |element|
      assert element.attrib2 == "value1"
    }
  end
  
  def test_update
    newObj1 = Subnode.new
    newObj2 = Subnode.new
    newObj1.attrib2 "Obj1 - value1"
    newObj2.attrib2 "Obj2 - value1"
    newObj2.save
    newObj1.save
    newObj1.attrib2 "Obj1 - value2"
    newObj1.save
    newObj1.destroy
    
    
    
  end
  
  def test_insert
    newObj1 = Subnode.new
    newObj2 = Subnode.new
    newObj1.attrib2 "value1"
    
    newObj2.save
    newObj1.save
    
    assert newObj2._ID_.to_i < newObj1._ID_.to_i
    
    #----
    objectWithArray = Subnode.new
    objectWithArray.attrib1 ['field1', 'field2', 'field3', 'field4']
    objectWithArray.save
    options = { :limit => 1, :conditions => { :_ID_ => objectWithArray._ID_ } }
    foundObjects = Subnode.find(:all, options)
    loadedObjectWithArray = foundObjects.first
    loadedObjectWithArray.attrib1.each_with_index { |element, idx|
      assert objectWithArray.attrib1[idx] == element
    }
    #----
    objectWithHash = Subnode.new
    hash = { :key1 => "value1", :key2 => "value2", :key3 => "value3" }
    objectWithHash.attrib1 hash
    objectWithHash.save
    options = { :limit => 1, :conditions => { :_ID_ => objectWithHash._ID_ } }
    foundObjects = Subnode.find(:all, options)
    loadedObjectWithHash = foundObjects.first
    loadedObjectWithHash.attrib1.each_pair { |key, value|
      assert hash[key] == value
    }
    #----
    objectWithObject = Subnode.new
    propertyObject = Subnode.new
    propertyObject.attrib1 "attrib1 of propertyObject"
    propertyObject.attrib2 "attrib2 of propertyObject"
    objectWithObject.attrib1 propertyObject
    objectWithObject.save
    options = { :limit => 1, :conditions => { :_ID_ => objectWithObject._ID_ } }
    foundObjects = Subnode.find(:all, options)
    loadedObjectWithObject = foundObjects.first
    assert loadedObjectWithObject.attrib1.attrib1 == "attrib1 of propertyObject"
    assert loadedObjectWithObject.attrib1.attrib2 == "attrib2 of propertyObject"
    
    
    #----
    objectWithArrayAndHashOfObjects = Subnode.new
    arrayObject1 = Subnode.new
    arrayObject1.attrib1 "attrib1 of arrayObject1"
    arrayObject1.attrib2 "attrib2 of arrayObject1"
    arrayObject2 = Subnode.new
    arrayObject2.attrib1 "attrib1 of arrayObject2"
    arrayObject2.attrib2 "attrib2 of arrayObject2"
    arrayObject3 = Subnode.new
    arrayObject3.attrib1 "attrib1 of arrayObject3"
    arrayObject3.attrib2 "attrib2 of arrayObject3"
    arrayObject4 = Subnode.new
    arrayObject4.attrib1 "attrib1 of arrayObject4"
    arrayObject4.attrib2 "attrib2 of arrayObject4"
    
    objectWithArrayAndHashOfObjects.attrib1 [arrayObject1, arrayObject2, arrayObject3, arrayObject4]
    hashOfObjects = { :obj1 => arrayObject1, :obj2 => arrayObject2, :obj3 => arrayObject3, :obj4 => arrayObject4 }
    objectWithArrayAndHashOfObjects.attrib2 hashOfObjects
    objectWithArrayAndHashOfObjects.save
    
    options = { :limit => 1, :conditions => { :_ID_ => objectWithArrayAndHashOfObjects._ID_ } }
    foundObjects = Subnode.find(:all, options)
    loadedObjectWithArrayAndHashOfObjects = foundObjects.first
    loadedObjectWithArrayAndHashOfObjects.attrib1.each_with_index { |element, idx|
      assert objectWithArrayAndHashOfObjects.attrib1[idx].attrib1 == element.attrib1
      assert objectWithArrayAndHashOfObjects.attrib1[idx].attrib2 == element.attrib2
    }
    loadedObjectWithArrayAndHashOfObjects.attrib2.each_pair { |key, value|
      assert objectWithArrayAndHashOfObjects.attrib2[key].attrib1 == value.attrib1
      assert objectWithArrayAndHashOfObjects.attrib2[key].attrib2 == value.attrib2
    }
    
  end
  
  def test_delete
    newObj1 = Subnode.new
    newObj1.save
    id = newObj1._ID_.to_i
    
    newObj1.destroy
    
    newObj1.save
    
    assert id < newObj1._ID_.to_i
    
  end

  def test_attributes
    attributes = @mockDbController.attributes("Subnode")
    
    assert (attributes != nil) && (attributes.keys.length > 0)
  end
end

class Subnode < ActiveRecordReloaded::Base

end

