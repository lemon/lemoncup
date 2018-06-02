expect = require 'expect.js'
{render} = require '..'

describe 'stack trace', ->
  it 'should contain tag names', ->
    template = ->
      div ->
        p ->
          throw new Error()
    try
      render template
    catch error
      expect(error.stack).to.contain 'div'
      expect(error.stack).to.contain 'p'
