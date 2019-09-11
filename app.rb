require_relative 'equation_solver'
require 'json'

class App
  def call(env)
    @request = Rack::Request.new(env)
    return not_found_response if unknown_route?

    get_equation_params
    return no_json_given_response unless equation_json_given?

    response
  end

  private

  def headers
    { 'Content-Type' => 'application/json' }
  end

  def unknown_route?
    !@request.post? || @request.path != '/solve_equation'
  end

  def not_found_response
    [404, headers, []]
  end

  def get_equation_params
    @req_body = @request.body.read
    @equation = JSON.parse(@req_body) unless @req_body.empty?
  end

  def equation_json_given?
    !@equation.nil?
  end

  def no_json_given_response
    [400, headers, ['Need equation in json']]
  end

  def response
    result = EquationSolver.new(@equation).solve
    [200, headers, [{ result: result }.to_json]]

  rescue StandardError => e
    [400, headers, [{ error: "#{e.message}"}.to_json]]
  end
end
