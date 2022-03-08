class EagerLoader

  def initialize(scope, params)
    @scope = scope
    @presenter = "#{@scope.model}Presenter".constantize
    @embed = params[:embed] ? params[:embed].split(',') : []
    @include = params[:include] ? params[:include].split(',') : []
  end

  def load
    return @scope unless @embed.any? || @include.any?
    validate!('embed', @embed)
    validate!('include', @include)

    (@embed + @include).each do |relation|
      @scope = @scope.includes(relation)
    end
    @scope
  end

  private

  def validate!(name, params)
    params.each do |param|
      unless @presenter.relations.include?(param)
        raise QueryBuilderError.new("#{name}=#{param}"),
          "Invalid #{name}. Allowed relations: #{@presenter.relations.join(',')}"
      end
    end
  end

end
