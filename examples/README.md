# Examples

## Windows Terminal JSON Fragment Extensions

Windows Terminal allows profiles to be added or modified outside of the main
settings file through [JSON fragment extensions][winterm-json-fragment]. Some
examples of these extensions are available here, with their names ending
`-fragment.json`. These files must be placed in the [proper
directories][winterm-json-fragment-loc].

Summarizing from the docs, extensions for the current user would be added as:

`$Env:LocalAppData/Microsoft/Windows Terminal/Fragments/{app-name}/{file-name}.json`

The `{app-name}` must match the corresponding `source` field of the profile in
the main Windows Terminal `settings.json`.

For this case, the Ubuntu fragment would be added as:

`$Env:LocalAppData/Microsoft/Windows Terminal/Fragments/Windows.Terminal.Wsl/Ubuntu.json`

Recall from the docs that the actual file name of the JSON does not matter.

See also the [Dynamic profiles][winterm-dyn-profiles] page for additional
examples of JSON contents.

[winterm-json-fragment]: https://docs.microsoft.com/en-us/windows/terminal/json-fragment-extensions
[winterm-json-fragment-loc]: https://docs.microsoft.com/en-us/windows/terminal/json-fragment-extensions#applications-installed-from-the-web
[winterm-dyn-profiles]: https://docs.microsoft.com/en-us/windows/terminal/dynamic-profiles
