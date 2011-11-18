# https://github.com/jashkenas/coffee-script/wiki/FAQ
namespace = (target, name, block) ->
	[target, name, block] = [(if typeof exports isnt "undefined" then exports else window), arguments...] if arguments.length < 3
	top    = target
	target = target[item] or= {} for item in name.split "."
	block target, top

## `Raisin.helper`
namespace "Raisin.helper", (exports, top) ->
	$ = jQuery

	exports.pretty_keyword = (keyword) ->
		keyword.name.replace /[a-z]+:/, "" #.humanize

	exports.sanitized_keyword = (keyword) ->
		keyword.name.replace /[^a-zA-Z0-9]/, "_"

	exports.keywords_as_classes = (keywords) ->
		(keywords.sort().map (keyword) ->
			Raisin.helper.sanitized_keyword keyword).join " "
