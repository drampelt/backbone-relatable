window.onload = ->
  mocha.ui 'bdd'
  mocha.reporter 'html'

  window.should = chai.should()
  window.assert = chai.assert
  window.expect = chai.expect

  # TESTS

  describe 'Backbone Relatable', ->
    beforeEach ->
      Backbone.Relatable.reset()

    it 'should be defined', ->
      expect(Backbone.RelatableModel).to.exist

    describe 'Defining Relations', ->
      TestModel = TestModel2 = TestCollection = model = null

      beforeEach ->
        class TestModel2 extends Backbone.RelatableModel
          @setup()
        class TestCollection extends Backbone.Collection

        class TestModel extends Backbone.RelatableModel
          @setup()
          @relation 'something', type: 'one', inverse: 'test', class: TestModel2
          @relation 'test2', type: 'many', inverse: 'test', class: TestCollection

        model = new TestModel

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

    describe 'Instantiating Models', ->
      TestModel = TestModel2 = TestCollection = null
      beforeEach ->
        class TestModel2 extends Backbone.RelatableModel
          @setup()
          @relation 'one', type: 'one', inverse: 'two', class: 'TestModel'
        class TestCollection extends Backbone.Collection
        class TestModel extends Backbone.RelatableModel
          @setup()
          @relation 'two', type: 'one', inverse: 'one', class: 'TestModel2'
          # TODO: test collections

      it 'should be possible', ->
        expect(->
          new TestModel()
        ).to.not.throw Error

      it 'should define the relations', ->
        m2 = new TestModel2
        m = new TestModel two: m2

        expect(m.two).to.exist

      it 'should have the correct relations', ->
        m2 = {some: 'data'}
        m = new TestModel two: m2

        expect(m.two instanceof TestModel2).to.be.true

      it 'should define inverse relations', ->
        m2 = {some: 'data'}
        m = new TestModel two: m2

        expect(m.two.one).to.equal m

  # START THE TESTS
  if window.mochaPhantomJS
    mochaPhantomJS.run()
  else
    mocha.run()

