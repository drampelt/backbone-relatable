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

    describe 'Relations', ->
      model = null

      beforeEach ->
        class TestModel extends Backbone.RelatableModel

        model = new TestModel()

      it 'should exist', ->
        expect(model.relations).to.exist





  # START THE TESTS
  if window.mochaPhantomJS
    mochaPhantomJS.run()
  else
    mocha.run()

