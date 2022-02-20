class BasePresenter
  # Define a class level instance variable
  @build_attributes = []


  # open the door to class methods
  class << self
    # Define an accessor for the class level instance
    # variable we created above
    attr_accessor :build_attributes


    # Create the actual class method that will
    # be used in the subclasses
    # We use the splash operation '*' to get all
    # the arguments passed in an array
    def build_with(*args)
      @build_attributes = args.map(&:to_s)
    end
  end

  attr_accessor :object, :params, :data

  def initialize(object, params, options = {})
    @object = object
    @params = params
    @options = options
    @data = HashWithIndifferentAccess.new
  end

  def as_json(*)
    @data
  end
end
