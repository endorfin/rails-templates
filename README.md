rails-templates
===============

USAGE: adding this function to your bash profile.

```
function railsapp {
  template=$1
  appname=$2
  shift 2
  rails new $appname -m http://github.com/endorfin/rails-templates/raw/master/$template.rb $@
}
```