assert = require "assert"

DOMMutationNotifier = require "../"

callsToObserve = 0
callsToDisconnect = 0

global.MutationObserver = class MutationObserver
  observe: -> callsToObserve++
  disconnect: -> callsToDisconnect++
global.HTMLElement = class HTMLElement

el = new HTMLElement

describe "DOMMutationNotifier", ->
  describe "constructor", ->
    it "works without passing any options", ->
      notifier = new DOMMutationNotifier el

    it "throws when first argument is not a HTMLElement", ->
      assert.throws ->
        notifier = new DOMMutationNotifier true

    it "throws when childList, attributes, and characterData are falsy", ->
      assert.throws ->
        notifier = new DOMMutationNotifier el,
          childList: false
          attributes: false
          characterData: false

    it "does not call observe", ->
      notifier = new DOMMutationNotifier el
      assert.equal callsToObserve, 0

  describe "instance", ->
    notifier = undefined
    listener = -> true
    
    before ->
      notifier = new DOMMutationNotifier el

    describe "on", ->
      it "calls observe", ->
        notifier.on "elementAdded", listener
        assert.equal callsToObserve, 1
      it "doesn't call observe twice", ->
        notifier.on "elementAdded", listener
        assert.equal callsToObserve, 1

    describe "off", ->
      it "doesn't call disconnect at first", ->
        notifier.off "elementAdded", listener
        assert.equal callsToDisconnect, 0
      it "does call disonnect after two times", ->
        notifier.off "elementAdded", listener
        assert.equal callsToDisconnect, 1
