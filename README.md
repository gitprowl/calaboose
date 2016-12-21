![Calaboose](http://www.getprowl.com/bull.png)

## Calaboose

Calaboose is an ephemeral jail for untrusted code specifically built for Prowl. In the real world, there are going to be attempts to "attack a prowlbox" but we are building security so this doesnt happen, or if it does, it can quickly get resolved. 

Calaboose is written in Ruby on Rails. Download the calaboose gem to your app's `vendor/cache` directory, and add this to your Gemfile:

<pre>gem calaboose</pre>

Much like GitHub's <a href="http://www.github.com/github/hoosegow">Hoosegow</a>, you have to configure Calaboose to connect to a non standard Unix socket:

```ruby
ensure
calaboose.new :socket => '/path/to/socket'
```

As you can see the code above for Calaboose, ```ensure``` ensures that the code is always evaluated. That's why it's called ensure. So, it is equivalent to Java's and C#'s ```finally```. It's for high security, and ensuring the code is read before executed, ensure is kind of obscure, but one of the charms in Ruby.

Calaboose is not fully complete, and won't be until March 2017. As of now I'm keeping the source open for the people.

Built for <a href="http://www.getprowl.com">Prowl</a>. Written by <a href="www.montanamendy.com">Montana Mendy</a>.
