## Jake's resume in R Markdown

This repo contains the files necessary to maintain your CV using R Markdown: I based myself off of the template you can find [here](https://github.com/jakegut/resume). 

The main idea is to store all the information you want to put in your CV in two csv files, one for the entries (`entries.csv`) and one for the references (`references.csv`) so to be able to easily generate and maintain a good looking LaTeX resume.

The files are structured as follows

### entries.csv

- _section_: the section of the CV this row will be printed in

- _what_: the main entry title, displayed in __bold__ at the beginning
- _where_: the location of the entry, displayed on the right
- _desc_: a short description of the entry, displayed below the entry title in _italics_
- _time_: the relevant period, in `start -- end` format, displayed in _italics_ to the right, below the location
- _detail[1-4]_: more detailed description(s) for the entries. They are displayed below the short description

### references.csv


- _name_: the name of the  reference
- _website_: the website of the reference
- _institution_: the affiliation of the reference
- _addr1_: first address line
- _addr2_: second address line
- _addr3_: third address line
- _mail_: email address of the reference

__NOTE__: for the time being only exactly three references are supported in the format shown.

### The .Rmd file

The yaml header of the markdown file allows you to input your name (_author_), email (_email_), github handle (_github_), affiliation (_institution_ and _instadd_ if you wish to add its address) and phone number (_phone_).

At the very beginning the `tidyverse` package (make sure it is installed!) and the .csv files are loaded. The file also sources `cv_functions.R`, which contains the two main functions that turn the .csv files' rows into LaTeX entries.

### cv_functions.R

It contains the main functions used to style the data from a rectangular table to LaTeX entries.

#### print_entries()

Inputs:

- `dt`: a dataframe, created by reading entries.csv
- `sec`: character vector, one of the sections appearing in the dataframe's column "section"
- `detail_type`: either `"item"` or `"text"`, if `"item"` the details for each entry will be treated as items in a bullet list, otherwise they will be pasted to a single paragraph

Output: 

LaTeX entries for a section

#### print_entries()

Inputs:

- `dt`: a dataframe, created by reading references.csv

Output: 

LaTeX entries for the references section

__Please only use this function if you plan to have exactly 3 references__!!
