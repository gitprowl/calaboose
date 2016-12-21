![Calaboose](http://www.getprowl.com/bull.png)

## Calaboose

Calaboose is a ephemeral jail for untrusted code specifically built for Prowl. In the real world, there are going to be attempts on to "attack a prowlbox" but we are building security so this doesnt happen, or if it does, it can quickly get resolved. 

Calaboose is written in Ruby on Rails. Gems are available from the [releases pag (https://github.com/Montana/calaboose). Download a gem to your app's `vendor/cache` directory, and add this to your Gemfile:

<pre>gem calaboose</pre>

Much like GitHub's Hoosegow, you have to configure Calaboose to connect to a non standard Unix socket

```ruby
        ensure
calaboose.new :socket => '/path/to/socket'
```
