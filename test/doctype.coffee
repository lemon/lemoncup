expect = require 'expect.js'
{render} = require '..'

describe 'doctype', ->
  it 'default should render html5 doctype', ->
    template = -> doctype()
    expect(render template).to.equal '<!DOCTYPE html>'
  it '5 should render html 5 doctype', ->
    template = -> doctype 5
    expect(render template).to.equal '<!DOCTYPE html>'
