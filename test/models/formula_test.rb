require 'test_helper'

class FormulaTest < ActiveSupport::TestCase
  test '#comments don\'t allow unicode encoding' do
    @formula = Formula.new
    @formula.comments = "this has a unicode char: \u2713".encode('utf-8')

    refute @formula.valid?
    assert_equal "has invalid character encoding: U+2713 from UTF-8 to US-ASCII", @formula.errors[:comments][0]
  end

  test '#comments allow ascii encoding' do
    @formula = Formula.new(code: 'test', state: :open)
    @formula.comments = "this has an ascii char".encode('utf-8')

    assert @formula.valid?
  end
end
