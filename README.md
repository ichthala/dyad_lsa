This repository contains a simple R script for calculating cosine similarities on data sets of a specified format. Here's how to use it:

- Install the package [LSAfun](https://cran.r-project.org/web/packages/LSAfun/LSAfun.pdf)
- Download the TASA semantic space from [this page](http://www.lingexp.uni-tuebingen.de/z2/LSAspaces/)
- Open `dyad_lsa.r` in an R application
- Navigate to a working directory that contains _only_ well-formatted CSV files
- Change the `load` argument at the top of the script to wherever you saved the TASA space
- Run it!

Results will be outputted to a CSV in the working directory with 2 columns:
- `dyad`: the dyad ID
- `cosine_sim`: the cosine similarity for the dyad

If the dyad was missing a user or one of the users had no associated text, then that dyad's ID will still appear in the output file, but with a cosine_sim value of `NA`.
