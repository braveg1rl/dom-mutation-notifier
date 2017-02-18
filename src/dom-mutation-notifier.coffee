EventEmitter = require('events').EventEmitter

nodeTypeNames =
  1: "element"
  2: "attribute"
  3: "text"
  8: "comment"

module.exports = class DOMMutationNotifier
  constructor: (el, options={}) ->
    options.childList ?= true
    unless el instanceof HTMLElement
      throw new Error "Fist argument must be a HTMLElement."
    unless options.childList or options.attributes or options.characterData
      throw new Error "Neither childList, attributes or characterData chosen."
    emitter = new EventEmitter
    observer = new MutationObserver (mutations) =>
      for mutation in mutations
        for addedNode in mutation.addedNodes
          emitter.emit "#{nodeTypeNames[addedNode.nodeType]}Added", addedNode
        for removedNode in mutation.removedNodes
          emitter.emit "#{nodeTypeNames[removedNode.nodeType]}Removed", removedNode
      undefined
    listenerLists = {}
    for number, name of nodeTypeNames
      listenerLists["#{name}Added"] = []
      listenerLists["#{name}Removed"] = []
    isRunning = false
    start = ->
      observer.observe el, options
      isRunning = true
    stop = ->
      observer.disconnect()
      isRunning = false
    @on = (eventName, listener) ->
      throw new Error "Invalid event name '#{eventName}'" unless listenerLists[eventName]
      listenerLists[eventName].push listener
      emitter.on eventName, listener
      start() unless isRunning
    @off = (eventName, listener) ->
      throw new Error "Invalid event name '#{eventName}'" unless listenerLists[eventName]
      listenerList = listenerLists[eventName]
      listenerPosition = listenerList.indexOf listener
      throw new Error "Function was not a listener for '#{eventName}'" unless listenerPosition >= 0
      listenerList.splice listenerPosition, 1
      numListeners = 0
      numListeners += listenerList.length for name, listenerList of listenerLists
      stop() if isRunning and numListeners is 0
