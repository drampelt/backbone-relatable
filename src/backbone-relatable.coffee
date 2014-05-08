class Backbone.RelatableModel extends Backbone.Model
  @relation = (name, options) ->
    return throw new Error 'Missing name' unless name?
    return throw new Error 'Missing options' unless options?
    return throw new Error 'Missing type' unless options.type?
    return throw new Error 'Missing class' unless options.class?
    return throw new Error 'Missing inverse name' unless options.inverse?

    @prototype.relations = {} unless @prototype.relations?

    switch options.type
      when 'one'
        return throw new Error 'Class is not a backbone model' unless options.class.prototype instanceof Backbone.Model
        @prototype.relations[name] = options
      when 'many'
        return throw new Error 'Class is not a backbone collection' unless options.class.prototype instanceof Backbone.Collection
        @prototype.relations[name] = options
      else
        throw new Error "Invalid relation type: #{type}"
