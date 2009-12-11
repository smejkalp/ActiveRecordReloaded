require 'active_record_reloaded'

class TestController < ApplicationController
  def index
    @cls = ActiveRecordReloaded::Base
    @inst = @cls.new
    
    @output = @cls.all
  end
end
