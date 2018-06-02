expect = require 'expect.js'
{render} = require '..'

describe 'tag', ->
  it 'renders text verbatim', ->
    expect(render -> p 'foobar').to.equal '<p>foobar</p>'

  it 'renders numbers', ->
    expect(render -> p 1).to.equal '<p>1</p>'
    expect(render -> p 0).to.equal '<p>0</p>'

  it 'renders Dates', ->
    date = new Date(2013,1,1)
    expect(render -> p date).to.equal "<p>#{date.toString()}</p>"

  it "renders undefined as ''", ->
    expect(render -> p undefined).to.equal "<p></p>"

  it 'renders empty tags', ->
    template = ->
      script src: 'js/app.js'
    expect(render template).to.equal('<script src="js/app.js"></script>')
