# 🇬🇷 TADS 3 Greek Extension

This project is an experimental extension for TADS 3 (Text Adventure Development System), aiming to bring Greek language support into interactive fiction.
The focus is on:

Handling Greek characters properly in TADS 3.

Supporting basic grammar rules (declensions, conjugations, cases).

Making it possible to write interactive fiction entirely in Greek.

## 🚀 Features (Work in Progress)

✅ Greek character set support.

✅ Basic nouns and verbs.

✅ Gendered articles and cases (nominative, genitive, accusative, vocative).

🛠️ Plans for gendered articles and cases fixes.

🛠️ Future work on verb conjugations and tense handling.


# Prerequisites

Before you begin, make sure you have:

TADS 3 Workbench
 installed (Windows IDE for TADS development).

UTF-8 support enabled in your environment.

Basic familiarity with TADS 3 syntax.

# 📦 Installation

## 1. Clone the repository:
```
git clone https://github.com/DBatziou/GR-TADS.git
```


## 2.Add the extension files to your TADS 3 project directory

In TADS Workbench you follow the path:
*Build→ Settings→ Compiler→ Defines*
There you change *en_us* to *el_gr* and *neu* to *el*
<img width="643" height="409" alt="image" src="https://github.com/user-attachments/assets/37243436-fa3d-4976-9654-4a53af4101bf" />

## 3.Import the extension in your .t source file
In the beginning of your game file you should include the new library.
``` tads
#include <el_gr.h>
```

⚠️In order to use the library extension as well as the example, you need to change the encoding of the files to ISO 8859-7 through your editor (Notepad++ etc). 
In Notepad++ you can do that by following the path:
*Encoding -> Character sets -> Greek -> iso-8859-7*

# DEMO

[🎥 Watch the demo](demo.mp4)
