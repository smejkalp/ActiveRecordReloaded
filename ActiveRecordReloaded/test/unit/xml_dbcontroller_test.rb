require "test/unit"
require 'active_record_reloaded/dbcontrollers/xml/xml_dbcontroller'
require 'active_record_reloaded/base'

class XmlDbcontrollerTest < Test::Unit::TestCase
  
  def setup
    @mockDbController = ActiveRecordReloaded::Dbcontrollers::XmlDbcontroller.new
    assert true 
  end
  
  def test_find
    options = { :limit => 1, :order => "attrib2", :conditions => { :attrib2 => "val3" } }
    subnodes = Subnode.find( :all, options )
    assert subnodes.length == 1
    
    options = { :limit => 2, :order => "attrib2" }
    subnodes = Subnode.find( :all, options )
    assert subnodes.length == 2
    
    options = { :limit => 3, :order => "attrib2", :conditions => { :attrib2 => "val3" } }
    subnodes = Subnode.find( :all, options )
    subnodes.each { 
      |element|
      assert element.attrib2 == "val3"
    }
    
    newObj = Subnode.new
    newObj.save
    
    newObj.save
    
  end

  def test_attributes
    attributes = @mockDbController.attributes("Subnode")
    
    assert (attributes != nil) && (attributes.keys.length > 0)
  end
end

class Subnode < ActiveRecordReloaded::Base

end

