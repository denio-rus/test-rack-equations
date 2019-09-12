require_relative '../app'
require_relative '../equation_solver'
require 'rack'

RSpec.describe App do
  let(:quad_equation) { { 'a_param' => 1, 'b_param' => -8, 'c_param' => 12, 'type' => 'quadratic' } }

  let(:env) { Rack::MockRequest.env_for('http://local:9292/solve_equation', method: :post, input: quad_equation.to_json)}
  let(:answer) { [200, { 'Content-Type' => 'application/json' }, [{ result: [6.0, 2.0] }.to_json]] }

  let(:env_invalid_path) { Rack::MockRequest.env_for('http://local:9292/reshit_equation', method: :post, input: quad_equation.to_json)}
  let(:env_invalid_method) { Rack::MockRequest.env_for('http://local:9292/solve_equation', method: :get, input: quad_equation.to_json)}
  let(:answer_for_unknown_route) { [404, { 'Content-Type' => 'application/json' }, []] }

  let(:env_without_json) { Rack::MockRequest.env_for('http://local:9292/solve_equation', method: :post) }
  let(:answer_for_req_without_json) { [400, { 'Content-Type' => 'application/json' }, ['Need equation in json']] }

  let(:lin_equation_missed_a_param) { {  'b_param' => -12, 'type' => 'linear' } }
  let(:env_with_invalid_equation) { Rack::MockRequest.env_for('http://local:9292/solve_equation', method: :post, input: lin_equation_missed_a_param.to_json)}
  let(:answer_for_req_with_invalid_equation) { [400, { 'Content-Type' => 'application/json' },  ["{\"error\":\"Invalid a_param\"}"]] }

  it 'anwers with result in json format' do
    expect(App.new.call(env)).to eq answer
  end

  it 'anwers with 404 status then requisted wrong path' do
    expect(App.new.call(env_invalid_path)).to eq answer_for_unknown_route
  end

  it 'anwers with 404 status then requisted wrong method' do
    expect(App.new.call(env_invalid_method)).to eq answer_for_unknown_route
  end

  it 'anwers with 400 status then requisted wrong method' do
    expect(App.new.call(env_without_json)).to eq answer_for_req_without_json
  end

  it 'anwers with 400 status with error-json-body then has problems with equation solver' do
    expect(App.new.call(env_with_invalid_equation)).to eq answer_for_req_with_invalid_equation
  end
end
