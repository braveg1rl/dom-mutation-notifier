# dom-mutation-notifier [![Build Status](https://travis-ci.org/braveg1rl/dom-mutation-notifier.png?branch=master)](https://travis-ci.org/braveg1rl/dom-mutation-notifier) [![Dependency Status](https://david-dm.org/braveg1rl/dom-mutation-notifier.png)](https://david-dm.org/braveg1rl/dom-mutation-notifier)

Friendly interface for [MutationObserver](https://developer.mozilla.org/en/docs/Web/API/MutationObserver).
Eight events are implemented: `(element|attribute|text|comment)(Added|Removed)`

The constructor takes the same arguments as the `observe` method of `MutationObserver`.
If no options are provided, `childList` will be watched by default.

MutationNotifier will only start observing when a valid event listener is added (with `on`). It will stop observing if all listeners have been removed (with `off`).

## Usage

```javascript
var MutationNotifier = require("dom-mutation-notifier")

var notifier = new MutationNotifier(document.querySelector("body"))
var addListener = function(element) {}
var rmListener = function(element) {}
notifier.on("elementAdded", addListener)
// Observing starts
notifier.on("elementRemoved", rmListener)
notifier.off("elementAdded", addListener)
notifier.off("elementRemoved", rmListener)
// Observing ends
```

## License

dom-mutation-notifier is released under the [MIT License](http://opensource.org/licenses/MIT).
Copyright (c) 2017 Braveg1rl
