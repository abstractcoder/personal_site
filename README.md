# Personal Site Generator

This is a personal website generator that has both highly and weakly held opinons about how you should do websites. In order to use this you will need to know about Elixir and EEX templates.

### Goals

- Be as straight forward as possible to develop and deploy a static site.
- All build artifacts will be compiled and copied to `./_deploy` using `mix deploy` from there send it to your static host of choice. I like Netlify.
- All static files live in `./static` and will be copied to directly to the folder `./_deploy/static`.
- All files you should need to edit daily will live in `./templates`.
  - If you have a file in there it should be html or markdown as EEX Templates `.html.eex` or `.md.eex`.
  - If you want a static page feel free to put in the top level directory ofr `./templates`
  - All layouts will go into `./templates/layouts` and contain a  `<%= @body %>` element for where you want the page to go.
- All Blog Posts should live in `./templates/blog` and be html or markdown EEX templates and will be deployed to `./_deploy/blog/`
- Every page and post may contain a front matter section
  - Format: `key=val\n`
  - Seperated from the rest of the document with `\n!!!\n`
- A development server is included and may be used like `mix serve`, the reuqested file will compile fully on each request.
- Global bindings go into `./config/config.exs` in the `personal_site` application.

### Anti-Goals
- Be everything for everyone.
- Run as a binary on your system.
- Making you, the user, "keep up to date"

# Q&A

## How To Use

Fork this repository, git clone it locally and then run `mix deps.get`. From there `mix serve` and `mix deploy` will be available to you.

## I don't like how you did something?

Great! Fork the repository, and edit the `lib/personal_site/static.ex` to change how it works! At time of writing the entire project is 145 lines of code.

Want to change the front matter format?
```
  $ grep -n \!\!\! ./lib/**/*.ex
  ./lib/static.ex:10:    parts = String.split(contents, "\n!!!\n")
```
Edit line 10 of static.ex

## But couldn't you make this a configuration?

I could but also you could edit the code.

## Why?

I personally really hate dealing with dependencies, versions changing and docs from other people. Usually if I can't find something in the docs with a ctrl-f or a stack overflow post I end up reading the code anyways.

And I feel that with tools like Jekyll and now the beast Gastby we've lost site of why computers are so good. We tell them to do stuff and they do it. If you don't like how the Jekyll you could fork it, change it and then you gotta maintain a custom fork of Jekyll and anyone who follows you also needs to know what and why you did it.

With this you fork the repo immediately and we skip the part where you read docs that I or the community pretend to have time to keep up to date. The only dependency for your machine is Elixir 1.6 at time of writing but I wager this would work with anyu 1.x.x version now and into the future. The only Elixir specific depdencies are Plug and Earmark for the development server and Markdown respectfully. If you don't like nor need them you can change it and change the 3ish spots they get used.

In 6months when you've forgotten you have a website and have a new machine the only thing you need to do is install Elixir and clone the repo. And all of the code can easily be read in a single sitting you are hitting the ground running.

## Something about security

*Do Not* use the development server in production. If you then that's on you.
*DO* check the outputs in deploy if you are paranoid.

## TODO
- [ ] add a blog listing with front matter to the bindings of every page.
- [ ] figure out the head binding/front-matter or dont

## Liscense

### BSD-3
Copyright 2019 Jason Stiebs

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
