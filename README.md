# Public Sector Acronyms and Abbreviations

Visit https://dxw.github.io/public-sector-acronyms/ to view the latest version.

The list is also available in [JSON format](https://dxw.github.io/public-sector-acronyms/acronyms.json) here.

## Contributing

 - Edit `acronyms.yml` adding your own. Don't worry about ordering, as they are
   sorted automatically.
 - Open a Pull Request
 - Approved changes are published on the above URLs

## Atom snippet

If you use Atom, you might want to add this to ~/.atom/snippets.cson, to ease adding things:

```
'.source.yaml':
  'New acronym':
    'prefix': '-'
    'body': """
    - acronym: $1
      meaning: $2

    $3
    """
```

This would be very annoying in any other YAML file, so best to remove it when you're finished.
