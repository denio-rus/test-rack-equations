
class EquationSolver
  def initialize(equation)
    @equation = equation
    validate_params
  end

  def solve
    if @equation['type'] == 'linear'
      solve_linear_equation
    else
      solve_quadratic_equation
    end
  end

  private

  def validate_params
    raise ArgumentError, "A param must be not equal to zero" if @equation['a_param'] == 0
    
    ['a', 'b', 'c'].each do |letter| 
      raise "Invalid #{letter}_param" unless @equation["#{letter}_param"].is_a? Float
    end
  end

  def solve_linear_equation
    -@equation['b_param'] / @equation['a_param']
  end

  def solve_quadratic_equation
    QuadraticEquationSolver.new(@equation['a_param'], @equation['b_param'], @equation['c_param']).solve
  end

  class QuadraticEquationSolver
    def initialize(a, b, c)
      @a = a
      @b = b
      @c = c
    end

    def solve
      return "No roots" if discriminant < 0
      
      if discriminant > 0
        x1 = (-@b + Math.sqrt(discriminant))/(2*@a)
        x2 = (-@b - Math.sqrt(discriminant))/(2*@a)
        [x1, x2]
      else discriminant == 0
        (-@b)/(2*@a)
      end
    end

    def discriminant
     @discriminant ||= @b**2 - 4 * @a * @c
    end
  end
end