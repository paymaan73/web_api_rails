class BasePresenter
  # Define a class level instance variable
  CLASS_ATTRIBUTES = {
    build_with: :build_attributes,
    related_to: :relations,
    sort_by: :sort_attributes,
    filter_by: :filter_attributes
  }

  CLASS_ATTRIBUTES.each { |k, v| instance_variable_set("@#{v}", []) }

  # open the door to class methods
  class << self
    # Define an accessor for the class level instance
    # variable we created above
    attr_accessor *CLASS_ATTRIBUTES.values

    CLASS_ATTRIBUTES.each do |k, v|
      define_method k do |*args|
        instance_variable_set("@#{v}", args.map(&:to_s))
      end
    end


    # Create the actual class method that will
    # be used in the subclasses
    # We use the splash operation '*' to get all
    # the arguments passed in an array
    def build_with(*args)
      @build_attributes = args.map(&:to_s)
    end

    # Add a bunch of methods that will be used in the
    # model presenter
    def related_to(*args)
      @relations = args.map(&:to_s)
    end

    def sort_by(*args)
      @sort_attributes = args.map(&:to_s)
    end

    def filter_by(*args)
      @filter_attributes = args.map(&:to_s)
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
