require 'minitest/autorun'
require_relative '../lib/timely.rb'

describe Timely do

  before do
    @time = Timely.parse("17h UTC to EST")
  end

  describe "#parse" do

    it "should return a msg" do
      assert_instance_of String, @time 
    end

    it "should convert timezones" do
      @time.must_equal "Fri Feb 25 17:00 -> Fri Feb 25 12:00"
    end

    it "warns about bad requests" do
      Timely.parse("1").must_equal Timely.syntax_error
    end

  end

end
