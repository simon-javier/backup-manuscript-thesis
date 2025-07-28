#import "set.typ" : *

#metadata("group 1 start") <prelim-s>
#set page(numbering: "i", number-align: top+right)
#let title = [Probabilistic Detection of Systemic Diseases using Deep Learning on Fingernail Biomarkers]

#let title_page = context counter(page).display()
#page(header: none)[#align(center)[
  #{
    show heading: none
    [== Title Page]
  }
  
  #singleSpacing[*#title*]
  \
  \
  \
  An Undergraduate Thesis \
  Presented to the \
  Faculty of College of Computer Studies \
  Laguna State Polytechnic University \
  Santa Cruz Campus
  \
  \
  \
  In Partial Fulfillment of the requirements for the Degree \
  *BACHELOR OF SCIENCE IN COMPUTER SCIENCE*
  \
  \
  \
  \
  #singleSpacing[
  *
  By: \
  \
  JAVIER, GERON SIMON A. \
  MACAPALLAG, MHAR ANDREI C. \
  VALDEABELLA, SEANREI ETHAN M.
  \
  *
  ]
  \
  \
  Under the supervision of: \
  *Mia M. Villarica*
  #v(1fr)
  *2025*
]]
#pagebreak()