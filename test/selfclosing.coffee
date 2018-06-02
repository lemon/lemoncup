expect = require 'expect.js'
{render} = require '..'

describe 'Self Closing Tags', ->
  describe '<img />', ->
    it 'should render', ->
      expect(render -> img()).to.equal '<img />'
    it 'should render with attributes', ->
      expect(render -> img src: 'http://foo.jpg.to')
        .to.equal '<img src="http://foo.jpg.to" />'
  describe '<br />', ->
    it 'should render', ->
      expect(render -> br()).to.equal '<br />'
  describe '<link />', ->
    it 'should render with attributes', ->
      expect(render -> link href: '/foo.css', rel: 'stylesheet')
        .to.equal '<link href="/foo.css" rel="stylesheet" />'
