require_relative '../equation_solver'

RSpec.describe EquationSolver do
  let(:quad_equation_pos_discr) { { 'a_param' => 1, 'b_param' => -8, 'c_param' => 12, 'type' => 'quadratic' } }
  let(:quad_equation_neg_discr) { { 'a_param' => 5, 'b_param' => 3, 'c_param' => 7, 'type' => 'quadratic' } }
  let(:quad_equation_zero_discr) { { 'a_param' => 1, 'b_param' => -6, 'c_param' => 9, 'type' => 'quadratic' } }
  let(:quad_equation_invalid_param) { { 'a_param' => '3', 'b_param' => -8, 'c_param' => 12, 'type' => 'quadratic' } }
  let(:quad_equation_missed_param) { { 'a_param' => 1, 'b_param' => -6, 'type' => 'quadratic' } }
  let(:quad_equation_missed_a_param) { { 'a_param' => 1, 'b_param' => -6, 'type' => 'quadratic' } }
  let(:lin_equation) { { 'a_param' => 2, 'b_param' => -12, 'type' => 'linear' } }
  let(:lin_equation_invalid) { { 'a_param' => 2, 'b_param' => '-12', 'type' => 'linear' } }
  let(:lin_equation_unnecessary_param) { { 'a_param' => 2, 'b_param' => -12, 'c_param' => 12, 'type' => 'linear' } }
  let(:lin_equation_missed_a_param) { {  'b_param' => -12, 'type' => 'linear' } }

  it 'returns an array of roots if Discriminant is positive' do
 	  expect(EquationSolver.new(quad_equation_pos_discr).solve).to eq([6.0, 2.0])
  end

  it "returns string 'No roots' if Discriminant is negative" do
 	  expect(EquationSolver.new(quad_equation_neg_discr).solve).to eq('No roots')
  end

  it "returns number if Discriminant is equal to zero" do
 	  expect(EquationSolver.new(quad_equation_zero_discr).solve).to eq(3.0)
  end

  it "returns root if given two number arguments" do
 	  expect(EquationSolver.new(lin_equation).solve).to eq(6)
  end

  it 'raises exeption if wrong param given' do
    expect { EquationSolver.new(quad_equation_invalid_param) }.to raise_error(ArgumentError)
  end

  it 'raises exeption if wrong param given' do
    expect { EquationSolver.new(lin_equation_invalid) }.to raise_error(ArgumentError)
  end

  it 'raises exeption if wrong number of params given to quadratic' do
    expect { EquationSolver.new(quad_equation_missed_param) }.to raise_error(ArgumentError)
  end

  it 'raises exeption if wrong number of params given to linear' do
    expect { EquationSolver.new(lin_equation_unnecessary_param) }.to raise_error(ArgumentError)
  end

  it 'raises exeption if a param is not given' do
    expect { EquationSolver.new(quad_equation_missed_a_param) }.to raise_error(ArgumentError)
    expect { EquationSolver.new(lin_equation_missed_a_param) }.to raise_error(ArgumentError)
  end
end
