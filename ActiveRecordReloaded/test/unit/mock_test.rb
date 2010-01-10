require "test_helper"
class MockTest < ActiveSupport::TestCase
  # Testuje metodu Mock.all
  def test_all
    @all = TestLibrary.all
    if @all.empty?
      assert false, "Prazdny vysledek"
    end
    
    if @all.length < 2
      assert false, "Prilis kratky vysledek"
    end
    
    assert true 
  end
  
  # Testuje metodu Mock.first
  def test_first
    @first = TestLibrary.first(:order => "asc")
    
    if @first == nil
      assert false, "Vratilo se nil"
    end
    
    if @first.empty?
      assert false, "Prazdny vysledek"
    end
    
    assert true
  end
  
  # Testuje metodu Mock.find
  def test_find_all
    @found = TestLibrary.find( :all, :limit => 10, :order => 'sloupec' ) 
    
    if @found == nil
      assert false, "Vratilo se nil"
    end
    
    if @found.empty?
      assert false, "Prazdny vysledek"
    end
    
    if @found.length < 2
      assert false, "Prilis kratky vysledek"
    end
    
    assert true
  end
  
  # Testuje metodu Mock.find
  def test_find_first
    @found = TestLibrary.find( :first, :order => 'sloupec' ) 
    
    if @found == nil
      assert false, "Vratilo se nil"
    end
    
    if @found.empty?
      assert false, "Prazdny vysledek"
    end
    
    assert true
    
  end
  
  # Testuje metodu Mock.attribute_names
  def test_attribute_names
    @inst = TestLibrary.new
    
    @result = @inst.attribute_names
    if @result == nil
      assert false, "Vratilo se nil"
    end
    
    assert true
  end
  
  # Testuje metodu Mock.save pri update objektu
  def test_save_update
    @found = TestLibrary.find( :first, :order => 'sloupec' )
    
    if @found == nil
      assert false, "Vratilo se nil"
    end
    
    @found.autor = "Pepa"
    
    if @found.save.is_a? Numeric
      assert true
    else    
      assert false, @found.save
    end
  end
  
  # Testuje metodu Mock.save pri insert objektu
  def test_save_insert
    @new = TestLibrary.new
    @new.autor = "Novy"
    @new.text = "La la la la..."
    
    if @new.save.is_a? Numeric
      assert true
    else 
      assert false, "Nepodarilo se ulozit"
    end
  end
  
  # Testuje metodu Mock.destroy
  def test_destroy
    
  end
end