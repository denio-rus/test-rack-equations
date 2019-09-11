require_relative 'equation_solver'
require 'json'

class App
  def call(env)
    @request = Rack::Request.new(env)

    return not_found_response if unknown_route?
    return no_json_given_response unless equation_json_given?
    response
  end

  private

  def not_found_response
    [404, headers, []]
  end

  def no_json_given_response
    [400, headers, ['Need equation in json']]
  end

  def unknown_route?
    !@request.post? || @request.path != '/solve_equation'
  end

  def response
    result = EquationSolver.new(@equation).solve
    [200, headers, [{ result: result }.to_json]]

  rescue StandardError => e
    [400, headers, [{ error: "#{e.message}"}.to_json]]
  end

  def headers
    { 'Content-Type' => 'application/json' }
  end

  def equation_from_request
    @equation = JSON.parse(@request.body.read)
  end

  def equation_json_given?
    equation_from_request.any?
  end
end
