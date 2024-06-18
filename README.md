# About
- `@lune/net` wrapper inspired to [next.js](https://github.com/vercel/next.js)
- Use your file system to serve your APIs and static files similar to next.js

# Note
- This is for static files only. so there's no SSR, react.
- This does not entirely imitate from next.js.
- Only `app` router is supported. (`pages` not allowed)
- `nexty-lune` will look for `{project path}/app` and `{project path}/public`

# Currently implemented
- `app/router.luau`

# TODO
- `app/layout.html`
- `app/not-found.luau`
- `public`

# How to use
- run `git submodule add [this git url]` to add this lune script into your repo

# Example CLI usage
```sh
lune run nexty-lune dev --port 8080 --project "path/to/project"
```
