%{
  "_from" => "@primer/octicons@latest",
  "_id" => "@primer/octicons@11.2.0",
  "_inBundle" => false,
  "_integrity" => "sha512-a9ORJaeu7Kt0LCaawQy8S+ZVPDe1qXJvKZraX0b6R0KXkXjL519rpGUDRiGUlskuxEpVf2kmbVYfqGDDlMGLMg==",
  "_location" => "/@primer/octicons",
  "_phantomChildren" => %{},
  "_requested" => %{
    "escapedName" => "@primer%2focticons",
    "fetchSpec" => "latest",
    "name" => "@primer/octicons",
    "raw" => "@primer/octicons@latest",
    "rawSpec" => "latest",
    "registry" => true,
    "saveSpec" => nil,
    "scope" => "@primer",
    "type" => "tag"
  },
  "_requiredBy" => ["#USER", "/"],
  "_resolved" => "https://registry.npmjs.org/@primer/octicons/-/octicons-11.2.0.tgz",
  "_shasum" => "2caaa3a6e56f549be53b4d4004d383fd1120288b",
  "_spec" => "@primer/octicons@latest",
  "_where" => "/Users/mattr-/Code/lee-dohm/octicons-ex",
  "author" => %{"name" => "GitHub Inc."},
  "bugs" => %{"url" => "https://github.com/primer/octicons/issues"},
  "bundleDependencies" => false,
  "dependencies" => %{"object-assign" => "^4.1.1"},
  "deprecated" => false,
  "description" => "A scalable set of icons handcrafted with <3 by GitHub.",
  "devDependencies" => %{
    "ava" => "^0.22.0",
    "eslint" => "^6.5.1",
    "eslint-plugin-github" => "^3.1.3"
  },
  "files" => ["index.js", "index.scss", "build"],
  "homepage" => "https://octicons.github.com",
  "keywords" => ["GitHub", "icons", "svg", "octicons"],
  "license" => "MIT",
  "main" => "index.js",
  "name" => "@primer/octicons",
  "repository" => %{
    "type" => "git",
    "url" => "git+https://github.com/primer/octicons.git"
  },
  "scripts" => %{
    "build" => "script/build.js",
    "lint" => "eslint index.js tests/*.js",
    "test" => "ava --verbose 'tests/*.js'"
  },
  "style" => "index.scss",
  "version" => "11.2.0"
}