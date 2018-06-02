expect = require 'expect.js'
{render} = require '..'

describe 'text', ->
  it 'renders text verbatim', ->
    expect(render -> text 'foobar').to.equal 'foobar'

  it 'renders numbers', ->
    expect(render -> text 1).to.equal '1'
    expect(render -> text 0).to.equal '0'

  it 'is assumed when it is returned from contents', ->
    template = -> h1 -> 'hello world'
    expect(render template).to.equal '<h1>hello world</h1>'
    template = -> h1 '.title', -> 'hello world'
    expect(render template).to.equal '<h1 class="title">hello world</h1>'
    template = -> h1 class: 'title', -> 'hello world'
    expect(render template).to.equal '<h1 class="title">hello world</h1>'
    template = -> h1 '.title', -> text 'hello world'
    expect(render template).to.equal '<h1 class="title">hello world</h1>'
