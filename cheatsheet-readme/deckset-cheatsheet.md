# Use Headings

Combine headings with paragraph text and other elements like lists:

- It's super quick.
- It's super easy.

---

# Separating Slides

To start a new slide, simply put three dashes (`---`) on a single line, with an empty line above and below.

---

# Paragraphs

Use a blank line in between text to start a new paragraph.

You can include a paragraph break by leaving an empty line between the paragraphs.
Otherwise lines will follow on directly like this.

---

# Large Heading

---

## Regular Heading

---

### Small Heading

---

#### Tiny Heading

---

## Combine Headings

### Of Different Sizes

---

# [fit] Make Headings Fit Onto

# [fit] The Slide

---

# Unordered Lists

- Start each bullet point 
- with a dash to create
- an unordered list

---

# Ordered Lists

1. Start each item with
1. a number followed by a dot
1. to create an ordered list

---

# Nested Lists

- You can create nested lists
    1. by indenting
    1. each item with 
    1. 4 spaces
- It's that simple

---

# Asterisk Emphasis

Use single asterisks around text to *emphasise it*.

Or use double asterisks for an **strong emphasis** style.

---

# Underscore Emphasis

Alternatively, you can also use underscores to emphasize: 

Wrap text in single underscores to _emphasize it_. Or use double underscores for the alternative __strong emphasis style__.

---

# Combined Emphasis

Combining underscores with asterisks lets us mix and match the emphasis styles. Play with it — some themes have additional style options for those combinations:

- _**Style 1**_
- __*Style 2*__
- __**Style 3**__

---

# The same *styles* work in **headings**, too.

---

# More Styles

- ~~Strikethrough~~
- Super<sup>script</sup>
- Sub<sub>script</sub>
- `Inline code`

---

> The best way to predict the future is to invent it
-- Alan Kay

---

# Inline Quotes

You can also use a quote together with paragraph text or other elements on the slide:

> The best way to predict the future is to invent it
-- Alan Kay

Prefix the author of the quote with `--`, or leave it out if it's anonymous.

---

![](assets/image1.jpg)

---

![fit](assets/image1.jpg)

---

![](assets/image1.jpg)
![](assets/image1.jpg)
![](assets/image1.jpg)

---

![](assets/image1.jpg)

# Text on Images

Setting text on images applies a filter to the image to make the text more readable.

---

![original](assets/image1.jpg)

# Disable Filter

---

![original 250%](assets/image1.jpg)

# Zoom In 

---

![left](assets/image1.jpg)

# Split Slides

Use the `left` or `right` modifiers to place the image in the left or right half of the slide, respectively.

---

![right fit](assets/image1.jpg)

# Split Slides

Combine `left` or `right` with the `fit` keyword or a percentage to adjust the image scaling.

---

# Combine Text and Images

![inline](assets/image1.jpg)

---

# Fill the Slide

![inline fill](assets/image1.jpg)

---

# Custom Scaling

![inline 50%](assets/image1.jpg)

---

# Image Grids

![inline fill](assets/image1.jpg)![inline fill](assets/image1.jpg)
![inline fill](assets/image1.jpg)

---

![](assets/video.mov)

---

# Inline Videos

![inline](assets/video.mov)

---

# YouTube Embeds!

![](https://www.youtube.com/watch?v=ZwzY1o_hB5Y)

---

![left](assets/video.mov)

# Video Layout Control

Use the same layout modifiers as with images to control the positioning of videos.

- `left` and `right`
- `fit` and `fill`
- Percentage sizing, e.g. `50%`

---

![right autoplay mute](assets/video.mov)

# Video Playback Control

Control video playback by using one of those directives:

- `autoplay`
- `loop`
- `mute`

---

# Syntax Highlighting

Use GitHub style fenced code blocks to specify the language.

```javascript
$.ajax({
  url: "/api/getWeather",
  data: {
    zipcode: 97201
  },
  success: function( data ) {
    $( "#weather-temp" ).html( "<strong>" + data + "</strong> degrees" );
  }
});
```

---

# Automatic Scaling

Don't worry if your code is slightly too long. Deckset scales code blocks to fit automatically.

```ruby
def establish_connection(spec = nil)
  spec     ||= DEFAULT_ENV.call.to_sym
  resolver =   ConnectionAdapters::ConnectionSpecification::Resolver.new configurations
  spec     =   resolver.spec(spec)

  unless respond_to?(spec.adapter_method)
    raise AdapterNotFound, "database configuration specifies nonexistent #{spec.config[:adapter]} adapter"
  end

  remove_connection
  connection_handler.establish_connection self, spec
end
```

---

# Inline `code`

Use code within normal text by enclosing it in backticks.

For example: `func map<A, B>(x: A?, f: A -> B) -> B?`

---

# Presenter Notes 

Deckset turns every paragraph that starts with a `^` into presenter notes and doesn't show this text on the slides.

^ This is how you create a presenter note. You'll see it on the presenter display (with two screens connected) or by using the rehearsal mode.

^ To start another presenter note paragraph, prefix it with a caret again. Deckset will automatically scale the notes down to fit onto the presenter display in case you have a lot of text.

---

# Footers and Slide Numbers

Include persistent custom footers and/or running slide numbers by using directives: 

`footer: © Unsigned Integer UG, 2014`
`slidenumbers: true`

Make sure the two directives start on the *first line* of your markdown file, and ensure there are *no empty lines* between the two.

footer: Use *emphasis* and ~~other~~ text styles if you like

---

# Text Styles in Footer Text

You can use standard text styles such as emphasis in your footer text, just as you would in other places too.
Links

---

# Link to External Resources

In case you're looking for something, you could use [Google](http://google.com) or [Wikipedia](http://wikipedia.com).

Links will be clickable in exported PDFs as well!

---

# Links Between Slides

Define an anchor on the slide you want to link to using standard HTML syntax:

`<a name="link-target"/>`

Then you can link to this [slide](#link-target) easily.

---

# Footnotes

Footnotes are a breeze, for example:

Most of the time, you should adhere to the APA citation style[^1].

Note that footnote references have to be *unique in the markdown file*. This means, that you can also reference footnotes from any slide, no matter where they are defined.

[^1]: For more details on the citation guidelines of the American Psychological Association check out their [website](https://www.library.cornell.edu/research/citation/apa).

---

# Named References

Instead of just numbers, you can also name your footnote references[^Wiles, 1995].

[^Wiles, 1995]: [Modular elliptic curves and Fermat's Last Theorem](http://math.stanford.edu/~lekheng/flt/wiles.pdf). Annals of Mathematics 141 (3): 443–551.

---

# Formulas

Easily include mathematical formulas by enclosing TeX commands in `$$` delimiters. Deckset uses [MathJax](http://www.mathjax.org/) to translate TeX commands into beautiful vector graphics.

$$
\left( \sum_{k=1}^n a_k b_k \right)^2 \leq \left( \sum_{k=1}^n a_k^2 \right) \left( \sum_{k=1}^n b_k^2 \right)
$$

---

# Inline $$Formulas$$

You can also include Formulas in paragraph text. Deckset takes care of adjusting the font size and color to match the surrounding text, for example:

The slope $$a$$ of the line defined by the function $$f(x) = 2x$$ is $$a = 2$$. 

---

# Formula Autoscaling

Don't worry if your equations get really complex. Deckset will scale them to fit onto the slide.

$$
1 +  \frac{q^2}{(1-q)}+\frac{q^6}{(1-q)(1-q^2)}+\cdots =
\prod_{j=0}^{\infty}\frac{1}{(1-q^{5j+2})(1-q^{5j+3})},
\quad\quad \text{for $|q|<1$}.
$$

---

# Use Emojis :+1:

Deckset supports GitHub style emojis: :sunny: :umbrella: :sunflower: :cat: :smile:

Please refer to [emoji-cheat-sheet.com](http://www.emoji-cheat-sheet.com/) for a comprehensive overview of all the supported emojis.
Controlling Line Breaks

---

# Controlling Line Breaks

In paragraph text, Deckset respects when you start a 
new 
line.

This can come in handy in situations where you need more control over how text is broken up into multiple lines.

---

# Use `<br>` for<br>line<br>breaks

You can use the HTML tag `<br>` to insert line breaks in elements that cannot contain regular new lines, such as headings or footers.
