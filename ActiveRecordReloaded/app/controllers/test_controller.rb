require 'active_record_reloaded'

class TestController < ApplicationController
  def index
    @cls = ActiveRecordReloaded::Base
    @inst = @cls.new
    
    #@output = @cls.all
    #@output = @cls.first
    @output = @cls.find(:all)
    
    if (!@output.is_a?(Array))
      element = @output
      @output = [ element ]
    end
    @output[0].text('zmeneny atribut text')
    
    inst2 = @cls.new
    inst2.autor('Karel')
    inst2.text('Karluv clanek')
    @output.push(inst2)
    @output.push(@cls.new)
  end
end
