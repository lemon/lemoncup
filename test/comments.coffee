expect = require 'expect.js'
{render} = require '..'

describe 'Comments', ->
  it 'renders HTML <!--comments-->', ->
    template = -> comment "Comment"
    expect(render template).to.equal '<!--Comment-->'
