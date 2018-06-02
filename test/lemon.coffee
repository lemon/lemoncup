expect = require 'expect.js'
{render} = require '..'

describe 'Lemon Attributes', ->

  it 'class object attribute', ->
    template = -> br class: {c1: true, c2: false}
    expect(render template).to.equal '<br class="c1" />'

  it 'style object attribute', ->
    template = -> br style: {display: 'block', color: 'red'}
    expect(render template).to.equal '<br style="display:block;color:red" />'

  it 'on attribute', ->
    template = -> br on: {click: 'onClick', mouseover: ->}
    lemoncup.clear()
    expect(render template).to.equal '<br lemon-on:click="onClick" lemon-on:mouseover="0" />'

  it 'on shorthand', ->
    template = -> br $click: 'onClick', $mouseover: ->
    lemoncup.clear()
    expect(render template).to.equal '<br lemon-on:click="onClick" lemon-on:mouseover="0" />'

  it 'bind attribute', ->
    template = -> br bind: {text: 't', href: 'h', src: 's'}
    lemoncup.clear()
    expect(render template).to.equal '<br lemon-bind:text="t" lemon-bind:href="h" lemon-bind:src="s" />'

  it 'bind shorthand', ->
    template = -> br _text: 't', _href: 'h', _src: 's'
    lemoncup.clear()
    expect(render template).to.equal '<br lemon-bind:text="t" lemon-bind:href="h" lemon-bind:src="s" />'

  it 'ref', ->
    template = -> br ref: 'test'
    lemoncup.clear()
    expect(render template).to.equal '<br lemon-ref="test" />'

  it 'data (object)', ->
    template = -> br 'lemon-data': {key: 'val'}
    lemoncup.clear()
    expect(render template).to.equal '<br lemon-data="0" />'

  it 'data (array)', ->
    template = -> br 'lemon-data': [1, 2, 3]
    lemoncup.clear()
    expect(render template).to.equal '<br lemon-data="0" />'

  it 'data (string)', ->
    template = -> br 'lemon-data': 'test'
    lemoncup.clear()
    expect(render template).to.equal '<br lemon-data="0" />'

