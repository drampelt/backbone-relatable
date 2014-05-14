Backbone.Relatable =
  version: '0.0.1'
  store: {}
  reset: ->
    Backbone.Relatable.store = {}

class Backbone.RelatableModel extends Backbone.Model
  @setup = (name = @name) ->
    return throw new Error 'Class name is already defined' if Backbone.Relatable.store[name]?
    Backbone.Relatable.store[name] =
      class: @

  @relation = (name, options) ->
    return throw new Error 'Missing name' unless name?
    return throw new Error 'Missing options' unless options?
    return throw new Error 'Missing type' unless options.type?
    return throw new Error 'Missing class' unless options.class?
    return throw new Error 'Missing inverse name' unless options.inverse?

    @prototype.relations = {} unless @prototype.relations?

    switch options.type
      when 'one'
        @prototype.relations[name] = options
      when 'many'
        @prototype.relations[name] = options
      else
        throw new Error "Invalid relation type: #{type}"

  constructor: (data) ->
    super data

    for name, options of @relations
      if data?.hasOwnProperty name
        obj = data[name]
        if obj instanceof Backbone.RelatableModel
          @[name] = obj
        else
          data = obj
          data[options.inverse] = @

          model = Backbone.Relatable.store[options.class]
          return throw new Error "Class name #{options.class} is not defined" unless model?

          @[name] = new model.class data
