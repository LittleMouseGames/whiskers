# Node types
The following node types are supported in your settings.gd:
* Text
* LineEdit
* OptionButton

To delcare your node type, use `"type": {{TYPE}}`

If no type is declared the default fallback is `LineEdit'

### LineEdit / Text
To delcare a LineEdit, use type `line`. To declare a `Text` element, use type `Text`.

Text and LineEdit types support the `readonly` attribute ( defaults to false ) and the `placeholder` attribute.

### OptionButton
To declare an OptionButton element, use type `option`.

OptionButtons allow you to declare your options using an `options` array.

OptionButtons allow you to use characters as your selection. To do this use the `character_select` attribute ( defaults to false )

