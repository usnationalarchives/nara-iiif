# Markdown Reference

See also:

- [Markdown Basics on GitHub](https://help.github.com/articles/markdown-basics/)
- [Mastering Markdown](https://guides.github.com/features/mastering-markdown/)

## Paragraphs

Paragraphs are separated by empty newlines.

    This is a paragraph
    This line is part of the same paragraph

    This is a new paragraph

## Manual Line Breaks

End a line with two or more spaces:

    Roses are red,
    Violets are blue.

## Headers

Add a number of hash signs `#` equal to the header level

    # Header Level 1
    ## Header Level 2
    ## Header Level 3

## Lists

Ordered list use numbers:

    1. Foo
    2. Bar

Unordered lists use dashes or stars:

    - A list item.
    - A list item.
    - A list item.

    * Foo
    * Bar

You can nest them:

    - First
        - Second
    - Bastard
        1. Brownian motion
        2. bupkis
            - BELITTLER
        3. burper
    - Cunning

## Blockquotes

    > Email-style angle brackets
    > are used for blockquotes.

## Phrase Emphasis

    *italic*   **bold**
    _italic_   __bold__

## Links

Inline links:

    An [example](http://example.com/)

Reference-style links:

    An [example][id]. Then, anywhere
    else in the doc, define the link:

    [id]: http://example.com/

Email Links: Email addresses are automatically parsed by Markdown, but if you want to add an email subject or other parameters to the link, you would do it like this:

    [email@example.org](mailto:email@example.org?subject=Insert%20Subject)

## Inline Images

Simple inline images (not recommended) can be inserted with:

    ![alt text](/path/img.jpg)

## Code Spans

Inline code is delimited with backticks

    `code` spans are delimited
    by backticks.

For full pre-formatted code blocks, indent every line of a code block by at least 4 spaces.

        This is a pre-formatted
        code block.

## Shortcodes

Short codes insert rich media into a content well. All short codes are surrounded by double braces <code>[[ ]]</code>. Short codes are in the format <code>[[name parameter parameter ...]]</code>. Specific options below:

### Media Players

You can insert a YouTube, Vimeo, or Soundcloud player by providing the media ID.

Vimeo and YouTube video IDs are in the media item’s URL.

Soundcloud code instructions:

* Go to the track
* CTRL U to open the page source (HTML)
* CTRL F to find sounds:
* Copy the number after sounds: (should be the same number each time, but just go with the first one.

```
[[youtube _TBd-UCwVAY]]
[[vimeo 32732837]]
[[soundcloud 164291294]]
```

### Tweet Embed

You can embed a tweet from Twitter by providing the tweet's serial ID.

```
[[tweet 11111111111]]
[[tweet-right 11111111111]]
[[tweet-left 11111111111]]
```

### Instagram Embed

You can embed a post from Instagram by providing the post's ID.

```
[[instagram 0A4E33NUzT]]
[[instagram-right 0A4E33NUzT]]
[[instagram-left 0A4E33NUzT]]
```

### Facebook Embed

You can embed a post from Facebook by providing the URL fragment for the post in quotes.

```
[[facebook "quakerlobby/posts/10154632916701091"]]
[[facebook-right "quakerlobby/posts/10154632916701091"]]
[[facebook-left "quakerlobby/posts/10154632916701091"]]
```
