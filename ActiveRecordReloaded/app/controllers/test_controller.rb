#require 'active_record_reloaded'
#require 'test_library'

class TestController < ApplicationController
  def index
#    @cls = ActiveRecordReloaded::Base
    @cls = TestLibrary
    @inst = @cls.new
    
    @output = @cls.all
    
  end
end
