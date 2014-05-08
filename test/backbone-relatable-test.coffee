window.onload = ->
  mocha.ui 'bdd'
  mocha.reporter 'html'

  window.should = chai.should()
  window.assert = chai.assert
  window.expect = chai.expect

  # TESTS

  describe 'Backbone Relatable', ->
    it 'should be defined', ->
      expect(Backbone.RelatableModel).to.exist

    describe 'Defining Relations', ->
      class TestModel2 extends Backbone.RelatableModel
      class TestCollection extends Backbone.Collection

      class TestModel extends Backbone.RelatableModel
        @relation 'something', type: 'one', inverse: 'test', class: TestModel2
        @relation 'test2', type: 'many', inverse: 'test', class: TestCollection

      model = null

      beforeEach ->
        model = new TestModel()

      it 'should be possible', ->
        expect(model.relations).to.exist

      it 'should throw an error if no parameters are given', ->
        expect(->
          Backbone.RelatableModel.relation()
        ).to.throw Error

      it 'should throw an error if no options are given', ->
        expect(->
          Backbone.RelatableModel.relation 'name'
        ).to.throw Error

      it 'should throw an error if invalid options are given', ->
        expect(->
          Backbone.RelatableModel.relation 'test', type: 'invalid'
        ).to.throw Error

      it 'should throw an error if an invalid model is given', ->
        expect(->
          Backbone.RelatableModel.relation 'test2', type: 'one', inverse: 'test', class: undefined
        ).to.throw Error

      it 'should populate the relations object', ->
        expect(model.relations['something']).to.exist


  # START THE TESTS
  if window.mochaPhantomJS
    mochaPhantomJS.run()
  else
    mocha.run()

