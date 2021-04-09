# Skafold

Skafold is a template to start creating lightweight web pages quickly and easily.

## Example

Web Scaffold is being used in my [personal webpage](https://alvaro.galisteo.me)

![https://alvaro.galisteo.me]()

## Design

Skafold builds on modern technologies such as HTML5, CSS3 and JavaScript.

It's CSS framework is designed to be modular and easy to use. It is split in several files, which can be used independently:

- `vars.css`: This file contains all the colors used by the framework, based on [Open Color](https://yeun.github.io/open-color/). Its usage is *required*.
- `animate.delay.css`: Implements classes to add delays to animate.css
- `base.css`: Base of the framework. It contains classes to quickly set text alignments, sizes and colors along with utilities for backgrounds, spacing, sizing and dark mode.
- `breakpoints.css`: Adds breakpoints to the spacing, sizing and display utilities implemented by `base.css`.
- `buttons.css`: Implements buttons.
- `forms.css`: Implements styles to quickly layout forms.
- `grid.css`: Implements grid layouts.
- `lang.css`: Utilities for internationalizing content without the need of server side rendering.

Spliting the framework in several files has the following advantages:

- Web pages load faster:
    - Browsers can parallelize fetching styles.
    - If one file changes, the others stay the same, allowing the browser to use cached files
- Code is easier to mantain, as each file does only a specific thing.
- Lightweight pages: Use only what you need.

Clone the repository and checkout `index.html` to see how Skafold works.
