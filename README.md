ZXCVBN password strength estimator with Czech (CS-CZ) dictionaries. Other than localization of the feedback and wordlists, the API is identical to [original zxcvbn.js](https://github.com/dropbox/zxcvbn).
 
# Installation
Download [dist/zxcvbn.js](https://raw.githubusercontent.com/veproza/zxcvbn/master/dist/zxcvbn.js), then add script reference to your HTML
```html
<script src="path/to/zxcvbn.js"></script>
```

# Usage
Please refer to original ZXCVBN [Usage section](https://github.com/dropbox/zxcvbn#usage), as the API is completely identical.

# Demo
You can try the estimator on the [demo](https://1gr.cz/test/marcel/zxcvbn/index.html) (with full feedback and reasoning displayed), or you can see a live deployment at [idnes.cz Registration page](https://muj.idnes.cz/registrace.aspx).
> Tip: Try typical Czech passwords such as `heslo` (Czech for *password*), `honzik` (frequent name) or `ěščřžýá` (keyboard walk on Czech keyboard). Compare results with [English zxcvbn demo](https://lowe.github.io/tryzxcvbn/). 

# About the dictionaries
The Czech dictionaries were constructed using the original zxcvbn's scripts, just using Czech sources.
- Wikipedia wordlist used Czech Wikipedia mutation
- TV+Film wordlist used a query for Czech subtitles on OpenSubtitles
- Names and surnames were pulled off Czech Statistical Offices' database
- Passwords were obtained from Exploit.in and AntiPublic combolists, `grep`-ed for lines containing `\.cz` (as in name@email<b>.cz</b>:password). There are some artefacts remaining (like `a838hfiD` being #7 most popular password, which is not likely), but overall, the wordlist seems to reflect real world reasonably well.

# Size
Addition of Czech dictionaries doubled the number of dictionaries to be shipped. To keep the size on par with the original zxcvbn, the length of each dictionary in the built library (in `/dist/zxcvbn.js`) was decreased to one-half of the original value. The final file is 409 kB gzipped, similar to original's 390 kB.
> Tip: If you can use [zopfli](https://github.com/google/zopfli) gzip algorithm, you can reduce the size to 393 kB.
 
If you wish to change the dictionary size (increase, decrease, or change Czech:English ratio), you can do so in `/data-scripts/build_frequency_lists.py`.   

# Authors
Localization and testing was done by [idnes.cz](https://www.idnes.cz/) developers.

# License
MIT, same as original.